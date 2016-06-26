library(plyr)
library(ggplot2)
library(epicalc)
library(knitr)
library(nnet)
library(splines)
library(MASS)
library(xtable)
library(bbmle)

dit <- read.csv('adj.tsv',sep='\t')
nmdit <- read.csv('NewModAdj.tsv',sep='\t')
nmdit$Text<-''

for (i in 1:dim(nmdit)[1]) {
  nmdit$Text[i] <- as.vector(strsplit(as.character(nmdit$ID)[i],','))[[1]][1]
}


odit <- read.csv('oldadj.tsv',sep='\t')
odit$Text<-''

for (i in 1:dim(odit)[1]) {
  odit$Text[i] <- as.vector(strsplit(as.character(odit$ID)[i],','))[[1]][1]
}

dit$Text<-as.character(dit$Text)

levels(dit$Clause)[1]<-'ABS'
levels(nmdit$Clause)[1]<-'ABS'

real<-subset(as.data.frame(rbind(odit,dit,nmdit)),!is.na(Verb))

real$Text<-factor(real$Text)

real$NGenre<-real$Genre
levels(real$NGenre)[levels(real$NGenre)=='A']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='B']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='c']<-"INFORMAL"
levels(real$NGenre)[levels(real$NGenre)=='C']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='D']<-"INFORMAL"
levels(real$NGenre)[levels(real$NGenre)=='E']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='F']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='G']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='H']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='I']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='l']<-"INFORMAL"
levels(real$NGenre)[levels(real$NGenre)=='L']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='M']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='O']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='P']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='Q']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='R']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='t']<-"INFORMAL"
levels(real$NGenre)[levels(real$NGenre)=='T']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='U']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='W']<-"FORMAL"
levels(real$NGenre)[levels(real$NGenre)=='X']<-"WEIRD"
levels(real$NGenre)[levels(real$NGenre)=='Y']<-"WEIRD"
levels(real$NGenre)[levels(real$NGenre)=='Z']<-"WEIRD"
levels(real$NGenre)[levels(real$NGenre)=='Y']<-"WEIRD"

real$NDat<-real$Dat

levels(real$NDat)[levels(real$NDat)=='DatDefinite']=c('DatNoun')
levels(real$NDat)[levels(real$NDat)=='DatIndefinite']=c('DatNoun')
levels(real$NDat)[levels(real$NDat)=='DatName']=c('DatNoun')
levels(real$NDat)[levels(real$NDat)=='DatConj']=c('DatNoun')
levels(real$NDat)[levels(real$NDat)=='DatNull']=c('DatNull')
levels(real$NDat)[levels(real$NDat)=='DatDPronoun']=c('DatNoun')
levels(real$NDat)[levels(real$NDat)=='DatWHEmpty']=c('DatEmpty')
levels(real$NDat)[levels(real$NDat)=='DatWHIndefinite']=c('DatNoun')
levels(real$NDat)[levels(real$NDat)=='DatWHPronoun']=c('DatPronoun')
levels(real$NDat)[levels(real$NDat)=='DatWPIndefinite']=c('DatNoun')
levels(real$NDat)[levels(real$NDat)=='DatWPPronoun']=c('DatPronoun')

real$DatWH<-real$Dat

levels(real$DatWH)[levels(real$DatWH)=='DatDefinite']=c('DatNotWH')
levels(real$DatWH)[levels(real$DatWH)=='DatIndefinite']=c('DatNotWH')
levels(real$DatWH)[levels(real$DatWH)=='DatName']=c('DatNotWH')
levels(real$DatWH)[levels(real$DatWH)=='DatConj']=c('DatNotWH')
levels(real$DatWH)[levels(real$DatWH)=='DatNull']=c('DatNotWH')
levels(real$DatWH)[levels(real$DatWH)=='DatDPronoun']=c('DatNotWH')
levels(real$DatWH)[levels(real$DatWH)=='DatEmpty']=c('DatNotWH')
levels(real$DatWH)[levels(real$DatWH)=='DatPronoun']=c('DatNotWH')
levels(real$DatWH)[levels(real$DatWH)=='DatWHEmpty']=c('DatWH')
levels(real$DatWH)[levels(real$DatWH)=='DatWHIndefinite']=c('DatWH')
levels(real$DatWH)[levels(real$DatWH)=='DatWHPronoun']=c('DatWH')
levels(real$DatWH)[levels(real$DatWH)=='DatWPIndefinite']=c('DatWH')
levels(real$DatWH)[levels(real$DatWH)=='DatWPPronoun']=c('DatWH')


real$NAcc<-real$Acc

levels(real$NAcc)[levels(real$NAcc)=='AccDefinite']=c('AccNoun')
levels(real$NAcc)[levels(real$NAcc)=='AccIndefinite']=c('AccNoun')
levels(real$NAcc)[levels(real$NAcc)=='AccName']=c('AccNoun')
levels(real$NAcc)[levels(real$NAcc)=='AccConj']=c('AccNoun')
levels(real$NAcc)[levels(real$NAcc)=='AccNull']=c('AccNull')
levels(real$NAcc)[levels(real$NAcc)=='AccDPronoun']=c('AccNoun')
levels(real$NAcc)[levels(real$NAcc)=='AccPronoun']=c('AccPronoun')
levels(real$NAcc)[levels(real$NAcc)=='AccEmpty']=c('AccEmpty')
levels(real$NAcc)[levels(real$NAcc)=='AccCP']=c('AccCP')
levels(real$NAcc)[levels(real$NAcc)=='AccWHEmpty']=c('AccEmpty')
levels(real$NAcc)[levels(real$NAcc)=='AccWHIndefinite']=c('AccNoun')
levels(real$NAcc)[levels(real$NAcc)=='AccWHPronoun']=c('AccPronoun')

