#! /usr/bin/env Rscript
library(ggplot2)
library(dplyr)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

load('analysis/rdata-tmp/britdat.RData')
pseu <- read.csv('analysis/data/pseudopassives.dat',sep='\t')

brit.pas <- subset(britdat,Voice=='PAS'&NVerb!='SEND'&NVerb!='NONREC')
recpas <- subset(brit.pas,Envir%in%c('Recipient Passive (oblique)','Recipient Passive Theme Topicalisation (oblique)','Recipient Passive','Recipient Passive Theme Topicalisation'))

recpas$isNom <- factor(recpas$Envir)
levels(recpas$isNom)<-c(0,0,1,1)
recpas$isNom <- as.numeric(as.character(recpas$isNom))

pseu$isPas <- factor(pseu$Passive)
levels(pseu$isPas)<-c(0,1)
pseu$isPas <- as.numeric(as.character(pseu$isPas))

vlevels <- group_by(pseu,Verb)%>%summarise(level=mean(isPas,na.rm=T))
nonverb <- c('NONPSEUDO',vlevels$Verb[vlevels$level<=0.01])

pseu2 <- subset(pseu,!(Verb %in% nonverb)&!is.na(Passive))

pdat <- data.frame(Year=pseu2$YoC,Val=pseu2$isPas,Type='Pseudopassive')
bdat <- data.frame(Year=recpas$year,Val=recpas$isNom,Type='Recipient Passive')

joint.data <- as.data.frame(rbind(pdat,bdat))

fit <- readRDS('analysis/mcmc-runs/Pseudo-Stan-Fit.RDS')

a <- as.data.frame(extract(fit))

pred <- expand.grid(year = min(joint.data$Year):max(joint.data$Year),
					Type = c('Pseudopassive','Recipient Passive'))

pred$x <- (pred$year-mean(joint.data$Year))/sd(joint.data$Year)

pseup <- mean(joint.data$Val[joint.data$Year>=1700&joint.data$Type=='Pseudopassive'],na.rm=T)
ditp <- mean(joint.data$Val[joint.data$Year>=1700&joint.data$Type=='Recipient Passive'],na.rm=T)
Int <- mean(a$Int)
Slope <- mean(a$Slope)
DitInt <- mean(a$DitInt)
DitSlope <- mean(a$DitSlope)

pred$y <- NA

pred$y[pred$Type=='Pseudopassive']<-pseup/(1+exp(-(Int+
												   Slope*pred$x[pred$Type=='Pseudopassive'])))
pred$y[pred$Type!='Pseudopassive']<-ditp/(1+exp(-(Int+
												  Slope*pred$x[pred$Type!='Pseudopassive']+
												  DitInt+
												  DitSlope*pred$x[pred$Type!='Pseudopassive'])))

joint.data$era <- as.numeric(as.character(cut(joint.data$Year,
											  breaks=seq(600,2000,100),
											  labels=seq(650,1950,100))))
joint.points <- group_by(joint.data,era,Type)%>%summarise(Val=mean(Val),
														  n=n())

pdf(file='output/images/recpas-pseudo.pdf')
ggplot(joint.points,aes(era,Val,colour=Type))+geom_point(aes(size=n))+
	geom_line(data=pred,aes(x=year,y=y))+
	scale_x_continuous(name='Year of Composition',
					   breaks=seq(900,1900,100),
					   labels=seq(900,1900,100))+
	scale_y_continuous(name='% Nominative Passive',
					   breaks=c(0,.2,.4,.5,.6,.8,1),
					   labels=c('0%','20%','40%','50%',
								'60%','80%','100%'))+
	scale_colour_discrete(name='Type of Clause')+
	scale_size_continuous(name='Number of Tokens/century')+
	coord_cartesian(ylim=c(0,1))
dev.off()
