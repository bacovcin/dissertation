#!/usr/bin/env Rscript
library(ggplot2)
library(dplyr)

# American English
load('analysis/rdata-tmp/amdat.RData')

amdat$isTo<-factor(amdat$To)
levels(amdat$isTo)<-c(0,1)
amdat$isTo<-as.numeric(as.character(amdat$isTo))

amdat$isDatAcc <- factor(amdat$Order)
levels(amdat$isDatAcc) <- c(0,1)
amdat$isDatAcc <- as.numeric(as.character(amdat$isDatAcc))

amdat<-subset(amdat,!is.na(isDatAcc)&!is.na(IO)&!is.na(DO))

pdf(file='output/images/am-change-act.pdf')
ggplot(amdat,aes(year,isDatAcc,colour=Verb,linetype=IO))+
  stat_smooth()+
  coord_cartesian(ylim=c(0,1))+scale_y_continuous(name="",breaks=c(0,0.2,0.4,0.5,0.6,0.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+scale_colour_discrete(name="Verb")+facet_wrap(~DO)
dev.off()