real$AccWH<-real$Acc

levels(real$AccWH)[levels(real$AccWH)=='AccDefinite']=c('AccNotWH')
levels(real$AccWH)[levels(real$AccWH)=='AccIndefinite']=c('AccNotWH')
levels(real$AccWH)[levels(real$AccWH)=='AccName']=c('AccNotWH')
levels(real$AccWH)[levels(real$AccWH)=='AccConj']=c('AccNotWH')
levels(real$AccWH)[levels(real$AccWH)=='AccNull']=c('AccNotWH')
levels(real$AccWH)[levels(real$AccWH)=='AccDPronoun']=c('AccNotWH')
levels(real$AccWH)[levels(real$AccWH)=='AccPronoun']=c('AccNotWH')
levels(real$AccWH)[levels(real$AccWH)=='AccEmpty']=c('AccNotWH')
levels(real$AccWH)[levels(real$AccWH)=='AccCP']=c('AccNotWH')
levels(real$AccWH)[levels(real$AccWH)=='AccWHEmpty']=c('AccWH')
levels(real$AccWH)[levels(real$AccWH)=='AccWHIndefinite']=c('AccWH')
levels(real$AccWH)[levels(real$AccWH)=='AccWHPronoun']=c('AccWH')

real$NNom<-real$Nom

levels(real$NNom)[levels(real$NNom)=='NomDefinite']=c('NomNoun')
levels(real$NNom)[levels(real$NNom)=='NomIndefinite']=c('NomNoun')
levels(real$NNom)[levels(real$NNom)=='NomConj']=c('NomNoun')
levels(real$NNom)[levels(real$NNom)=='NomName']=c('NomNoun')
levels(real$NNom)[levels(real$NNom)=='NomNull']=c('NomNull')
levels(real$NNom)[levels(real$NNom)=='NomEmpty']=c('NomEmpty')
levels(real$NNom)[levels(real$NNom)=='NomDPronoun']=c('NomPronoun')
levels(real$NNom)[levels(real$NNom)=='NomWHEmpty']=c('NomEmpty')
levels(real$NNom)[levels(real$NNom)=='NomWHIndefinite']=c('NomNoun')
levels(real$NNom)[levels(real$NNom)=='NomWHPronoun']=c('NomPronoun')

real$NomWH<-real$Nom

levels(real$NomWH)[levels(real$NomWH)=='NomDefinite']=c('NomNotWH')
levels(real$NomWH)[levels(real$NomWH)=='NomIndefinite']=c('NomNotWH')
levels(real$NomWH)[levels(real$NomWH)=='NomConj']=c('NomNotWH')
levels(real$NomWH)[levels(real$NomWH)=='NomName']=c('NomNotWH')
levels(real$NomWH)[levels(real$NomWH)=='NomNull']=c('NomNotWH')
levels(real$NomWH)[levels(real$NomWH)=='NomEmpty']=c('NomNotWH')
levels(real$NomWH)[levels(real$NomWH)=='NomDPronoun']=c('NomNotWH')
levels(real$NomWH)[levels(real$NomWH)=='NomWHEmpty']=c('NomWH')
levels(real$NomWH)[levels(real$NomWH)=='NomWHIndefinite']=c('NomWH')
levels(real$NomWH)[levels(real$NomWH)=='NomWHPronoun']=c('NomWH')


real$NVerb<-real$Verb

levels(real$NVerb)[levels(real$NVerb)=='ALLOT']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='APPOINT']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='ASSIGN']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='AYEVEN']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='BEHIEGHT']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='BEQUEATH']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='BETAKE']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='CARRY']<-c('SEND')
levels(real$NVerb)[levels(real$NVerb)=='DELIVER']<-c('SEND')
levels(real$NVerb)[levels(real$NVerb)=='FEED']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='GIVE']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='GRANT']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='LEND']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='OFFER']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='OWE']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='PAY']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='PROFFER']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='PROMISE']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='RESTORE']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='RETURN']<-c('SEND')
levels(real$NVerb)[levels(real$NVerb)=='SELL']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='SEND']<-c('SEND')
levels(real$NVerb)[levels(real$NVerb)=='SERVE']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='SHOW']<-c('GIVE')
levels(real$NVerb)[levels(real$NVerb)=='VOUCHSAFE']<-c('PROMISE')
levels(real$NVerb)[levels(real$NVerb)=='YIELD']<-c('GIVE')

real$NAdj<-factor(real$Adj)

levels(real$NAdj)<-c(levels(real$NAdj),'ProIntervene','NounIntervene')

real$NAdj[real$NAcc=='AccPronoun'&real$NAdj=='DOIntervene']<-'ProIntervene'
real$NAdj[real$NAdj=='DOIntervene']<-'NounIntervene'

