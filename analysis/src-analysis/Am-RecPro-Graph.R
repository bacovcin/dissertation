#!/usr/bin/env Rscript
library(ggplot2)
library(dplyr)

# Load in the prepared British Data
load("analysis/rdata-tmp/amdat.RData")

# Extract the recipient--theme data for Heavy NP comparison
recpro <- subset(amdat,((Voice=='Active' & DO=='Pronoun')|
				 (Voice=='Passive'))&
				 IO=='Pronoun'&
				 Order=='AccDat')

recpro$isTo <- recpro$To
levels(recpro$isTo)<-c(0,1)
recpro$isTo <- as.numeric(as.character(recpro$isTo))

recpro$decades <- as.numeric(as.character(cut(recpro$year,
											  breaks=seq(1800,2010,10),
											  labels=seq(1805,2005,10))))

recpoints <- group_by(recpro,Voice,Verb,decades)%>%summarise(y=mean(isTo,na.rm=T),count=sum(!is.na(isTo)))
pdf(file='output/images/recpro-to-am.pdf')
ggplot(recpro,aes(year,isTo,colour=Voice,linetype=Verb))+
	stat_smooth(method='loess')+
	geom_point(data=recpoints,aes(decades,y,size=count,pch=Verb))+
	coord_cartesian(ylim=c(0,1))+
	scale_x_continuous(name='Year of Composition')+
	scale_size_continuous(name="Number of Tokens/Decade")
	scale_y_continuous(name='% To or Shifted',breaks=c(0,.2,.4,.5,.6,.8,1),
					   labels=c('0%','20%','40%','50%','60%','80%','100%'))
dev.off()
