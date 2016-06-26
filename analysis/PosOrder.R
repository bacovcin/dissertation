data<-read.csv('PosOrder.tsv',sep='\t')

data$isShifted<-data$PPshift
levels(data$isShifted)<-c(0,1)
data$isShifted<-as.numeric(as.character(data$isShifted))

library(ggplot2)

ggplot(data,aes(YoC,isShifted,colour=obj_type))+stat_smooth()+
  coord_cartesian(ylim=c(0,1))+
  scale_y_continuous(name="% PP--OBJ",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))
  

full<-glm(data=data,isShifted~YoC*obj_type,family='binomial')
noint<-glm(data=data,isShifted~YoC+obj_type,family='binomial')
noyear<-glm(data=data,isShifted~obj_type,family='binomial')
null<-glm(data=data,isShifted~1,family='binomial')

AIC(null,noyear,noint,full)

heavy<-read.csv('../HeavyNP/Heavy.tsv',sep='\t')

heavy$isShifted<-heavy$shift
levels(heavy$isShifted)<-c(0,1)
heavy$isShifted<-as.numeric(as.character(heavy$isShifted))

data$Type<-'PPshift'
heavy$Type<-'heavy'

j.data<-data.frame(x=data$YoC,y=data$isShifted,type=data$Type,obj=data$obj_type,g=data$Genre)
h.data<-data.frame(x=heavy$YoC,y=heavy$isShifted,type=heavy$Type,obj=heavy$obj_type,g=heavy$Genre)

joint<-as.data.frame(rbind(j.data,h.data))

joint<-subset(joint,!(g %in% c('X','Y','Z')))

joint$NGenre<-joint$g
levels(joint$NGenre)[levels(joint$NGenre)=='A']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='B']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='c']<-"INFORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='C']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='D']<-"INFORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='E']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='F']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='G']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='H']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='I']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='l']<-"INFORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='L']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='M']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='O']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='P']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='Q']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='R']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='t']<-"INFORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='T']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='U']<-"FORMAL"
levels(joint$NGenre)[levels(joint$NGenre)=='W']<-"FORMAL"


ggplot(joint,aes(x,y,colour=NGenre,linetype=type))+stat_smooth()+coord_cartesian(ylim=c(0,1))+facet_wrap(~obj)