real$NAdj[real$NAcc=='AccPronoun'&real$NAdj=='PreverbDOIntervene']<-'ProIntervene'
real$NAdj[real$NAdj=='PreverbDOIntervene']<-'NounIntervene'

real$NAdj[real$NNom=='NomPronoun'&real$NAdj=='NomIntervene']<-'ProIntervene'
real$NAdj[real$NAdj=='NomIntervene']<-'NounIntervene'

real$NAdj[real$NNom=='NomPronoun'&real$NAdj=='PreverbNomIntervene']<-'ProIntervene'
real$NAdj[real$NAdj=='PreverbNomIntervene']<-'NounIntervene'

real$NAdj<-factor(real$NAdj)

levels(real$NAdj)[levels(real$NAdj)=='Adjacent']='Adjacent'
levels(real$NAdj)[levels(real$NAdj)=='NegIntervene']='OtherInterveners'
levels(real$NAdj)[levels(real$NAdj)=='OtherInterveners']='OtherInterveners'
levels(real$NAdj)[levels(real$NAdj)=='PreverbAdjacent']='Adjacent'
levels(real$NAdj)[levels(real$NAdj)=='PreverbAdvIntervene']='OtherInterveners'
levels(real$NAdj)[levels(real$NAdj)=='PreverbFiniteIntervene']='OtherInterveners'
levels(real$NAdj)[levels(real$NAdj)=='PreverbNegIntervene']='OtherInterveners'
levels(real$NAdj)[levels(real$NAdj)=='ProIntervene']='ProIntervene'
levels(real$NAdj)[levels(real$NAdj)=='NounIntervene']='NounIntervene'

real$isTo<-factor(real$PP)
levels(real$isTo)<-c(0,NA,1,1,1,1)
real$isTo<-as.numeric(as.character(real$isTo))

areal<-subset(real,NGenre!='POETRY'&NGenre!='WEIRD'&NGenre!='TRANSLATION'&NDat!='DatNull'&NDat!='DatEmpty'&NAcc!='AccNull'&NAcc!='AccCP'&Pas=='ACT')

areal$IO<-factor(areal$NDat)
areal$DO<-factor(areal$NAcc)

areal$Envir<-factor(paste(areal$DatVerb,areal$AccVerb,areal$DatAcc))

levels(areal$Envir)[levels(areal$Envir)=="DatV AccV AccDat"]="Active Theme--Recipient Verb"
levels(areal$Envir)[levels(areal$Envir)=="DatV AccV DatAcc"]="Active Recipient--Theme Verb"
levels(areal$Envir)[levels(areal$Envir)=="DatV NA NA"]=NA
levels(areal$Envir)[levels(areal$Envir)=="DatV VAcc AccDat"]=NA
levels(areal$Envir)[levels(areal$Envir)=="DatV VAcc DatAcc"]="Active Recipient Topicalisation"
levels(areal$Envir)[levels(areal$Envir)=="NA AccV NA"]=NA
levels(areal$Envir)[levels(areal$Envir)=="NA VAcc NA"]=NA
levels(areal$Envir)[levels(areal$Envir)=="VDat AccV AccDat"]="Active Theme Topicalisation"
levels(areal$Envir)[levels(areal$Envir)=="VDat NA NA"]=NA
levels(areal$Envir)[levels(areal$Envir)=="VDat VAcc AccDat"]="Active Verb Theme--Recipient"
levels(areal$Envir)[levels(areal$Envir)=="VDat VAcc DatAcc"]="Active Verb Recipient--Theme"
levels(areal$Envir)[levels(areal$Envir)=="VDat VAcc NA"]=NA

oereal<-subset(real,NVerb=='OLDENG'&NGenre!='POETRY'&NGenre!='WEIRD'&NGenre!='TRANSLATION'&Pas=='PAS')
oereal$IO<-factor(oereal$NDat)
oereal$DO<-factor(oereal$NNom)
oereal$Envir<-factor(paste(oereal$DatVerb,oereal$NomVerb,oereal$NomDat))
levels(oereal$Envir)[levels(thereal$Envir)=="DatV NA NA"]=NA
levels(oereal$Envir)[levels(oereal$Envir)=="DatV NomV DatNom"]="Theme Passive Recipient Topicalisation"
levels(oereal$Envir)[levels(oereal$Envir)=="DatV NomV NA"]="Theme Passive Recipient Topicalisation"
levels(oereal$Envir)[levels(oereal$Envir)=="DatV NomV NomDat"]="Recipient Passive Theme Topicalisation"
levels(oereal$Envir)[levels(oereal$Envir)=="DatV VNom DatNom"]="Recipient Passive Recipient Verb Theme"
levels(oereal$Envir)[levels(oereal$Envir)=="DatV VNom NomDat"]=NA
levels(oereal$Envir)[levels(oereal$Envir)=="NA NA NA"]=NA
levels(oereal$Envir)[levels(oereal$Envir)=="NA NomV NA"]=NA
levels(oereal$Envir)[levels(oereal$Envir)=="NA VNom NA"]=NA
levels(oereal$Envir)[levels(oereal$Envir)=="VDat NA NA"]=NA
levels(oereal$Envir)[levels(oereal$Envir)=="VDat NomV NomDat"]="Theme Passive Theme Verb Recipient"
levels(oereal$Envir)[levels(oereal$Envir)=="VDat VNom DatNom"]="Recipient Passive Verb Recipient--Theme"
levels(oereal$Envir)[levels(oereal$Envir)=="VDat VNom NomDat"]="Theme Passive Verb Theme--Recipient"


