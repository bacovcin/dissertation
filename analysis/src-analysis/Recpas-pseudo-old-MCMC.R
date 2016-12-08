#! /usr/bin/env Rscript
library(ggplot2)
library(dplyr)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

load('analysis/rdata-tmp/britdat.RData')
load('analysis/rdata-tmp/old-pseudopassives.RData')

brit.pas <- subset(britdat,Voice=='PAS'&NVerb!='SEND'&NVerb!='NONREC')
recpas <- subset(brit.pas,Envir%in%c('Recipient Passive (oblique)','Recipient Passive Theme Topicalisation (oblique)','Recipient Passive','Recipient Passive Theme Topicalisation'))

recpas$isNom <- factor(recpas$Envir)
levels(recpas$isNom)<-c(0,0,1,1)
recpas$isNom <- as.numeric(as.character(recpas$isNom))

pdat <- data.frame(Year=pseu.old$Year,Val=pseu.old$Val,Type='Pseudopassive')
bdat <- data.frame(Year=recpas$year,Val=recpas$isNom,Type='Recipient Passive')

joint.data <- as.data.frame(rbind(pdat,bdat))

joint.data$zYear <- (joint.data$Year-mean(joint.data$Year))/sd(joint.data$Year)

pseuscale <- mean(joint.data$Val[joint.data$Year>=1700&joint.data$Type=='Pseudopassive'],na.rm=T)
ditscale <- mean(joint.data$Val[joint.data$Year>=1700&joint.data$Type=='Recipient Passive'],na.rm=T)

x1 <- joint.data$zYear[joint.data$Type=='Pseudopassive']
x2 <- joint.data$zYear[joint.data$Type=='Recipient Passive']

y1 <- joint.data$Val[joint.data$Type=='Pseudopassive']
y2 <- joint.data$Val[joint.data$Type=='Recipient Passive']

parameters <- read.csv('analysis/parameters/parameters.csv')

stan.dat <- list(PseudoP = pseuscale,
				 DitP = ditscale,
				 priorSD = parameters$prior_sd,
				 N1 = length(x1),
				 N2 = length(x2),
				 x1 = x1,
				 x2 = x2,
				 y1 = y1,
				 y2 = y2)
glm1 <- glm(y1~x1,family='binomial')
glm2 <- glm(y2~x2,family='binomial')

stan.init <- list(Int=coef(glm1)[1],
				  Slope=coef(glm1)[2],
				  DitInt=coef(glm2)[1]-coef(glm1)[1],
				  DitSlope=coef(glm2)[2]-coef(glm1)[2])


inits <- list()
for (i in 1:parameters$nchains) {
	inits[[letters[i]]] <- stan.init
}

if (parameters$prior_dist == 'cauchy') {
	fit <- stan(file = 'analysis/src-analysis/stan-models/Pseudo-cauchy.stan', data=stan.dat,
	    iter = parameters$iters,
		chains = parameters$nchains, 
	    init=inits,
	    seed=parameters$seed,
	    verbose = T)
} else if (parameters$prior_dist == 'normal') {
	fit <- stan(file = 'analysis/src-analysis/stan-models/Pseudo-normal.stan', data=stan.dat,
	    iter = parameters$iters,
		chains = parameters$nchains, 
	    init=inits,
	    seed=parameters$seed,
	    verbose = T)
}

saveRDS(fit,file='analysis/mcmc-runs/Pseudo-old-Stan-Fit.RDS')
