#! /usr/bin/env Rscript
library(ggplot2)
library(xtable)
library(dplyr)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

fit <- readRDS('analysis/mcmc-runs/Pseudo-Stan-Fit.RDS')

a <- as.data.frame(extract(fit))

outtab <- as.table(rbind(quantile(a$Int,c(.05,.5,.95)),
						 quantile(a$DitInt,c(.05,.5,.95)),
						 quantile(a$Slope,c(.05,.5,.95)),
						 quantile(a$DitSlope,c(.05,.5,.95))))

rownames(outtab) <- c('Intercept',
					  'Recipient Passive',
					  'Year of Composition (z-scored)',
					  '(*)Recipient Year Interaction')

colnames(outtab) <- c('5%',
					  'Point Estimate',
					  '95%')


con <- file('output/tables/recpas-mcmc.tex','w')
sink(con)
print(xtable(outtab,label='tab:pas-change-tab',caption='Parameter results from Bayesian Inference, (*) indicates rows relevant for the Constant Rate Effect'))
sink()
close(con)