thereal<-subset(real,NVerb!='OLDENG'&NGenre!='POETRY'&NGenre!='WEIRD'&NGenre!='TRANSLATION'&NDat!='DatNull'&NDat!='DatEmpty'&NAcc=='AccNull'&NNom!='NomNull'&Pas=='PAS')
thereal$IO<-factor(thereal$NDat)
thereal$DO<-factor(thereal$NNom)
thereal$Envir<-factor(paste(thereal$DatVerb,thereal$NomVerb,thereal$NomDat))
levels(thereal$Envir)[levels(thereal$Envir)=="DatV NA NA"]=NA
levels(thereal$Envir)[levels(thereal$Envir)=="DatV NomV DatNom"]="Theme Passive Recipient Topicalisation"
levels(thereal$Envir)[levels(thereal$Envir)=="DatV NomV NA"]="Theme Passive Recipient Topicalisation"
levels(thereal$Envir)[levels(thereal$Envir)=="DatV NomV NomDat"]="Recipient Passive Theme Topicalisation"
levels(thereal$Envir)[levels(thereal$Envir)=="DatV VNom DatNom"]="Recipient Passive Recipient Verb Theme"
levels(thereal$Envir)[levels(thereal$Envir)=="DatV VNom NomDat"]=NA
levels(thereal$Envir)[levels(thereal$Envir)=="NA NA NA"]=NA
levels(thereal$Envir)[levels(thereal$Envir)=="NA NomV NA"]=NA
levels(thereal$Envir)[levels(thereal$Envir)=="NA VNom NA"]=NA
levels(thereal$Envir)[levels(thereal$Envir)=="VDat NA NA"]=NA
levels(thereal$Envir)[levels(thereal$Envir)=="VDat NomV NomDat"]="Theme Passive Theme Verb Recipient"
levels(thereal$Envir)[levels(thereal$Envir)=="VDat VNom DatNom"]="Recipient Passive Verb Recipient--Theme"
levels(thereal$Envir)[levels(thereal$Envir)=="VDat VNom NomDat"]="Theme Passive Verb Theme--Recipient"
thereal$Envir<-as.character(thereal$Envir)
thereal$Envir[thereal$Envir=='Recipient Passive Recipient Verb Theme'&thereal$isTo==1]<-'Locative Inversion'
thereal$Envir<-factor(thereal$Envir)

recreal<-subset(real,NVerb!='OLDENG'&NGenre!='POETRY'&NGenre!='WEIRD'&NGenre!='TRANSLATION'&NDat=='DatNull'&NAcc!='AccCP'&NAcc!='AccNull'&NNom!='NomNull'&Pas=='PAS')
recreal$IO<-factor(recreal$NNom)
recreal$DO<-factor(recreal$NAcc)
recreal$Envir<-factor(paste(recreal$NomVerb,recreal$AccVerb,recreal$NomAcc))
levels(recreal$Envir)[levels(recreal$Envir)=="NA VAcc NA"]=NA
levels(recreal$Envir)[levels(recreal$Envir)=="NomV AccV AccNom"]='Recipient Passive Theme Topicalisation'
levels(recreal$Envir)[levels(recreal$Envir)=="NomV NA NA"]=NA
levels(recreal$Envir)[levels(recreal$Envir)=="NomV VAcc NomAcc"]="Recipient Passive Recipient Verb Theme"
levels(recreal$Envir)[levels(recreal$Envir)=="VNom VAcc NomAcc"]="Recipient Passive Verb Recipient--Theme"

nreal<-as.data.frame(rbind(areal,oereal,thereal,recreal))

greal<-nreal

greal$isDatAcc<-factor(greal$Envir)

levels(greal$isDatAcc)[levels(greal$isDatAcc)=='Active Theme--Recipient Verb']<-0
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Active Recipient--Theme Verb"]<-1
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Active Recipient Topicalisation"]<-NA        
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Active Theme Topicalisation"]<-NA
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Active Verb Theme--Recipient"]<-0
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Active Verb Recipient--Theme"]<-1       
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Theme Passive Recipient Topicalisation"]<-NA
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Theme Passive Theme Verb Recipient"]<-0
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Theme Passive Verb Recipient--Theme"]<-1
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Theme Passive Verb Theme--Recipient"]<-0
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Recipient Passive Theme Topicalisation"]<-NA
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Recipient Passive Recipient Verb Theme"]<-1
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Recipient Passive Verb Recipient--Theme"]<-1
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="Locative Inversion"]<-NA
levels(greal$isDatAcc)[levels(greal$isDatAcc)=="DatV NA NA"]<-NA

greal$isDatAcc<-as.numeric(as.character(greal$isDatAcc))

greal$NIO<-factor(greal$IO)
levels(greal$NIO)<-c('Recipient Noun','Recipient Pronoun','Recipient Noun','Recipient Empty','Recipient Pronoun')

