#!/usr/bin/env Rscript
library(rstanarm)
library(xtable)
pasmcmc<-readRDS('analysis/mcmc-runs/pas.RDS')

# Generate table
outtab <- posterior_interval(pasmcmc, prob = 0.90)
outtab <- as.table(cbind(outtab[,1],pasmcmc$coef,outtab[,2]))
colnames(outtab) <- c('5%','Point Estimate','95%')
rownames(outtab) <- c('Intercept',
					   'Year of Composition (z-squared)',
					   'Diff. btw. Recipient-Theme and Theme-Recipient',
					   'Interaction of Year and Difference')

# Save the table to file for use in tex documents
con <- file('output/tables/pas-mcmc.tex','w')
sink(con)
print(xtable(outtab,label='tab:model-comp-pasrate',caption='Uncertainty Interval for Parameter Estimates for passivisation rates'))
sink()
close(con)
