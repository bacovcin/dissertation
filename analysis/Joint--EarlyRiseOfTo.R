library(dplyr)
library(ggplot2)

load('BritishData.RData')

brit$isAdj<-factor(brit$NAdj)
levels(brit$isAdj)<-c(1,0,1,0)
brit$isAdj<-as.numeric(as.character(brit$isAdj))

brit$AccSize<-as.character(brit$AccSize)
brit$AccSize[brit$AccSize=='MORE']<-25
brit$AccSize<-as.numeric(brit$AccSize)

brit$DatSize<-as.character(brit$DatSize)
brit$DatSize[brit$DatSize=='MORE']<-25
brit$DatSize<-as.numeric(brit$DatSize)

brit$SizeDiff<-brit$AccSize-brit$DatSize

brit$AcchasCP<-factor(brit$AccCP)
levels(brit$AcchasCP)<-c(0,0,1)
brit$AcchasCP<-as.numeric(as.character(brit$AcchasCP))

brit$IONoun<-factor(brit$NIO)
levels(brit$IONoun)<-c(1,0)
brit$IONoun<-as.numeric(as.character(brit$IONoun))

brit$DONoun<-factor(brit$NDO)
levels(brit$DONoun)<-c(1,0)
brit$DONoun<-as.numeric(as.character(brit$DONoun))

# Orde == 1 in theme--recipient contexts
brit$Order<-factor(brit$Envir)
levels(brit$Order)<-c(NA,NA,NA,NA,1,0,NA,NA,NA,0,1,NA,NA,NA)
brit$Order<-as.numeric(as.character(brit$Order))

brit$voice<-factor(brit$Pas)
levels(brit$voice)<-c(0,1)
brit$voice<-as.numeric(as.character(brit$voice))

brit$isShifted<-factor(brit$Order)
levels(brit$isShifted)<-c(1,0)
brit$isShifted<-as.numeric(as.character(brit$isShifted))

moddat<-data.frame(x=brit$YoC,y=brit$isTo,adj=brit$isAdj,size=brit$SizeDiff,CP=brit$AcchasCP,IO=brit$IONoun,DO=brit$DONoun,voice=brit$voice,order=brit$Order,eras=brit$eras)
moddat<-subset(moddat,!is.na(order))

act<-subset(moddat,voice==0&DO==1)

npoint<-group_by(act,eras,order,IO)%>%summarise(n=sum(!is.na(y)),rate=sum(y)/n)

ggplot(act,aes(x,y,linetype=factor(order),color=factor(IO)))+
  stat_smooth(method='loess')+
  geom_point(data=npoint,aes(eras,rate,pch=factor(order),size=log2(n)))+
  coord_cartesian(ylim=c(0,1))+
  scale_color_discrete(name='Recipient Type',labels=c('him','John'))+
  scale_linetype_discrete(name='Word Order',labels=c('She gave (to) him/John the book','She gave the book (to) him/John'))+
  scale_shape_discrete(name='Word Order',labels=c('She gave (to) him/John the book','She gave the book (to) him/John'))+
  scale_x_continuous(name="Year of Composition")+
  scale_y_continuous(name="% To",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  scale_size_continuous(name='log2(Number of Tokens/century)')

moddat<-data.frame(x=brit$YoC,y=brit$isShifted,adj=brit$isAdj,size=brit$SizeDiff,CP=brit$AcchasCP,IO=brit$IONoun,DO=brit$DONoun,voice=brit$voice,to=brit$isTo,eras=brit$eras)
moddat<-subset(moddat,!is.na(y))

act<-subset(moddat,voice==0&DO==1)

npoint<-group_by(act,eras,to,IO)%>%summarise(n=sum(!is.na(y)),rate=sum(y)/n)

ggplot(act,aes(x,y,linetype=factor(to),color=factor(IO)))+
  stat_smooth(method='loess')+
  geom_point(data=npoint,aes(eras,rate,pch=factor(to),size=log2(n)))+
  coord_cartesian(ylim=c(0,1))+
  scale_color_discrete(name='Recipient Type',labels=c('him','John'))+
  scale_linetype_discrete(name='To-marking',labels=c('She gave it him/him it','She gave it to him/to him it'))+
  scale_shape_discrete(name='To-marking',labels=c('She gave it him/him it','She gave it to him/to him it'))+
  scale_x_continuous(name="Year of Composition")+
  scale_y_continuous(name="% Recipient--Theme",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  scale_size_continuous(name='log2(Number of Tokens/century)')


rt<-subset(act,order==0&x>=1475&x<=1750)

full<-glm(data=rt,y~x*size*IO,family=binomial)
noint<-glm(data=rt,y~x+size+IO,family=binomial)
nosize<-glm(data=rt,y~x+IO,family=binomial)
noio<-glm(data=rt,y~x+size,family=binomial)
nox<-glm(data=rt,y~size+IO,family=binomial)
null<-glm(data=rt,y~1,family=binomial)

AIC(null,nox,noio,nosize,noint,full)

full<-glm(data=moddat,y~x*(adj+size+CP+IO*DO+voice+order),family=binomial)