greal$NDO<-factor(greal$DO)
levels(greal$NDO)<-c('Theme Noun','Theme Empty','Theme Pronoun','Theme Noun','Theme Empty','Theme Null','Theme Pronoun')

greal$eras<-as.numeric(as.character(cut(greal$YoC,breaks=seq(850,1950,100),labels=seq(900,1900,100))))

greal<-subset(greal,NIO!='Recipient Null'&NDO!='Theme Null'&NDO!='Theme Empty'&NIO!='Recipient Empty')

ns.ord<-ddply(greal,.(eras,Pas,NIO,NDO),summarise,val=mean(isDatAcc,na.rm=T),num=sum(!is.na(isDatAcc)))

ns.ord$num[ns.ord$num>50]<-50

ggplot(greal,aes(YoC,isDatAcc,color=Pas))+stat_smooth(method='glm',family='binomial')+geom_point(data=ns.ord,aes(eras,val,size=num))+facet_grid(NIO~NDO)
ggplot(greal,aes(YoC,isDatAcc,color=Pas))+stat_smooth(method='glm',formula=y~bs(x),family='binomial')+geom_point(data=ns.ord,aes(eras,val,size=num))+facet_grid(NIO~NDO)+facet_grid(NIO~NDO)+scale_x_continuous(breaks=seq(800,2000,50))
ggplot(greal,aes(YoC,isDatAcc,color=Pas))+stat_smooth(method='loess')+facet_grid(NIO~NDO)


greal2<-subset(greal,NVerb!='OLDENG'&NVerb!='SEND'&YoC>=1200)
ns.ord.nv<-ddply(greal2,.(eras,Pas,NIO,NDO,NVerb),summarise,val=mean(isDatAcc,na.rm=T),num=sum(!is.na(isDatAcc)))

ns.ord.nv$num[ns.ord.nv$num>50]<-50

ggplot(greal2,aes(YoC,isDatAcc,color=Pas,linetype=NVerb))+stat_smooth(method='loess',se=F)+facet_grid(NIO~NDO)+geom_point(data=ns.ord.nv,aes(eras,val,size=num,shape=NVerb))
ns.ord<-ddply(greal2,.(eras,Pas,NIO,NDO),summarise,val=mean(isDatAcc,na.rm=T),num=sum(!is.na(isDatAcc)))

ns.ord$num[ns.ord$num>50]<-50

ggplot(greal2,aes(YoC,isDatAcc,color=Pas))+stat_smooth(method='loess',se=F)+facet_grid(NIO~NDO)+geom_point(data=ns.ord,aes(eras,val,size=num))+scale_x_continuous(breaks=seq(1200,2000,50))


tnreal<-subset(greal,NDO=='Theme Noun')
tnreal$Pname<-as.character(tnreal$isTo)
tnreal$Pname[is.na(tnreal$Pname)]<-'0'
tnreal$Pname<-factor(tnreal$Pname)
levels(tnreal$Pname)<-c('Bare Recipient','To Marked Recipient')

tnreal$isPas<-factor(tnreal$Pas)
levels(tnreal$isPas)<-c(0,1)
tnreal$isPas<-as.numeric(as.character(tnreal$isPas))

tnreal$isPro<-factor(tnreal$NIO)
levels(tnreal$isPro)<-c(0,1)
tnreal$isPro<-as.numeric(as.character(tnreal$isPro))

ord.mod<-glm(data=tnreal,isDatAcc~YoC*isPro*isPas,family='binomial')
to.mod<-glm(data=tnreal,isTo~YoC*isPro*isPas*isDatAcc,family='binomial')

require(nnet)

pas<-subset(tnreal,isPas==1)

pas$Type<-factor(paste(pas$isDatAcc,pas$isTo))
levels(pas$Type)<-c('Bare Theme Passive','To-marked Theme Passive','Recipient Passive','Recipient Passive','Recipient Passive',NA,NA,NA)

mod<-multinom(data=pas,Type~bs(YoC)*isPro,family='binomial')

pred<-expand.grid(YoC=seq(850,1950,1),NIO=c('Recipient Noun','Recipient Pronoun'),Pas=c('Active','Passive'))

pred$isPas<-factor(pred$Pas)
levels(pred$isPas)<-c(0,1)
pred$isPas<-as.numeric(as.character(pred$isPas))

pred$isPro<-factor(pred$NIO)
levels(pred$isPro)<-c(0,1)
pred$isPro<-as.numeric(as.character(pred$isPro))

pred<-as.data.frame(cbind(pred,predict(mod,newdata=pred,type='probs')))
names(pred)<-c('YoC','NIO','Pas','isPas','isPro','btp','ttp','rp')

pas$isbtp<-factor(pas$Type)
levels(pas$isbtp)<-c(1,0,0)
pas$isbtp<-as.numeric(as.character(pas$isbtp))

pas$isttp<-factor(pas$Type)
levels(pas$isttp)<-c(0,1,0)
pas$isttp<-as.numeric(as.character(pas$isttp))

pas$isrp<-factor(pas$Type)
levels(pas$isrp)<-c(0,0,1)
pas$isrp<-as.numeric(as.character(pas$isrp))

