require(ggplot2)

data <- read.csv('give_act_coded_final.txt',sep='\t',quote="")
oadata <- read.csv('offer_act_coded_final.txt',sep='\t',quote="")
opdata <- read.csv('offer_pas_coded_final.txt',sep='\t',quote="")

oadata$Verb<-'offer'
opdata$Verb<-'offer'
data$Verb<-'give'

oadata$isIdiom<-0
opdata$isIdiom<-0
data$Voice<-'Active'

table(data$To,data$Order)

rdata<-as.data.frame(rbind(data,oadata,opdata))
rdata$Verb<-factor(rdata$Verb)

rdata$cond<-factor(paste(rdata$To,rdata$Order))
levels(rdata$cond)<-c('NA','gave it him','gave him it','gave it to him','gave to him it')



data <- read.csv('CompRecodedCOHA.txt',sep='\t', quote = "")
data$IO<-factor(data$IOType)
levels(data$IO)<-c('Recipient Noun','Recipient Pronoun')

data$DO<-factor(data$DOType)
levels(data$DO)<-c('Theme Pronoun','Theme Noun')

nam<-subset(data,is.na(Error.Type)&(ToMarked=='To'|ToMarked=='NoTo'))
nam$ToMarked<-factor(nam$ToMarked)
nam$Voice<-factor(nam$Voice)
nam$IOType<-factor(nam$IOType)

levels(nam$ToMarked)<-c('No To','Has To')
levels(nam$Voice)<-c('Active','Recipient Passive','Theme Passive')
levels(nam$IOType)<-c('Recipient Noun','Recipient Pronoun')

nam$isTo<-factor(nam$ToMarked)
levels(nam$isTo)<-c(0,1)
nam$isTo<-as.numeric(as.character(nam$isTo))
nam$Year<-as.numeric(as.character(nam$Year))

toset<-subset(nam,Voice!='Recipient Passive')
toset$Voice<-factor(toset$Voice)
contrasts(toset$IOType)<-contr.sum(levels(toset$IOType))
contrasts(toset$Voice)<-contr.sum(levels(toset$Voice))

passet<-subset(nam,Voice!='Active')

passet$Choice<-factor(paste(passet$Voice,passet$ToMarked))
passet$Choice<-relevel(passet$Choice,"Recipient Passive No To")

levels(passet$Choice)<-c('gave him it','gave to him it','gave it to him','gave it him')

npas<-data.frame(id=passet$ID,year=passet$Year,genre=passet$Genre,IO=passet$IO,DO=passet$DO,cond=passet$Choice,voice='Passive',Verb='give')
nact<-data.frame(id=rdata$id,year=rdata$year,genre=rdata$genre,IO=rdata$IO,DO=rdata$DO,cond=rdata$cond,voice=rdata$Voice,Verb=rdata$Verb)

joint<-as.data.frame(rbind(npas,nact))

joint$isRecFirst<-factor(joint$cond)
levels(joint$isRecFirst)<-c(1,1,0,0,NA)
joint$isRecFirst<-as.numeric(as.character(joint$isRecFirst))

joint$IO<-factor(joint$IO)
levels(joint$IO)<-c('Recipient Noun','Recipient Pronoun','Recipient Noun','Recipient Pronoun')

joint$DO<-factor(joint$DO)
levels(joint$DO)<-c('Theme Pronoun','Theme Noun','Theme Noun','Theme Pronoun')

gjoint<-subset(joint,!is.na(IO)&!is.na(DO))

ggplot(gjoint,aes(year,isRecFirst,colour=Verb,linetype=voice))+stat_smooth(method='loess')+facet_grid(IO~DO)
ggplot(gjoint,aes(year,isRecFirst,colour=Verb,linetype=voice))+stat_smooth(method='glm',family='binomial',se=F)+facet_grid(IO~DO)


