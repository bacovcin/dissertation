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
			    isDatAcc==1)

rtcomponent <- data.frame(Year=rtdat$year,
						  Val=rtdat$isTo,
						  Type='I gave to recipient theme')

heavy <- read.csv('analysis/data/Heavy.dat',sep='\t')
heavy$isShifted <- heavy$Shifted
levels(heavy$isShifted)<-c(0,1,0,1,0,1)
heavy$isShifted<-as.numeric(as.character(heavy$isShifted))

heavy$type <- heavy$Shifted
levels(heavy$type) <- c('Shifted over Adverbs','Shifted over Adverbs','Shifted over Both Adverbs and PP','Shifted over Both Adverbs and PP','Shifted over PP','Shifted over PP')

hreal <- subset(heavy,ObjType%in%c('ObjConj','ObjDefinite','ObjDPronoun','ObjIndefinite','ObjName'))
heavycomponent <- data.frame(Year=hreal$YoC,Val=hreal$isShifted,Type='Shifted')

compdat <- subset(as.data.frame(rbind(rtcomponent,heavycomponent)),Year>=1300&Year<=1500)

compdat$isShifted<-compdat$Type
levels(compdat$isShifted)<-c(0,1)
compdat$isShifted<-as.numeric(as.character(compdat$isShifted))

compdat$zYear <- (compdat$Year - mean(compdat$Year))/sd(compdat$Year)
# Read in parameters
param <- read.csv('analysis/parameters/parameters.csv')
if (param$prior_dist == 'cauchy') {
	heavymod <- stan_glm(Val ~ zYear*isShifted,
                              data = compdat,
                              family = binomial(link = "logit"), 
                              prior = cauchy(location=0,
											 scale=param$prior_sd), 
                              prior_intercept = cauchy(location=0,
													   scale=param$prior_sd),
							  iter = param$iters,
                              chains = param$nchains, seed = param$seed)
} else if (param$prior_dist == 'normal') {
	heavymod <- stan_glm(Val ~ zYear*isShifted,
                              data = compdat,
                              family = binomial(link = "logit"), 
                              prior = normal(location=0,
											 scale=param$prior_sd), 
                              prior_intercept = normal(location=0,
													   scale=param$prior_sd),
							  iter = param$iters,
                              chains = param$nchains, seed = param$seed)
}
saveRDS(heavymod,file='analysis/mcmc-runs/heavy.RDS')
