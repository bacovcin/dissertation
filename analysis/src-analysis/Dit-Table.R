#!/usr/bin/env Rscript
library(xtable)
library(rstanarm)
options(mc.cores = parallel::detectCores())
options(xtable.timestamp = "")

# Load in the prepared British Data
load("analysis/rdata-tmp/britdat.RData")

# Create categories for table
britdat$teras<-cut(britdat$year,breaks=c(1200,1300,1400,1500,1600),labels=c('1200--1300','1300--1400','1400--1500','1500-1600'))

# Get the relevant data for the table 
tdat <- subset(britdat,Voice=='ACT'&NVerb%in%c('PROMISE','GIVE'))

# Create the row categories
levels(tdat$Envir)<-c('I gave theme (to) recipient','I gave (to) recipient theme','(To) recipient, I gave theme','Theme, I gave (to) recipient','I gave theme (to) recipient','I gave (to) recipient theme',NA,NA,NA,NA)
tdat$Envir<-factor(tdat$Envir,levels=c('I gave theme (to) recipient',
									   '(To recipient), I gave theme',
									   'I gave (to) recipient theme',
									   'Theme, I gave (to) recipient'))

# Generate the table
tabnums<-xtabs(tdat$isTo~tdat$Envir+tdat$teras)
outtab<-round((tabnums/table(tdat$Envir,tdat$teras))*100)
outtab[,1] <- paste0(outtab[,1],'% (',tabnums[,1],')')
outtab[,2] <- paste0(outtab[,2],'% (',tabnums[,2],')')
outtab[,3] <- paste0(outtab[,3],'% (',tabnums[,3],')')
outtab[,4] <- paste0(outtab[,4],'% (',tabnums[,4],')')

# Save the table to file for use in tex documents
con <- file('output/tables/To-Prop.tex','w')
sink(con)
xtable(outtab,label='tab:britto',caption='\\% of Middle and Early Modern English \\textit{give} and \\textit{promise} type ditransitives with \\textit{to}-marking (number of tokens in parentheses)',file='../../output/tables/To-Prop.tex')
sink()
close(con)
