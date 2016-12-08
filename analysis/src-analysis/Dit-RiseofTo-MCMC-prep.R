#! /usr/bin/env Rscript
library(ggplot2)
library(dplyr)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

load('analysis/rdata-tmp/britdat.RData')

britdat$isIOPro <- factor(britdat$IO)
levels(britdat$isIOPro)<-c(0,1)
britdat$isIOPro <- as.numeric(as.character(britdat$isIOPro))

britdat$isDOPro <- factor(britdat$DO)
levels(britdat$isDOPro)<-c(0,1)
britdat$isDOPro <- as.numeric(as.character(britdat$isDOPro))

real <- subset(britdat, NVerb!='SEND'&!is.na(isTo))

brit.act <- subset(real, Voice=='ACT'&NVerb!='NONREC'&!is.na(year)&!is.na(Adj)&!is.na(isDatAcc)&DO=='Theme Noun')
# Create numeric variables for everything (and zscore year)

brit.act$isAdj <- factor(brit.act$Adj)
levels(brit.act$isAdj) <- c(1,0,1,0)
brit.act$isAdj<-as.numeric(as.character(brit.act$isAdj))

brit.act$NAdj <- factor(brit.act$isAdj)
levels(brit.act$NAdj)<-c('Not Adjacent','Adjacent')

# Remove spurious Old English examples with 'to' (actually goals)
brit.act<-subset(brit.act,(year<=1100&isTo==0) | year>1100)

parameters <- as.data.frame(cbind(read.csv('analysis/parameters/parameters.csv'),
								  read.csv('analysis/parameters/rise_parameters.csv')))

brit.act <- subset(brit.act,year<=parameters$end_data)

# Z-score year for computational reasons
brit.act$zYear <- (brit.act$year - mean(brit.act$year))/sd(brit.act$year)

# Extract predictors and dependent variables for each context
dat1 <- filter(brit.act,isDatAcc==0,isIOPro==0) %>% group_by(zYear) %>% summarize(n=sum(isTo),N=n())
dat2 <- filter(brit.act,isDatAcc==0,isIOPro==1) %>% group_by(zYear) %>% summarize(n=sum(isTo),N=n())
dat3 <- filter(brit.act,isDatAcc==1,isIOPro==0) %>% group_by(zYear) %>% summarize(n=sum(isTo),N=n())
dat4 <- filter(brit.act,isDatAcc==1,isIOPro==1) %>% group_by(zYear) %>% summarize(n=sum(isTo),N=n())


zStart <- (parameters$start_search - mean(brit.act$year))/sd(brit.act$year)
zEnd <- (parameters$end_search - mean(brit.act$year))/sd(brit.act$year)

NormalPrior <- NA
if (parameters$prior_dist == 'cauchy') {
    NormalPrior <- 0
} else if (parameters$prior_dist == 'normal') {
    NormalPrior <- 1
}

stan.dat1 <- list(priorSD = parameters$prior_sd,
				  NormalPrior = NormalPrior,
				  T = dim(dat1)[1],
				  t = dat1$zYear,
				  n = dat1$n,
				  N = dat1$N)

stan.dat2 <- list(priorSD = parameters$prior_sd,
				  NormalPrior = NormalPrior,
				  T = dim(dat2)[1],
				  t = dat2$zYear,
				  n = dat2$n,
				  N = dat2$N)

start3 <- which(dat3$zYear==dat3$zYear[dat3$zYear >= zStart][1])
end3 <- which(dat3$zYear==dat3$zYear[dat3$zYear >= zEnd][1])

stan.dat3 <- list(priorSD = parameters$prior_sd,
				  NormalPrior = NormalPrior,
				  T = dim(dat3)[1],
				  t = dat3$zYear,
				  n = dat3$n,
				  N = dat3$N,
				  REstart = start3,
				  REend = end3)

start4 <- which(dat4$zYear==dat4$zYear[dat4$zYear >= zStart][1])
end4 <- which(dat4$zYear==dat4$zYear[dat4$zYear >= zEnd][1])

stan.dat4 <- list(priorSD = parameters$prior_sd,
				  NormalPrior = NormalPrior,
				  T = dim(dat4)[1],
				  t = dat4$zYear,
				  n = dat4$n,
				  N = dat4$N,
				  REstart = start4,
				  REend = end4)

save(stan.dat1,file='analysis/rdata-tmp/RoT-dat1.RData')
save(stan.dat2,file='analysis/rdata-tmp/RoT-dat2.RData')
save(stan.dat3,file='analysis/rdata-tmp/RoT-dat3.RData')
save(stan.dat4,file='analysis/rdata-tmp/RoT-dat4.RData')
