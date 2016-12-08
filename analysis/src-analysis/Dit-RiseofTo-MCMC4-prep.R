#! /usr/bin/env Rscript
library(dplyr)
library(rstan)
library(matrixStats)

fits <- readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit4.RDS')
mats <- data.frame(Int1=NULL, Slope1=NULL, 
				   Slope2=NULL, Int2=NULL,
				   lp__=NULL, s=NULL)
for (i in 1:length(fits)) {
	if (!(is.null(fits[[i]]))) {
		tmpdat <- as.data.frame(extract(fits[[i]]))
		tmpdat$s <- i
		mats <- as.data.frame(rbind(mats,tmpdat))
	}
}

qs <- group_by(mats,s)%>%summarise(q=logSumExp(lp__) - log(n()))
qs$p <- qs$q-logSumExp(qs$q)

mats<-merge(mats,qs)
parameters <- read.csv('analysis/parameters/parameters.csv')

set.seed(parameters$seed)
newmcmc <- sample_n(mats,8000,replace=T,weight=exp(mats$p))

saveRDS(newmcmc,'analysis/mcmc-runs/ToRaising-Stan-Fit4-resample.RDS')