ns<-ddply(pas,.(eras,NIO),summarise,
          btp.val=mean(isbtp,na.rm=T),btp.num=sum(!is.na(isbtp)),
          ttp.val=mean(isttp,na.rm=T),ttp.num=sum(!is.na(isttp)),
          rp.val=mean(isrp,na.rm=T),rp.num=sum(!is.na(isrp))
          )

ns$btp.num[ns$btp.num>50]<-50
ns$ttp.num[ns$ttp.num>50]<-50
ns$rp.num[ns$rp.num>50]<-50

ggplot(pred,aes(YoC,btp,color='Bare Theme Passive'))+
  geom_line()+geom_point(data=ns,aes(eras,btp.val,size=btp.num,colour='Bare Theme Passive'))+
  geom_line(aes(y=ttp,colour='To-Marked Theme Passive'))+geom_point(data=ns,aes(eras,ttp.val,size=ttp.num,colour='To-Marked Theme Passive'))+
  geom_line(aes(y=rp,colour='Recipient Passive'))+geom_point(data=ns,aes(eras,rp.val,size=rp.num,colour='Recipient Passive'))+
  facet_grid(~NIO)+
  coord_cartesian(ylim=c(0,1),xlim=c(850,1950))+
  scale_y_continuous(name='Prob. of Each Condition per Year')+
  scale_x_continuous(name='Year of Composition')+
  scale_size_continuous(name='Token/century',breaks=c(10,20,30,40,50),labels=c('10','20','30','40','>=50'))+
  scale_colour_discrete(name='Conditions')


act<-subset(tnreal,isPas==0)

act$Type<-factor(paste(act$isDatAcc,act$isTo))
levels(act$Type)<-c('Bare Theme-Recipient','To-marked Theme-Recipient','Bare Recipient-Theme','To-Marked Recipient Theme',NA,NA,NA)

mod<-multinom(data=act,Type~bs(YoC)*isPro,family='binomial')

pred<-expand.grid(YoC=seq(850,1950,1),NIO=c('Recipient Noun','Recipient Pronoun'))

pred$isPro<-factor(pred$NIO)
levels(pred$isPro)<-c(0,1)
pred$isPro<-as.numeric(as.character(pred$isPro))

pred<-as.data.frame(cbind(pred,predict(mod,newdata=pred,type='probs')))
names(pred)<-c('YoC','NIO','isPro','btr','ttr','brt','trt')

act$isbtr<-factor(act$Type)
levels(act$isbtr)<-c(1,0,0,0)
act$isbtr<-as.numeric(as.character(act$isbtr))

act$isttr<-factor(act$Type)
levels(act$isttr)<-c(0,1,0,0)
act$isttr<-as.numeric(as.character(act$isttr))

act$isbrt<-factor(act$Type)
levels(act$isbrt)<-c(0,0,1,0)
act$isbrt<-as.numeric(as.character(act$isbrt))

act$istrt<-factor(act$Type)
levels(act$istrt)<-c(0,0,0,1)
act$istrt<-as.numeric(as.character(act$istrt))

ns<-ddply(act,.(eras,NIO),summarise,
          btr.val=mean(isbtr,na.rm=T),btr.num=sum(!is.na(isbtr)),
          ttr.val=mean(isttr,na.rm=T),ttr.num=sum(!is.na(isttr)),
          brt.val=mean(isbrt,na.rm=T),brt.num=sum(!is.na(isbrt)),
          trt.val=mean(istrt,na.rm=T),trt.num=sum(!is.na(istrt))
)

ns$btr.num[ns$btr.num>50]<-50
ns$ttr.num[ns$ttr.num>50]<-50
ns$brt.num[ns$brt.num>50]<-50
ns$trt.num[ns$trt.num>50]<-50

ggplot(pred,aes(YoC,btr,color='Bare Theme-Recipient'))+
  geom_line()+geom_point(data=ns,aes(eras,btr.val,size=btr.num,colour='Bare Theme-Recipient'))+
  geom_line(aes(y=ttr,colour='To-Marked Theme-Recipient'))+geom_point(data=ns,aes(eras,ttr.val,size=ttr.num,colour='To-Marked Theme-Recipient'))+
  geom_line(aes(y=brt,colour='Bare Recipient-Theme'))+geom_point(data=ns,aes(eras,brt.val,size=brt.num,colour='Bare Recipient-Theme'))+
  geom_line(aes(y=trt,colour='To-Marked Recipient-Theme'))+geom_point(data=ns,aes(eras,trt.val,size=trt.num,colour='To-Marked Recipient-Theme'))+
  facet_grid(~NIO)+
  coord_cartesian(ylim=c(0,1),xlim=c(850,1950))+
  scale_y_continuous(name='Prob. of Each Condition per Year')+
  scale_x_continuous(name='Year of Composition')+
  scale_size_continuous(name='Token/century',breaks=c(10,20,30,40,50),labels=c('10','20','30','40','>=50'))+
  scale_colour_discrete(name='Conditions')



facet_grid(Pname~NIO)+
  coord_cartesian(ylim=c(0,1))+
  scale_y_continuous(name='Probability of Recipient--Theme Order/Recipient actsive')+
  scale_x_continuous(name='Year of Composition')+
  scale_size_continuous(name="Tokens/Century",breaks=c(10,20,30,40,50),labels=c('10','20','30','40','>=50'))+
  scale_colour_discrete(name="Voice",labels=c('Active','actsive'))


