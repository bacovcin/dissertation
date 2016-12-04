#! /usr/bin/env Rscript
library(rstan)
library(xtable)
load('analysis/rdata-tmp/britdat.RData')
real <- subset(britdat, NVerb!='SEND'&!is.na(isTo))
brit.act <- subset(real, Voice=='ACT'&NVerb!='NONREC'&!is.na(year)&!is.na(Adj)&!is.na(isDatAcc))
fit<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit.RDS')

a <- as.data.frame(extract(fit))
a$ry.unz <- a$ry*sd(brit.act$year)+mean(brit.act$year)
a$rypro.unz <- a$rypro*sd(brit.act$year)+mean(brit.act$year)


outtab <- as.table(rbind(quantile(a$ry.unz,c(.05,.5,.95)),
						 quantile(a$rypro.unz,c(.05,.5,.95)),
						 quantile(a$Int1,c(.05,.5,.95)),
						 quantile(a$Slope1,c(.05,.5,.95)),
						 quantile(a$ProInt1,c(.05,.5,.95)),
						 quantile(a$RTInt1,c(.05,.5,.95)),
						 quantile(a$ProRTInt1,c(.05,.5,.95)),
						 quantile(a$ProSlope1,c(.05,.5,.95)),
						 quantile(a$RTSlope1,c(.05,.5,.95)),
						 quantile(a$ProRTSlope1,c(.05,.5,.95)),
						 quantile(a$Slope2,c(.05,.5,.95)),
						 quantile(a$ProSlope2,c(.05,.5,.95))
						 ))

rownames(outtab)<-c('Reanalysis Year for Nouns',
					'Reanalysis Year for Pronouns',
					'CH1: Intercept',
					'CH1: Year (z-scored)',
					'CH1: Recipient Pronoun',
					'CH1: Recipient--Theme Order',
					'CH1: Order Pronoun Interaction',
					'*CH1: Year Pronoun Interaction',
					'*CH1: Year Order Interaction',
					'*CH1: Year Order Pronoun Interaction',
					'CH2: Year (z-scored)',
					'*CH2: Year Pronoun Interaction'
					)
colnames(outtab) <- c('Lower Bound (5%)','Point Estimate','Upper Bound (95%)')

con <- file('output/tables/to-mcmc.tex','w')
sink(con)
print(xtable(outtab,label='tab:to-mcmc',caption='Parameter results from Bayesian Inference, CH1=Rise of \\textit{to}, CH2=Fall of \\textit{to}, * indicates rows relevant for the Constant Rate Effect'))
sink()
close(con)
