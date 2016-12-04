#!/usr/bin/env Rscript
library(rstanarm)
library(xtable)
heavymcmc<-readRDS('analysis/mcmc-runs/weight.RDS')

# Generate table
outtab <- posterior_interval(heavymcmc, prob = 0.90)
outtab <- as.table(cbind(outtab[,1],heavymcmc$coef,outtab[,2]))
colnames(outtab) <- c('Lower Bound (5%)','Point Estimate','Upper Bound (95%)')
rownames(outtab) <- c('Intercept',
					   'Theme Size - Recipient Size (z-squared)',
					   'Theme Dominating a CP',
					   'Year of Composition (z-squared)',
					   'Interaction of Size and CP')

# Save the table to file for use in tex documents
con <- file('output/tables/weight-mcmc.tex','w')
sink(con)
print(xtable(outtab,label='tab:model-comp-weight',caption='Uncertainty Interval for Parameter Estimates for predicting \\textit{to} use in recipient--theme contexts after 1425'),floating.environment='subtable')
sink()
close(con)
