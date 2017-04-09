#!/usr/bin/env Rscript
require(rstanarm)
options(mc.cores = parallel::detectCores())

load('analysis/rdata-tmp/britdat.RData')
britdat$era2 <- cut(britdat$year,breaks=c(700,1100,1450,1750,2000),labels=c('Old English','Middle English','Early Modern English','Late Modern English'))

britdat$isIOPro <- factor(britdat$IO)
levels(britdat$isIOPro)<-c(0,1)
britdat$isIOPro <- as.numeric(as.character(britdat$isIOPro))

britdat$isDOPro <- factor(britdat$DO)
levels(britdat$isDOPro)<-c(0,1)
britdat$isDOPro <- as.numeric(as.character(britdat$isDOPro))

britdat2<-subset(britdat,!is.na(isDatAcc)&NVerb!='NONREC'&NVerb!='SEND'&era>=1200)

britdat2$isPas<-factor(britdat2$Voice)
levels(britdat2$isPas)<-c(0,1)
britdat2$isPas<-as.numeric(as.character(britdat2$isPas))

britdat2$Order<-factor(britdat2$isDatAcc)
levels(britdat2$Order)<-c('Theme-Recipient','Recipient-Theme')

pas <- read.csv('analysis/data/pas.dat',sep='\t')

pas$isPas<-factor(pas$Voice)
levels(pas$isPas)<-c(0,NA,1,NA)
pas$isPas<-as.numeric(as.character(pas$isPas))

pas<-subset(pas,!is.na(isPas))

bdat <- data.frame(year=britdat2$year,Order=britdat2$Order,isPas=britdat2$isPas)
pasdat <- data.frame(year=as.numeric(as.character(pas$YoC)),Order='General',isPas=pas$isPas)
joint<-subset(as.data.frame(rbind(bdat,pasdat)),year>=1200)

joint$zYear <- (joint$year - mean(joint$year))/sd(joint$year)
joint$isRT <- factor(joint$Order)
levels(joint$isRT)<- c(0,1,0)
joint$isRT <- as.numeric(as.character(joint$isRT))

joint$isTR <- factor(joint$Order)
levels(joint$isTR)<- c(1,0,0)
joint$isTR <- as.numeric(as.character(joint$isTR))

small <- subset(joint,Order!='General')

# Read in parameters
param <- read.csv('analysis/parameters/parameters.csv')
if (param$prior_dist == 'cauchy') {
	pasmod <- stan_glm(isPas ~ zYear*isTR,
                              data = small,
                              family = binomial(link = "logit"), 
                              prior = cauchy(location=0,
											 scale=param$prior_sd), 
                              prior_intercept = cauchy(location=0,
													   scale=param$prior_sd),
							  iter = param$iters,
                              chains = param$nchains, seed = param$seed)
} else if (param$prior_dist == 'normal') {
	pasmod <- stan_glm(isPas ~ zYear*isTR,
                              data = small,
                              family = binomial(link = "logit"), 
                              prior = normal(location=0,
											 scale=param$prior_sd), 
                              prior_intercept = normal(location=0,
													   scale=param$prior_sd),
							  iter = param$iters,
                              chains = param$nchains, seed = param$seed)
}
saveRDS(pasmod,file='analysis/mcmc-runs/pas.RDS')
