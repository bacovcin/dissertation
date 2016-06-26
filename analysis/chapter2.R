library('ggplot2')
library('dplyr')

load('BritishData.RData')
adv<-read.csv('Heavy.tsv',sep='\t')
pps<-read.csv('PosOrder.tsv',sep='\t')

rtn <- subset(brit,NIO == 'Recipient Noun' & NDO == 'Theme Noun' & Envir == 'Active Verb Recipient--Theme')
rtn$AccSize <- as.character(rtn$AccSize)
rtn$AccSize[rtn$AccSize=='MORE'] <- '25'
rtn$AccSize <- as.numeric(rtn$AccSize)

rtn$DatSize <- as.character(rtn$DatSize)
rtn$DatSize[rtn$DatSize=='MORE'] <- '25'
rtn$DatSize <- as.numeric(rtn$DatSize)

rtn$SizeDiff <- rtn$DatSize - rtn$AccSize

heavy.full <- glm(data=subset(rtn,YoC>=1425),isTo~(AccSize*AccCP)*YoC,family='binomial')
heavy.noint <- glm(data=subset(rtn,YoC>=1425),isTo~(AccSize*AccCP)+YoC,family='binomial')
heavy.noyear <- glm(data=subset(rtn,YoC>=1425),isTo~(AccSize*AccCP),family='binomial')
heavy.null <- glm(data=subset(rtn,YoC>=1425),isTo~1,family='binomial')

anova(heavy.null,heavy.noyear,heavy.noint,heavy.full,test='LRT')
AIC(heavy.null,heavy.noyear,heavy.noint,heavy.full)
BIC(heavy.null,heavy.noyear,heavy.noint,heavy.full)

rtn.data<-data.frame(year=rtn$YoC,y=rtn$isTo,type='Ditransitive')

advn<-subset(adv,obj_type=='NOUN')
advn$y <- advn$shift
levels(advn$y)<-c(0,1)
advn$y<-as.numeric(as.character(advn$y))

adv.data<-data.frame(year=advn$YoC,y=advn$y,type="Shift over Adverb")

ppsn<-subset(pps,obj_type=='NOUN')
ppsn$y <- ppsn$PPshift
levels(ppsn$y)<-c(0,1)
ppsn$y<-as.numeric(as.character(ppsn$y))

pps.data<-data.frame(year=ppsn$YoC,y=ppsn$y,type="Shift over PP")

joint.data<-as.data.frame(rbind(rtn.data,adv.data,pps.data))

joint.data$hcent<-as.numeric(as.character(cut(joint.data$year,breaks=seq(850,1950,50),labels=seq(875,1925,50))))


joint.nn <- group_by(joint.data,type,hcent)%>%summarise(y=mean(y),size=n())

ggplot(joint.data,aes(year,y,linetype=type))+
  theme_grey()+
  stat_smooth(colour='black')+
  geom_point(data=joint.nn,aes(hcent,y,pch=type,size=log(size)))+
  coord_cartesian(ylim=c(0,1),xlim=c(1050,1950))+
  scale_y_continuous(name="% Type",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  scale_x_continuous(name="Year of Composition",breaks=seq(1100,1900,100),labels=seq(1100,1900,100))+
  scale_linetype_discrete(name='Type',labels=c("Ditransitive `to'","Shifted over Adverb","Shifted over PP"))+
  scale_shape_discrete(name='Type',labels=c("Ditransitive `to'","Shifted over Adverb","Shifted over PP"))+
  scale_size_continuous(name="Log(Tokens/50 Years)")

joint.eme<-subset(joint.data,year>=1450&year<=1650)
chisq.test()