#!/usr/bin/env Rscript
require(rstanarm)
options(mc.cores = parallel::detectCores())

# Load in the prepared British Data
load("analysis/rdata-tmp/britdat.RData")

# Extract the recipient--theme data for Heavy NP comparison
rtdat <- subset(britdat,Voice=='ACT' &
				NVerb%in%c('PROMISE','GIVE') &
				IO=='Recipient Noun'&
  		 	    DO=='Theme Noun'&
			    isDatAcc==1&
				year>=1425)

# Prep the various variables
rtdat$SizeDiff <- rtdat$DOSize-rtdat$IOSize
rtdat$zSizeDiff <- (rtdat$SizeDiff-mean(rtdat$SizeDiff))/sd(rtdat$SizeDiff)
rtdat$zYear <- (rtdat$year - mean(rtdat$year))/sd(rtdat$year)
rtdat$ThemeHasCP <- factor(rtdat$DOCP)
levels(rtdat$ThemeHasCP) <- c(1,0)
rtdat$ThemeHasCP <- as.numeric(rtdat$ThemeHasCP)
# Read in parameters
param <- read.csv('analysis/parameters/parameters.csv')
if (param$prior_dist == 'cauchy') {
	heavymod <- stan_glm(isTo ~ zSizeDiff*ThemeHasCP+zYear,
                              data = rtdat,
                              family = binomial(link = "logit"), 
                              prior = cauchy(location=0,
											 scale=param$prior_sd), 
                              prior_intercept = cauchy(location=0,
													   scale=param$prior_sd),
							  iter = param$init_iters,
                              chains = param$nchains, seed = param$seed)
} else if (param$prior_dist == 'normal') {
	heavymod <- stan_glm(isTo ~ zSizeDiff*ThemeHasCP+zYear,
                              data = rtdat,
                              family = binomial(link = "logit"), 
                              prior = normal(location=0,
											 scale=param$prior_sd), 
                              prior_intercept = normal(location=0,
													   scale=param$prior_sd),
							  iter = param$init_iters,
                              chains = param$nchains, seed = param$seed)
}
saveRDS(heavymod,file='analysis/mcmc-runs/weight.RDS')
