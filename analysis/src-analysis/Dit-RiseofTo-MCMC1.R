#! /usr/bin/env Rscript
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

load('analysis/rdata-tmp/RoT-dat1.RData')
parameters <- read.csv('analysis/parameters/parameters.csv')

fit <- stan(file = 'analysis/src-analysis/stan-models/binomial.stan', data=stan.dat1,
	    iter = parameters$iters,
		chains = parameters$nchains, 
	    seed=parameters$seed,
	    verbose = T)

saveRDS(fit,file='analysis/mcmc-runs/ToRaising-Stan-Fit1.RDS')
