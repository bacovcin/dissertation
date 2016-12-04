#! /usr/bin/env Rscript
library(ggplot2)
library(dplyr)
library(rstan)
library(rstanarm)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

load('analysis/rdata-tmp/britdat.RData')
britdat$era2 <- cut(britdat$year,breaks=c(700,1100,1450,1750,2000),labels=c('Old English','Middle English','Early Modern English','Late Modern English'))

britdat$isIOPro <- factor(britdat$IO)
levels(britdat$isIOPro)<-c(0,1)
britdat$isIOPro <- as.numeric(as.character(britdat$isIOPro))

britdat$isDOPro <- factor(britdat$DO)
levels(britdat$isDOPro)<-c(0,1)
britdat$isDOPro <- as.numeric(as.character(britdat$isDOPro))

real <- subset(britdat, NVerb!='SEND'&!is.na(isTo))

brit.act <- subset(real, Voice=='ACT'&NVerb!='NONREC'&!is.na(year)&!is.na(Adj)&!is.na(isDatAcc))
# Create numeric variables for everything (and zscore year)

brit.act$isAdj <- factor(brit.act$Adj)
levels(brit.act$isAdj) <- c(1,0,1,0)
brit.act$isAdj<-as.numeric(as.character(brit.act$isAdj))

brit.act$NAdj <- factor(brit.act$isAdj)
levels(brit.act$NAdj)<-c('Not Adjacent','Adjacent')

# Remove spurious Old English examples with 'to' (actually goals)
brit.act<-subset(brit.act,(year<=1100&isTo==0) | year>1100)

# Z-score year for computational reasons
brit.act$zYear <- (brit.act$year - mean(brit.act$year))/sd(brit.act$year)

# Extract predictors and dependent variables for each context
x1 <- brit.act$zYear[brit.act$isDatAcc==0 & brit.act$isIOPro == 0]
x2 <- brit.act$zYear[brit.act$isDatAcc==0 & brit.act$isIOPro == 1]
x3 <- brit.act$zYear[brit.act$isDatAcc==1 & brit.act$isIOPro == 0]
x4 <- brit.act$zYear[brit.act$isDatAcc==1 & brit.act$isIOPro == 1]

y1 <- brit.act$isTo[brit.act$isDatAcc==0 & brit.act$isIOPro == 0]
y2 <- brit.act$isTo[brit.act$isDatAcc==0 & brit.act$isIOPro == 1]
y3 <- brit.act$isTo[brit.act$isDatAcc==1 & brit.act$isIOPro == 0]
y4 <- brit.act$isTo[brit.act$isDatAcc==1 & brit.act$isIOPro == 1]

# Try to identify inflection point
test <- data.frame(year=seq(1200,1700,1))
test$zYear <- (test$year - mean(brit.act$year))/sd(brit.act$year)
diffYears <- 25/sd(brit.act$year)

for (i in 1:dim(test)[1]) {
	test$meanBef[i] <- mean(y3[x3<(test$zYear[i]-diffYears/2)&(x3>=test$zYear[i]-(diffYears+diffYears/2))],na.rm=T)
	test$meanSelf[i] <- mean(y3[x3<=(test$zYear[i]+diffYears/2)&x3>=(test$zYear[i]-diffYears/2)],na.rm=T)
	test$meanAft[i] <- mean(y3[x3>(test$zYear[i]+diffYears/2)&x3<=(test$zYear[i]+diffYears+diffYears/2)],na.rm=T)
}

test$BefDiff<-test$meanSelf-test$meanBef
test$AftDiff<-test$meanSelf-test$meanAft
test$SumDiff<-test$BefDiff+test$AftDiff

ryGuess<-test[which.max(test$SumDiff),'zYear']
#     year      zYear meanBef meanSelf   meanAft BefDiff   AftDiff  SumDiff
# 162 1361 -0.8612881     0.4        1 0.5208333     0.6 0.4791667 1.079167
test <- data.frame(year=seq(1200,1700,1))
test$zYear <- (test$year - mean(brit.act$year))/sd(brit.act$year)
diffYears <- 25/sd(brit.act$year)

