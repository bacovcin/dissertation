#!/usr/bin/env Rscript
library(rstanarm)
library(xtable)
heavymcmc<-readRDS('analysis/mcmc-runs/heavy.RDS')

# Generate table
outtab <- posterior_interval(heavymcmc, prob = 0.90)
outtab <- as.table(cbind(outtab[,1],heavymcmc$coef,outtab[,2]))
colnames(outtab) <- c('Lower Bound (5%)','Point Estimate','Upper Bound (95%)')
rownames(outtab) <- c('Intercept',
					   'Year of Composition (z-squared)',
					   'Difference between \textit{to} and Heavy NP Shift',
					   'Interaction of Year and Difference')

# Save the table to file for use in tex documents
con <- file('output/tables/heavy-mcmc.tex','w')
sink(con)
print(xtable(outtab,label='tab:model-comp-heavy',caption='Uncertainty Interval for Parameter Estimates for comparing \\textit{to} use in recipient--theme contexts and rates of Heavy NP Shift'),floating.environment='subfloat')
sink()
close(con)
