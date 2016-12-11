#! /usr/bin/env Rscript
library(rstan)
library(dplyr)
library(ggplot2)
load('analysis/rdata-tmp/britdat.RData')
real <- subset(britdat, NVerb!='SEND'&!is.na(isTo))
brit.act <- subset(real, Voice=='ACT'&NVerb!='NONREC'&!is.na(year)&!is.na(Adj)&!is.na(isDatAcc)&DO=='Theme Noun')

brit.act$isAdj <- factor(brit.act$Adj)
levels(brit.act$isAdj) <- c(1,0,1,0)
brit.act$isAdj<-as.numeric(as.character(brit.act$isAdj))

brit.act$NAdj <- factor(brit.act$isAdj)
levels(brit.act$NAdj)<-c('Not Adjacent','Adjacent')

brit.act<-subset(brit.act,(year<=1100&isTo==0) | year>1100)

parameters <- as.data.frame(cbind(read.csv('analysis/parameters/parameters.csv'),
								  read.csv('analysis/parameters/rise_parameters.csv')))

brit.act <- subset(brit.act,year<=parameters$end_data)


fit1<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit1.RDS')
fit2<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit2.RDS')
fit3<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit3-resample.RDS')
fit4<-readRDS('analysis/mcmc-runs/ToRaising-Stan-Fit4-resample.RDS')

a1 <- as.data.frame(extract(fit1))
a2 <- as.data.frame(extract(fit2))
a3 <- fit3
a4 <- fit4

load('analysis/rdata-tmp/RoT-dat3.RData')
load('analysis/rdata-tmp/RoT-dat4.RData')

a3$s.year <- stan.dat3$t[a3$s]
a3$re.year <- a3$s.year * sd(brit.act$year) + mean(brit.act$year)

a4$s.year <- stan.dat4$t[a4$s]
a4$re.year <- a4$s.year * sd(brit.act$year) + mean(brit.act$year)

unlogit <- function(x){return(1/(1+exp(-x)))}
pred1 <- expand.grid(year = min(brit.act$year):max(brit.act$year),
                     Order = 'TR',
                    IO = 'Noun')

pred1$x <- (pred1$year - mean(brit.act$year))/sd(brit.act$year)
Int1 <- mean(a1$Int)
Slope1 <- mean(a1$Slope)

pred1$z <- Int1 + Slope1*pred1$x
pred1$isTo <- unlogit(pred1$z)

pred2 <- expand.grid(year = min(brit.act$year):max(brit.act$year),
                     Order = 'TR',
                    IO = 'Pronoun')

pred2$x <- (pred2$year - mean(brit.act$year))/sd(brit.act$year)
Int2 <- mean(a2$Int)
Slope2 <- mean(a2$Slope)

pred2$z <- Int2 + Slope2*pred2$x
pred2$isTo <- unlogit(pred2$z)

pred3 <- expand.grid(year = min(brit.act$year):max(brit.act$year),
                     Order = 'RT',
                    IO = 'Noun')

pred3$x <- (pred3$year - mean(brit.act$year))/sd(brit.act$year)
Int3a <- mean(a3$Int1)
Slope3a <- mean(a3$Slope1)
Slope3b <- mean(a3$Slope2)
REpoint3 <- mean(stan.dat3$t[a3$s])
Int3b <- (Int3a + Slope3a*REpoint3) - Slope3b*REpoint3

pred3$z <- NA
pred3$z[pred3$x <= REpoint3] <- Int3a + Slope3a * pred3$x[pred3$x <= REpoint3]
pred3$z[pred3$x > REpoint3] <- Int3b + Slope3b * pred3$x[pred3$x > REpoint3]

pred3$isTo <- unlogit(pred3$z)

pred4 <- expand.grid(year = min(brit.act$year):max(brit.act$year),
                     Order = 'RT',
                    IO = 'Pronoun')

pred4$x <- (pred4$year - mean(brit.act$year))/sd(brit.act$year)
Int4a <- mean(a4$Int1)
Slope4a <- mean(a4$Slope1)
Slope4b <- mean(a4$Slope2)
REpoint4 <- mean(stan.dat4$t[a4$s])
Int4b <- (Int4a + Slope4a*REpoint4) - Slope4b*REpoint4

pred4$z <- NA
pred4$z[pred4$x <= REpoint4] <- Int4a + Slope4a * pred4$x[pred4$x <= REpoint4]
pred4$z[pred4$x > REpoint4] <- Int4b + Slope4b * pred4$x[pred4$x > REpoint4]

pred4$isTo <- unlogit(pred4$z)

pred <- as.data.frame(rbind(pred1,pred2,pred3,pred4))

brit.act$era <- as.numeric(as.character(cut(brit.act$year,breaks=seq(800,1950,50),labels=seq(825,1925,50))))
brit.act.points<-group_by(brit.act,era,IO,isDatAcc)%>%summarise(isTo=mean(isTo),n=n())

brit.act$Order<-factor(brit.act$isDatAcc)
levels(brit.act$Order)<-c('Theme-recipient','Recipient-theme')

levels(pred$Order)<-c('Theme-recipient','Recipient-theme')
levels(pred$IO)<-c('Recipient Noun','Recipient Pronoun')

bpoints<-group_by(brit.act,era,IO,Order)%>%summarise(isTo=mean(isTo),n=n())
pdf(file='output/images/to-use.pdf',width=8,height=6)
ggplot(bpoints,aes(era,isTo,colour=factor(Order)))+geom_point(aes(size=n))+geom_line(data=pred,aes(x=year))+
  scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
  scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  scale_size_continuous(name="Number of Tokens/50yrs")+
  scale_colour_discrete(name="Word Order")+
  scale_linetype_discrete(name="Recipient Status")+
  scale_shape_discrete(name="Recipient Status")+facet_wrap(~IO)+
  theme(axis.text.x = element_text(angle = 45))
dev.off()
