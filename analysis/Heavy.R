data<-read.csv('Heavy.tsv',sep='\t')

data$isShifted<-data$Shift
levels(data$isShifted)<-c(0,1)
data$isShifted<-as.numeric(as.character(data$isShifted))

library(ggplot2)

ggplot(data,aes(YoC,isShifted,colour=Type))+stat_smooth()+coord_cartesian(ylim=c(0,1))
