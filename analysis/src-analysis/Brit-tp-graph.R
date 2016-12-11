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

pdf(file='output/images/brit-tp.pdf',paper='USr')
gdat<-subset(brit.act,DO=='Theme Pronoun'&isDatAcc==0)

gpoints<-group_by(gdat,era,IO)%>%summarise(isTo=mean(isTo),n=n())
ggplot(gpoints,aes(era,isTo,linetype=factor(IO)))+geom_point(aes(size=log(n),pch=IO))+stat_smooth(method='loess',data=gdat,aes(x=year))+
	scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
	scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_size_continuous(name="Log(Number of Tokens/50yrs)")+
	scale_colour_discrete(name="Word Order")+
	scale_linetype_discrete(name="Recipient Status")+
	scale_shape_discrete(name="Recipient Status")
dev.off()



