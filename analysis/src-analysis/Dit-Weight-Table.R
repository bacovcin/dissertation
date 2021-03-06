#!/usr/bin/env Rscript
library(rstanarm)
library(xtable)
heavymcmc<-readRDS('analysis/mcmc-runs/weight.RDS')

# Generate table
outtab <- posterior_interval(heavymcmc, prob = 0.90)
outtab <- as.table(cbind(outtab[,1],heavymcmc$coef,outtab[,2]))
colnames(outtab) <- c('5%','Point Estimate','95%')
rownames(outtab) <- c('Intercept',
					   'Theme Size - Recipient Size (z-squared)',
					   'Theme Dominating a CP',
					   'Year of Composition (z-squared)',
					   'Interaction of Size and CP')

# Save the table to file for use in tex documents
con <- file('output/tables/weight-mcmc.tex','w')
sink(con)
print(xtable(outtab),floating=FALSE)
sink()
close(con)