#ggplot(subset(greal,Clause%in%c('MAT','INF','SUB')),aes(YoC,isDatAcc,color=Pas,linetype=Clause))+stat_smooth(se=F,method='loess')+facet_grid(NIO~NDO)+coord_cartesian(ylim=c(0,1))

# 
# greal$NTo<-factor(greal$isTo)
# levels(greal$NTo)<-c('No To','Has To')
# 
# ns.ord<-ddply(greal,.(eras,Pas,NIO,NDO,NTo),summarise,val=mean(isDatAcc,na.rm=T),num=sum(!is.na(isDatAcc)))
# 
# ns.ord$num[ns.ord$num>50]<-50
# 
# 
# ggplot(greal,aes(YoC,isDatAcc,color=Pas))+stat_smooth(method='glm',formula=y~bs(x),family='binomial',se=F,aes(linetype=NTo))+geom_point(data=ns.ord,aes(eras,val,size=num,pch=NTo))+facet_grid(NIO~NDO)+scale_x_continuous(breaks=seq(800,2000,50))
# 
greal$NOrder<-factor(greal$isDatAcc)
levels(greal$NOrder)<-c('Theme--Recipient','Recipient--Theme')


ns<-ddply(greal,.(eras,Pas,NIO,NDO,NOrder),summarise,val=mean(isTo,na.rm=T),num=sum(!is.na(isTo)))

ns$num[ns$num>50]<-50


ggplot(greal,aes(YoC,isTo,color=Pas))+stat_smooth(method='glm',formula=y~bs(x),family='binomial',se=F,aes(linetype=NOrder))+geom_point(data=ns,aes(eras,val,size=num,pch=NOrder))+facet_grid(NIO~NDO)+scale_x_continuous(breaks=seq(800,2000,50))


#Compare loss of recipient passive to rise in to

rptn<-subset(greal,NIO=='Recipient Pronoun'&NDO=='Theme Noun')

pasrat<-1-mean(rptn$isDatAcc[rptn$Pas=='PAS'&rptn$YoC>=1375],na.rm=T)
actrat<-mean(rptn$isTo[rptn$Pas=='ACT'&rptn$YoC>=1375&rptn$NOrder=='Theme--Recipient'],na.rm=T)

rptn$zYear<-(rptn$YoC-mean(rptn$YoC))/sd(rptn$YoC)

yAct<-rptn$isTo[rptn$Pas=='ACT'&rptn$NOrder=='Theme--Recipient'&!is.na(rptn$isTo)]
xAct<-rptn$zYear[rptn$Pas=='ACT'&rptn$NOrder=='Theme--Recipient'&!is.na(rptn$isTo)]
rptn$isAccDat<-(rptn$isDatAcc-1)*-1
yPas<-rptn$isAccDat[rptn$Pas=='PAS'&!is.na(rptn$isAccDat)]
xPas<-rptn$zYear[rptn$Pas=='PAS'&!is.na(rptn$isAccDat)]

prob_ll<-function(a1=0,b1=0){
  pPas<-(pasrat/(1+exp(-((a1+b1*xPas)))))
  sumPas=-sum(stats::dbinom(yPas, 1, pPas,log=TRUE),na.rm=T)
  results<-sumPas
  # print(c(aUp,bUp,a1,a2,b1,b2))
  # print(results)
  if (is.finite(results)) { 
    if (is.nan(results)){
      results=NA
    }
  }
  else{
    results=NA
  } 
  results
}

require(bbmle)

fit_pas<-glm(yPas~xPas,family=binomial)


full_fit<-mle2(prob_ll,start=list(a1=1,b1=1))

full_fit2<-mle2(prob_ll,start=list(a1=coef(full_fit)[1],b1=coef(full_fit)[2]))
full_fit3<-coef(profile(full_fit2))
full_fit4<-mle2(prob_ll,start=list(a1=full_fit3[1],b1=full_fit3[3],a2=full_fit3[2],b2=full_fit3[4]),
                control=list(trace=1,REPORT=5,maxit=10000))
full_fit3<-profile(full_fit4)
full_fit4<-mle2(prob_ll,start=list(a1=full_fit3[1],b1=full_fit3[3],a2=full_fit3[2],b2=full_fit3[4]),
                control=list(trace=1,REPORT=5,maxit=10000))


pred<-expand.grid(YoC=seq(800,2000,1))
pred$zYear<-(pred$YoC-mean(rptn$YoC))/sd(rptn$YoC)
pred$y<-pasrat/(1+exp(-(coef(full_fit3)[1]+coef(full_fit3)[2]*pred$zYear)))
pred$y<-pasrat/(1+exp(-(full_fit3[1]+full_fit3[2]*pred$zYear)))
ggplot(data=subset(rptn,Pas=='PAS'),aes(YoC,isAccDat))+stat_smooth(method='loess',aes(colour='Smooth'))+geom_line(data=pred,aes(YoC,y,colour='Predict'))




noint_fit<-mle2(prob_ll,start=list(a1=0,b1=0,a2=0),method='BFGS',
               control=list(trace=1,REPORT=5,maxit=1000))

anova(noint_fit,full_fit)







