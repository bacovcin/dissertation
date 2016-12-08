#! /usr/bin/env Rscript
library(rstan)
library(xtable)
load('analysis/rdata-tmp/britdat.RData')
real <- subset(britdat, NVerb!='SEND'&!is.na(isTo))
brit.act <- subset(real, Voice=='ACT'&NVerb!='NONREC'&!is.na(year)&!is.na(Adj)&!is.na(isDatAcc))

brit.act<-subset(brit.act,(year<=1100&isTo==0) | year>1100)
parameters <- as.data.frame(cbind(read.csv('analysis/parameters/parameters.csv'),
								  read.csv('analysis/parameters/rise_parameters.csv'))

brit.act <- subset(brit.act,year<=parameters$end_data)




fit1<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit1.RDS')
fit2<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit2.RDS')
fit3<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit3-resample.RDS')
fit4<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit4-resample.RDS')

a1 <- as.data.frame(extract(fit1))
a2 <- as.data.frame(extract(fit2))
a3 <- fit3
a4 <- fit4

load('analysis/rdata-tmp/RoT-dat3.RData')
load('analysis/rdata-tmp/RoT-dat4.RData')

a3$s.year <- stan.dat3$t[a3$s]
a3$re.year <- a3$s.year * sd(brit.act$year) + mean(brit.act$year)

a4$s.year <- stan.dat4$t[a4$s]
a4$re.year <- a4$s.year * sd(brit.act$year) + mean(brit.act$year)

re.diff <- a4$re.year - a3$re.year

slope2.diff <- a4$Slope2 - a3$Slope2

slope1a.diff <- a2$Slope - a1$Slope

slope1b.diff <- a3$Slope1 - a1$Slope

slope1c.diff <- a4$Slope1 - a1$Slope

slope1d.diff <- a4$Slope1 - a2$Slope

outtab <- as.table(rbind(
quantile(a3$re.year,c(0.05,0.5,0.95)),
quantile(re.diff,c(0.05,0.5,0.95)),
quantile(slope2.diff,c(0.05,0.5,0.95)),
quantile(slope1a.diff,c(0.05,0.5,0.95)),
quantile(slope1b.diff,c(0.05,0.5,0.95)),
quantile(slope1c.diff,c(0.05,0.5,0.95)),
quantile(slope1d.diff,c(0.05,0.5,0.95))
						 ))

rownames(outtab)<-c(
					'Reanalysis Year (Nouns)',
					'Reanalysis Difference',
					'CH2: Slope Difference',
					'TR-Noun Pronoun Slope Difference',
					'RT-TR Noun Slope Diffence',
					'RT Pronoun - TR Noun Slope Diff.',
					'RT-TR Pronoun Slope Difference'
					)
colnames(outtab) <- c('Lower Bound (5%)','Point Estimate','Upper Bound (95%)')

con <- file('output/tables/to-mcmc.tex','w')
sink(con)
print(xtable(outtab,label='tab:to-mcmc',caption='Parameter results from Bayesian Inference, CH2=Fall of \\textit{to}, TR = Theme--Recipient, RT=Recipient--Theme,))
sink()
close(con)
