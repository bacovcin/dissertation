#! /usr/bin/env Rscript
library(rstan)
library(dplyr)
load('analysis/rdata-tmp/britdat.RData')
real <- subset(britdat, NVerb!='SEND'&!is.na(isTo))
brit.act <- subset(real, Voice=='ACT'&NVerb!='NONREC'&!is.na(year)&!is.na(Adj)&!is.na(isDatAcc))
fit<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit.RDS')

a <- as.data.frame(extract(fit))

pred <- expand.grid(year = min(brit.act$year):max(brit.act$year),
                    Order = c('TR','RT'),
                    IO = c('Noun','Pronoun'))

pred$x <- (pred$year - mean(brit.act$year))/sd(brit.act$year)

ry = mean(a$ry)
rypro = mean(a$rypro)
Int1 = mean(a$Int1) 
Slope1 = mean(a$Slope1)
ProInt1 = mean(a$ProInt1)
ProSlope1 = mean(a$ProSlope1)
RTInt1 = mean(a$RTInt1)
RTSlope1 = mean(a$RTSlope1)
ProRTInt1 = mean(a$ProRTInt1)
ProRTSlope1 = mean(a$ProRTSlope1)
Slope2 = mean(a$Slope2)
ProSlope2 = mean(a$ProSlope2)
Int2 = (Int1 + Slope1 * ry + RTInt1 + RTSlope1 * ry) - Slope2 * ry
ProInt2 = (Int1 + Slope1 * rypro + 
             RTInt1 + RTSlope1 * rypro + 
             ProInt1 + ProSlope1 * rypro +
             ProRTInt1 + ProRTSlope1 * rypro) - (Slope2 * rypro + ProSlope2 * rypro)

pred$z <- NA

pred$z[pred$Order=='TR'&pred$IO=='Noun'] <- Int1 + Slope1 * pred$x[pred$Order=='TR'&pred$IO=='Noun']
pred$z[pred$Order=='TR'&pred$IO=='Pronoun'] <- Int1 + Slope1 * pred$x[pred$Order=='TR'&pred$IO=='Pronoun'] + 
      ProInt1 + ProSlope1 * pred$x[pred$Order=='TR'&pred$IO=='Pronoun']
pred$z[pred$Order=='RT'&pred$IO=='Noun'] <- Int1 + Slope1 * pred$x[pred$Order=='RT'&pred$IO=='Noun'] + RTInt1 + 
      RTSlope1 * pred$x[pred$Order=='RT'&pred$IO=='Noun']
pred$z[pred$Order=='RT'&pred$IO=='Noun'&pred$x>=ry] <- Int2 + Slope2 * pred$x[pred$Order=='RT'&pred$IO=='Noun'&pred$x>=ry]
pred$z[pred$Order=='RT'&pred$IO=='Pronoun'] <- Int1 + Slope1 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'] + 
      RTInt1 + RTSlope1 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'] + 
      ProInt1 + ProSlope1 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'] + 
      ProRTInt1 + ProRTSlope1 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun']
pred$z[pred$Order=='RT'&pred$IO=='Pronoun'&pred$x>=rypro] <- ProInt2 + Slope2 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'&pred$x>=rypro] + ProSlope2 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'&pred$x>=rypro]

unlogit <- function(x){return(1/(1+exp(-x)))}
pred$isTo <- unlogit(pred$z)

brit.act$era <- as.numeric(as.character(cut(brit.act$year,breaks=seq(800,1950,50),labels=seq(825,1925,50))))
brit.act.points<-group_by(brit.act,era,IO,isDatAcc)%>%summarise(isTo=mean(isTo),n=n())

brit.act$Order<-factor(brit.act$isDatAcc)
levels(brit.act$Order)<-c('Theme-recipient','Recipient-theme')

levels(pred$Order)<-c('Theme-recipient','Recipient-theme')
levels(pred$IO)<-c('Recipient Noun','Recipient Pronoun')

bpoints<-group_by(brit.act,era,IO,Order)%>%summarise(isTo=mean(isTo),n=n())
pdf(file='output/images/to-use.pdf')
ggplot(bpoints,aes(era,isTo,colour=factor(Order)))+geom_point(aes(size=n))+geom_line(data=pred,aes(x=year))+
  scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
  scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  scale_size_continuous(name="Number of Tokens/50yrs")+
  scale_colour_discrete(name="Word Order")+
  scale_linetype_discrete(name="Recipient Status")+
  scale_shape_discrete(name="Recipient Status")+facet_wrap(~IO)
dev.off()