greal$periods<-cut(greal$YoC,breaks=c(0,1100,1450,1700,1950),labels=c('Old','Middle','Early Modern','Modern'))

greal$NDO<-factor(greal$NDO)
greal$NIO<-factor(greal$NIO)

ftable(round(prop.table(table(greal$Pas,greal$NDO,greal$NIO,greal$NOrder,greal$NTo,greal$periods),c(1,2,3,6)),digits=2))

ftable(round(prop.table(table(greal$Pas,greal$NDO,greal$NIO,greal$NOrder,greal$periods),c(1,2,3,5)),digits=2))
ftable(round(prop.table(table(greal$Pas,greal$NDO,greal$NIO,greal$NTo,greal$periods),c(1,2,3,5)),digits=2))

ggplot(greal,aes(YoC,isTo,color=Pas,linetype=NGenre))+stat_smooth(method='glm',formula=y~bs(x),family='binomial',se=F)+facet_grid(NDO~NIO)
ggplot(greal,aes(YoC,isDatAcc,color=Pas,linetype=NGenre))+stat_smooth(method='glm',formula=y~bs(x),family='binomial',se=F)+facet_grid(NDO~NIO)

greal$isThemeHeavy<-factor(greal$AccSize)
greal$isThemeHeavy[greal$isThemeHeavy=='MORE']<-20
greal$isThemeHeavy<-as.numeric(as.character(greal$isThemeHeavy))
greal$isThemeHeavy<-cut(greal$isThemeHeavy,breaks=c(0,2,5,22),labels=c('Light','Medium','Heavy'))
greal$isThemeHeavy[greal$AccCP=='AccHasCP']<-'Heavy'

ns<-ddply(subset(greal,Pas=='ACT'&NOrder=='Recipient--Theme'),.(eras,NIO,isThemeHeavy),summarise,val=mean(isTo,na.rm=T),num=sum(!is.na(isTo)))

ns$num[ns$num>50]<-50


ggplot(subset(greal,Pas=='ACT'&NOrder=='Recipient--Theme'&YoC>=1700),aes(AS,isTo,colour=NIO))+stat_smooth()


old<-subset(greal,YoC<=1400)
old$Cent<-as.numeric(as.character(cut(old$YoC,breaks=seq(600,1400,400),labels=seq(800,1200,400))))

ftable(prop.table(table(old$NIO[old$Pas=='PAS'],old$Cent[old$Pas=='PAS'],old$isDatAcc[old$Pas=='PAS']),c(1,2)))

mod.order<-glm()

greal$isPas<-factor(greal$Pas)
levels(greal$isPas)<-c(-1,1)
greal$isPas<-as.numeric(as.character(greal$isPas))

greal$isIOPro<-factor(greal$NIO)
levels(greal$isIOPro)<-c(-1,1,NA)
greal$isIOPro<-as.numeric(as.character(greal$isIOPro))

greal$isDOPro<-factor(greal$NDO)
levels(greal$isDOPro)<-c(-1,NA,1)
greal$isDOPro<-as.numeric(as.character(greal$isDOPro))

full<-glm(data=greal,isDatAcc~YoC*isPas*isIOPro*isDOPro,family='binomial')
noyearint<-glm(data=greal,isDatAcc~YoC+isPas*isIOPro*isDOPro,family='binomial')
noyear<-glm(data=greal,isDatAcc~isPas*isIOPro*isDOPro,family='binomial')

anova(noyear,noyearint,full,test='LRT')
AIC()
#


greal<-subset(nreal,Envir == "Active Recipient Topicalisation"|Envir=="Active Theme Topicalisation"|Envir=="Active Verb Theme--Recipient" | Envir == "Active Verb Recipient--Theme" | Envir == "Theme Passive Theme Verb Recipient")

greal$Envir<-factor(greal$Envir)

levels(greal$Envir)[levels(greal$Envir)=="Active Recipient Topicalisation"]="(To) recipient, I gave theme"
levels(greal$Envir)[levels(greal$Envir)=="Active Theme Topicalisation"]="Theme, I gave (to) recipient"
levels(greal$Envir)[levels(greal$Envir)=="Active Verb Theme--Recipient"]="I gave theme (to) recipient"      
levels(greal$Envir)[levels(greal$Envir)=="Active Verb Recipient--Theme"]="I gave (to) recipient theme"
levels(greal$Envir)[levels(greal$Envir)=="Theme Passive Theme Verb Recipient"]="Theme was given (to) recipient"

greal$IO<-factor(greal$IO)
levels(greal$IO)<-c('Recipient Noun','Recipient Pronoun')

greal$Eras<-cut(greal$YoC,seq(1200,2000,50),seq(1225,1975,50))
greal$Eras<-as.numeric(as.character(greal$Eras))

levels(greal$DO)<-c('Theme Noun','Theme Empty','Theme Pronoun','Theme Noun','Theme Pronoun','Theme Empty')

greal<-subset(greal,Envir %in% c('I gave (to) recipient theme','I gave theme (to) recipient')&IO=='Recipient Noun'&DO=='Theme Noun')

mreal<-subset(greal,NVerb!='SEND'&IO=='Recipient Noun'&DO=='Theme Noun')
mreal$SYear<-(mreal$YoC-mean(mreal$YoC))/sd(mreal$YoC)