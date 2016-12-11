#!/usr/bin/env Rscript
library(ggplot2)
library(dplyr)

# Prepare American data (for combining with British data)
load('analysis/rdata-tmp/amdat.RData')
amdat$isDatAcc<-factor(amdat$Order)
levels(amdat$isDatAcc)<-c(0,1)
amdat$isDatAcc<-as.numeric(as.character(amdat$isDatAcc))

levels(amdat$IO)<-c('Recipient Noun','Recipient Pronoun')
levels(amdat$DO)<-c('Theme Noun','Theme Pronoun')

# Generate graph of American English direct theme passive rates
am.pas<-subset(amdat,Voice=='Passive'&!is.na(Order)&!is.na(DO))
am.the<-subset(am.pas,isDatAcc==0)

am.the$isTo<-factor(am.the$To)
levels(am.the$isTo)<-c(0,1)
am.the$isTo<-as.numeric(as.character(am.the$isTo))

pdf(file='output/images/directtheme-am.pdf')
am.the$era <- as.numeric(as.character(cut(am.the$year,breaks=seq(1800,2010,10),labels=seq(1805,2005,10))))
am.points <- group_by(am.the,era,IO)%>%summarise(isTo=mean(isTo,na.rm=T),count=n())
ggplot(am.the,aes(year,isTo,colour=IO))+stat_smooth()+coord_cartesian(ylim=c(0,1))+
	geom_point(data=am.points,aes(x=era,size=count))+
	scale_x_continuous(name='Year of Composition',breaks=seq(1800,2020,20),labels=seq(1800,2020,20))+
	scale_y_continuous(name="% To",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_colour_discrete(name="Recipient Status")+
	scale_size_continuous(name="Number of Tokens/Decade")
dev.off()
