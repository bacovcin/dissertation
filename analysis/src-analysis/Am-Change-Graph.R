#!/usr/bin/env Rscript
library(ggplot2)
library(dplyr)

# American English
load('analysis/rdata-tmp/amdat.RData')
givepr<-read.csv('analysis/data/give_pasrate_final.dat',sep='\t',quote='')
offerpr<-read.csv('analysis/data/offer_pasrate_final.dat',sep='\t',quote='')
ampr<-as.data.frame(rbind(givepr,offerpr))

amdat$isTo<-factor(amdat$To)
levels(amdat$isTo)<-c(0,1)
amdat$isTo<-as.numeric(as.character(amdat$isTo))

amdat$isDatAcc <- factor(amdat$Order)
levels(amdat$isDatAcc) <- c(0,1)
amdat$isDatAcc <- as.numeric(as.character(amdat$isDatAcc))

amdat$counter <- 1

amprgb<-group_by(ampr,year,Verb,Voice)%>%summarise(pasCount=n())
amda<-filter(amdat,!is.na(To))%>%filter(!is.na(isDatAcc))%>%group_by(year,Voice,Verb)%>%summarise(isDatAccTo=sum(counter[isDatAcc==1&isTo==1])/n(),isDatAccNoTo=sum(counter[isDatAcc==1&isTo==0])/n(),isAccDatTo=sum(counter[isDatAcc==0&isTo==1])/n())

newam<-merge(amda,amprgb)
newam$DatAccToCount<-round(newam$pasCount*newam$isDatAccTo)
newam$DatAccNoToCount<-round(newam$pasCount*newam$isDatAccNoTo)
newam$AccDatToCount<-round(newam$pasCount*newam$isAccDatTo)
newam$AccDatNoToCount<-newam$pasCount-(newam$DatAccToCount+newam$DatAccNoToCount+newam$AccDatToCount)

newam2<-subset(newam,!is.nan(DatAccToCount)&!is.nan(DatAccNoToCount)&!is.nan(AccDatToCount)&!is.nan(AccDatNoToCount))

amtabdat<-subset(newam2,year>=1950)

amtabdat2<-group_by(amtabdat,Voice)%>%summarise(DatAcc=sum(DatAccNoToCount),AccDat=sum(AccDatToCount))

ammat <- matrix(c(amtabdat2$DatAcc,amtabdat2$AccDat),nrow=2)

prop.table(as.table(ammat),2)
#            A          B
# A 0.94077443 0.94582516
# B 0.05922557 0.05417484

chisq.test(as.table(ammat))
# 
# 	Pearson's Chi-squared test with Yates' continuity correction
# 
# data:  as.table(ammat)
# X-squared = 17.279, df = 1, p-value = 3.228e-05
# 

newam3<-group_by(newam2,year,Verb)%>%summarise(DatAccToTotal=sum(DatAccToCount),DatAccToAct=DatAccToCount[Voice=='Active'],DatAccToRate=1.0-(DatAccToAct/DatAccToTotal),
					       DatAccNoToTotal=sum(DatAccNoToCount),DatAccNoToAct=DatAccNoToCount[Voice=='Active'],DatAccNoToRate=1.0-(DatAccNoToAct/DatAccNoToTotal),
					       AccDatToTotal=sum(AccDatToCount),AccDatToAct=AccDatToCount[Voice=='Active'],AccDatToRate=1.0-(AccDatToAct/AccDatToTotal),
					       AccDatNoToTotal=sum(AccDatNoToCount),AccDatNoToAct=AccDatNoToCount[Voice=='Active'],AccDatNoToRate=1.0-(AccDatNoToAct/AccDatNoToTotal))

ampas <- read.csv('analysis/data/coha_pascounts.txt',sep='\t')
ampas$pasact <- ampas$passives+ampas$actives
newam4 <- merge(newam3,ampas)

recpas <- data.frame(year = newam4$year,
					 val=newam4$DatAccNoToRate,
					 type='Recipient Passivisation',
					 num=newam4$DatAccNoToTotal)

amdat$isDatAcc<-factor(amdat$Order)
levels(amdat$isDatAcc)<-c(0,1)
amdat$isDatAcc<-as.numeric(as.character(amdat$isDatAcc))

levels(amdat$IO)<-c('Recipient Noun','Recipient Pronoun')
levels(amdat$DO)<-c('Theme Noun','Theme Pronoun')

# Generate graph of American English direct theme passive rates
am.pas<-subset(amdat,Voice=='Passive'&!is.na(Order)&!is.na(DO))
am.the<-subset(am.pas,isDatAcc==0&IO=='Recipient Noun')

am.the$isTo<-factor(am.the$To)
levels(am.the$isTo)<-c(1,0)
am.the$isTo<-as.numeric(as.character(am.the$isTo))

am.the.g <- group_by(am.the,year)%>%summarise(val=mean(isTo),
											  type='Direct Theme Passivisation',
											  num=sum(!is.na(isTo)))

gdat <- as.data.frame(rbind(recpas,am.the.g))

pdf(file='output/images/am-change-pass.pdf')
ggplot(gdat,aes(year,val,colour=type,linetype=type,weight=num))+
  stat_smooth(method='loess')+
  geom_point(aes(year,val,size=num))+
  coord_cartesian(ylim=c(0,1))+scale_y_continuous(name="",breaks=c(0,0.2,0.4,0.5,0.6,0.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+scale_colour_discrete(name="Type")+scale_linetype_discrete(name='Type')+scale_size_continuous('Num of Tokens/year')
dev.off()