for (i in 1:dim(test)[1]) {
	test$meanBef[i] <- mean(y4[x4<(test$zYear[i]-diffYears/2)&(x4>=test$zYear[i]-(diffYears+diffYears/2))],na.rm=T)
	test$meanSelf[i] <- mean(y4[x4<=(test$zYear[i]+diffYears/2)&x4>=(test$zYear[i]-diffYears/2)],na.rm=T)
	test$meanAft[i] <- mean(y4[x4>(test$zYear[i]+diffYears/2)&x4<=(test$zYear[i]+diffYears+diffYears/2)],na.rm=T)
}

test$BefDiff<-test$meanSelf-test$meanBef
test$AftDiff<-test$meanSelf-test$meanAft
test$SumDiff<-test$BefDiff+test$AftDiff

ryProGuess<-test[which.max(test$SumDiff),'zYear']

rySD <- abs(ryGuess-ryProGuess)

ryMeans <- mean(c(ryGuess, ryProGuess))

parameters <- read.csv('analysis/parameters/parameters.csv')

stan.dat <- list(priorSD = parameters$prior_sd,
		 ryMean = ryMeans,
		 ryProMean = ryMeans,
		 rySD = rySD,
		 N1 = length(x1),
		 N2 = length(x2),
		 N3 = length(x3),
		 N4 = length(x4),
		 x1 = x1,
		 x2 = x2,
		 x3 = x3,
		 x4 = x4,
		 y1 = y1,
		 y2 = y2,
		 y3 = y3,
		 y4 = y4)
glm1 <- glm(y1~x1,family='binomial')
glm2 <- glm(y2~x2,family='binomial')
glm3b <- glm(y3[x3>ryGuess]~x3[x3>ryGuess],family='binomial')
glm3a <- glm(y3[x3<ryGuess]~x3[x3<ryGuess],family='binomial')
glm4b <- glm(y4[x4>ryProGuess]~x4[x4>ryProGuess],family='binomial')
glm4a <- glm(y4[x4<ryProGuess]~x4[x4<ryProGuess],family='binomial')

stan.init <- list(ry=ryGuess,
		  rypro=ryProGuess,
		  Int1=coef(glm1)[1],
		  Slope1=coef(glm1)[2],
		  ProInt1=coef(glm2)[1]-coef(glm1)[1],
		  ProSlope1=coef(glm2)[2]-coef(glm1)[2],
		  RTInt1=coef(glm3a)[1]-coef(glm1)[1],
		  RTSlope1=coef(glm3a)[2]-coef(glm1)[2],
		  Slope2=coef(glm3b)[2],
		  ProSlope2=coef(glm4b)[2]-coef(glm3b)[2],
		  ProRTInt1=NA,
		  ProRTSlope1=NA)

stan.init$ProRTInt1 <- coef(glm4a)[1]-(stan.init$Int1+stan.init$ProInt1+stan.init$RTInt1)
stan.init$ProRTSlope1 <- coef(glm4a)[2]-(stan.init$Slope1+stan.init$ProSlope1+stan.init$RTSlope1)

total_iters <- parameters$init_iters*parameters$big_iter_mult

inits <- list()
for (i in 1:parameters$nchains) {
	inits[[letters[i]]] <- stan.init
}

if (parameters$prior_dist == 'cauchy') {
	fit <- stan(file = 'analysis/src-analysis/stan-models/ToReanalysis-cauchy.stan', data=stan.dat,
	    iter = total_iters,
		chains = parameters$nchains, 
		warmup = total_iters - parameters$init_iters,
	    init=inits,
	    seed=parameters$seed,
	    verbose = T)
} else if (parameters$prior_dist == 'normal') {
	fit <- stan(file = 'analysis/src-analysis/stan-models/ToReanalysis-cauchy.stan', data=stan.dat,
	    iter = total_iters,
		chains = parameters$nchains, 
		warmup = total_iters - parameters$init_iters,
	    init=inits,
	    seed=parameters$seed,
	    verbose = T)
}

saveRDS(fit,file='analysis/mcmc-runs/ToRaising-Stan-Fit.RDS')
