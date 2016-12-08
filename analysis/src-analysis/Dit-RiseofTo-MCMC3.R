#! /usr/bin/env Rscript
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

load('analysis/rdata-tmp/RoT-dat3.RData')
parameters <- read.csv('analysis/parameters/parameters.csv')

fits <- list()
for (i in stan.dat3$REstart:stan.dat3$REend) {
	curdat <- list(priorSD = parameters$prior_sd,
				  NormalPrior = stan.dat3$NormalPrior,
				  T = stan.dat3$T,
				  t = stan.dat3$t,
				  n = stan.dat3$n,
				  N = stan.dat3$N,
				  REPoint = i)

	fits[[i]] <- stan(file = 'analysis/src-analysis/stan-models/binomial-reanalysis.stan', data=curdat,
	  					iter = parameters$iters,
						chains = parameters$nchains, 
	    				seed=parameters$seed)
}
saveRDS(fits,file='analysis/mcmc-runs/ToRaising-Stan-Fit3.RDS')