rptnpas<-subset(gjoint,voice=='Passive'&IO=='Recipient Pronoun'&DO=='Theme Noun')
full<-glm(data=rptnpas,isRecPas~year*Verb,family=binomial)
noint<-glm(data=rptnpas,isRecPas~year+Verb,family=binomial)
noverb<-glm(data=rptnpas,isRecPas~year,family=binomial)
null<-glm(data=rptnpas,isRecPas~1,family=binomial)

anova(null,noverb,noint,full,test='Chisq')

act<-subset(rdata,Voice=='Active'&cond %in% c('gave him it','gave it to him'))


ggplot(act,aes(year,isRecFirst,colour=Verb))+stat_smooth(method='loess')+coord_cartesian(ylim=c(0,1))+facet_wrap(IO~DO)

actnn<-subset(act,IO=='Noun'&DO=='Noun')

ggplot(actnn,aes(year,isRecFirst,colour=Verb))+stat_smooth(method='glm',family='binomial')+coord_cartesian(ylim=c(0,1))

full<-glm(data=actnn,isRecFirst~year*Verb,family='binomial')
noint<-glm(data=actnn,isRecFirst~year+Verb,family='binomial')
noverb<-glm(data=actnn,isRecFirst~year,family='binomial')
null<-glm(data=actnn,isRecFirst~1,family='binomial')

anova(null,noverb,noint,full,test="Chisq")

crit<-subset(data,cond %in% c('gave him it','gave it to him'))

crit$isDatAcc<-factor(crit$cond)
levels(crit$isDatAcc)<-c(1,0)
crit$isDatAcc<-as.numeric(as.character(crit$isDatAcc))

levels(crit$IO)<-c('Recipient Noun','Recipient Pronoun')
levels(crit$DO)<-c('Theme Noun','Theme Pronoun')

require(ggplot2)
ggplot(crit,aes(year,isDatAcc,colour='Full Data'))+stat_smooth(method='loess')+stat_smooth(method='loess',data=subset(crit,isIdiom==0),aes(colour='No Idioms'))+facet_grid(IO~DO)

crit$decade<-cut(crit$year,breaks=seq(1800,2010,10),labels=seq(1805,2005,10))

bnact<-subset(crit,IO=='Recipient Noun'&DO=='Theme Noun')

levels(joint$cond)<-c('gave him it/he was given it','gave to him it/to him was given it','gave it to him/it was given to him','gave it him/it was given him',NA)

joint$Order<-factor(joint$cond)
levels(joint$Order)<-c('Recipient First','Recipient First','Theme First','Theme First')

joint$isRecFirst<-factor(joint$Order)
levels(joint$isRecFirst)<-c(1,0)
joint$isRecFirst<-as.numeric(as.character(joint$isRecFirst))

joint<-subset(joint,!is.na(DO))

ggplot(joint,aes(year,isRecFirst,colour=voice))+
  stat_smooth(method='loess',aes(linetype='loess'))+
  stat_smooth(method='glm',family='binomial',aes(linetype='logistic'))+
  facet_grid(IO~DO)

nn<-subset(joint,IO=='Recipient Noun'&DO=='Theme Noun')
summary(glm(data=nn,isRecFirst~year*voice))

nn$decades<-as.numeric(as.character(cut(nn$year,breaks=seq(1800,2010,10),labels=seq(1805,2005,10))))
xtabs(nn$isRecFirst~nn$decades+nn$voice)/table(nn$decades,nn$voice)

ggplot(nn,aes(year,isRecFirst,colour=voice))+stat_smooth(method='glm',family='binomial')+stat_summary(fun.y=mean,geom='point')

dit <- read.csv('adj.tsv',sep='\t')
nmdit <- read.csv('NewModAdj.tsv',sep='\t')
nmdit$Text<-''

for (i in 1:dim(nmdit)[1]) {
  nmdit$Text[i] <- as.vector(strsplit(as.character(nmdit$ID)[i],','))[[1]][1]
}

levels(dit$Clause)[1]<-'ABS'
levels(nmdit$Clause)[1]<-'ABS'

real<-subset(as.data.frame(rbind(odit,dit,nmdit)),!is.na(Verb))

