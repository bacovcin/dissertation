#!/usr/bin/env Rscript
library(ggplot2)
library(dplyr)

load('analysis/rdata-tmp/britdat.RData')
britdat$era2 <- cut(britdat$year,breaks=c(700,1100,1450,1750,2000),labels=c('Old English','Middle English','Early Modern English','Late Modern English'))

britdat$isIOPro <- factor(britdat$IO)
levels(britdat$isIOPro)<-c(0,1)
britdat$isIOPro <- as.numeric(as.character(britdat$isIOPro))

britdat$isDOPro <- factor(britdat$DO)
levels(britdat$isDOPro)<-c(0,1)
britdat$isDOPro <- as.numeric(as.character(britdat$isDOPro))

britdat2<-subset(britdat,!is.na(isDatAcc)&NVerb!='NONREC'&NVerb!='SEND'&era>=1200)

britdat2$isPas<-factor(britdat2$Voice)
levels(britdat2$isPas)<-c(0,1)
britdat2$isPas<-as.numeric(as.character(britdat2$isPas))

britdat2$Order<-factor(britdat2$isDatAcc)
levels(britdat2$Order)<-c('Theme-Recipient','Recipient-Theme')

pas <- read.csv('analysis/data/pas.dat',sep='\t')

pas$isPas<-factor(pas$Voice)
levels(pas$isPas)<-c(0,NA,1,NA)
pas$isPas<-as.numeric(as.character(pas$isPas))

pas<-subset(pas,!is.na(isPas))

bdat <- data.frame(year=britdat2$year,Order=britdat2$Order,isPas=britdat2$isPas)
pasdat <- data.frame(year=as.numeric(as.character(pas$YoC)),Order='General',isPas=pas$isPas)
joint<-subset(as.data.frame(rbind(bdat,pasdat)),year>=1200)

joint$era<-as.numeric(as.character(cut(joint$year,breaks=seq(1199,1999,100),labels=seq(1250,1950,100))))

brit.points<-group_by(joint,era,Order)%>%summarise(isPas=mean(isPas),tokens=n())
pdf(file='output/images/brit-pas.pdf')
ggplot(joint,aes(year,isPas,colour=Order))+stat_smooth()+geom_point(data=brit.points,aes(x=era,size=log(tokens)))+coord_cartesian(ylim=c(0,1))+
	scale_x_continuous(name='Year of Composition',breaks=seq(1200,1900,100),labels=seq(1200,1900,100))+
	scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_size_continuous(name="Log(Number of Tokens/100yrs)")
dev.off()


