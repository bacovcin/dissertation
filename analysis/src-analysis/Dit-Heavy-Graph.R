#!/usr/bin/env Rscript
library(ggplot2)
library(dplyr)

# Load in the prepared British Data
load("analysis/rdata-tmp/britdat.RData")

# Extract the recipient--theme data for Heavy NP comparison
rtdat <- subset(britdat,Voice=='ACT' &
				NVerb%in%c('PROMISE','GIVE') &
				IO=='Recipient Noun'&
  		 	    DO=='Theme Noun'&
			    isDatAcc==1)

rtcomponent <- data.frame(Year=rtdat$year,
						  Val=rtdat$isTo,
						  Type='I gave to recipient theme')

heavy <- read.csv('analysis/data/Heavy.dat',sep='\t')
heavy$isShifted <- heavy$Shifted
levels(heavy$isShifted)<-c(0,1,0,1,0,1)
heavy$isShifted<-as.numeric(as.character(heavy$isShifted))

heavy$type <- heavy$Shifted
levels(heavy$type) <- c('Shifted over Adverbs','Shifted over Adverbs','Shifted over Both Adverbs and PP','Shifted over Both Adverbs and PP','Shifted over PP','Shifted over PP')

hreal <- subset(heavy,ObjType%in%c('ObjConj','ObjDefinite','ObjDPronoun','ObjIndefinite','ObjName'))
heavycomponent <- data.frame(Year=hreal$YoC,Val=hreal$isShifted,Type='Shifted')

compdat <- as.data.frame(rbind(rtcomponent,heavycomponent))

compdat$hcent <- as.numeric(as.character(cut(compdat$Year,
											 breaks=seq(600,1950,50),
											 labels=seq(625,1925,50))))

comppoints <- group_by(compdat,hcent,Type)%>%summarise(y=mean(Val,na.rm=T),
													   count=sum(!is.na(Val)))

pdf(file='output/images/shifting.pdf')
ggplot(compdat,aes(Year,Val,colour=Type,linetype=Type))+
	stat_smooth()+
	geom_point(data=comppoints,aes(hcent,y,pch=Type,size=count))+
	coord_cartesian(ylim=c(0,1))+
	scale_x_continuous(name='Year of Composition')+
	scale_size_continuous(name='Number of Tokens/50 years')+
	scale_y_continuous(name='% To or Shifted',breaks=c(0,.2,.4,.5,.6,.8,1),
					   labels=c('0%','20%','40%','50%','60%','80%','100%'))
dev.off()
