#! /usr/bin/env Rscript
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

load('analysis/rdata-tmp/RoT-dat4.RData')
parameters <- read.csv('analysis/parameters/parameters.csv')

fits <- list()
for (i in stan.dat4$REstart:stan.dat4$REend) {
	curdat <- list(priorSD = parameters$prior_sd,
				  NormalPrior = stan.dat4$NormalPrior,
				  T = stan.dat4$T,
				  t = stan.dat4$t,
				  n = stan.dat4$n,
				  N = stan.dat4$N,
				  REPoint = i)

	fits[[i]] <- stan(file = 'analysis/src-analysis/stan-models/binomial-reanalysis.stan', data=curdat,
	  					iter = parameters$iters,
						chains = parameters$nchains, 
	    				seed=parameters$seed)
}
saveRDS(fits,file='analysis/mcmc-runs/ToRaising-Stan-Fit4.RDS')
