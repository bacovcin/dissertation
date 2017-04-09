#!/usr/bin/env Rscript
library(ggplot2)
library(dplyr)
# Load in the prepared British Data
load("analysis/rdata-tmp/britdat.RData")
real <- subset(britdat, NVerb!='SEND'&!is.na(isTo))

brit.act <- subset(real, Voice=='ACT'&!is.na(year)&!is.na(Adj)&!is.na(isDatAcc))
# Create numeric variables for everything (and zscore year)
brit.act$zYear <- (brit.act$year - mean(brit.act$year))/sd(brit.act$year)

brit.act$isAdj <- factor(brit.act$Adj)
levels(brit.act$isAdj) <- c(1,0,1,0)
brit.act$isAdj<-as.numeric(as.character(brit.act$isAdj))

brit.act$NAdj <- factor(brit.act$isAdj)
levels(brit.act$NAdj)<-c('Not Adjacent','Adjacent')

gdat <- subset(brit.act,DO=='Theme Pronoun'&isDatAcc==0)
# Save the table to file for use in tex documents
con <- file('output/tables/fnpr-dtp.tex','w')
sink(con)
cat(paste0(round(mean(gdat$isTo[gdat$IO=='Recipient Noun'&gdat$year>=1425&gdat$year<=1700],na.rm=T)*100,digits=0),'\\%%'),sep='')
sink()
close(con)

con <- file('output/tables/pr-dtp.tex','w')
sink(con)
cat(paste0(round(mean(gdat$isTo[gdat$IO=='Recipient Pronoun'&gdat$year>=1425&gdat$year<=1700],na.rm=T)*100,digits=0),'\\%%'),sep='')
sink()
close(con)
