library(dplyr)
library(ggplot2)
library(epicalc)
library(knitr)
library(nnet)
library(splines)
library(MASS)
library(xtable)
library(bbmle)
library(boot)

dit <- read.csv('adj.tsv',sep='\t')
odit <- read.csv('oldadj.tsv',sep='\t')
odit$Text<-''

for (i in 1:dim(odit)[1]) {
  odit$Text[i] <- as.vector(strsplit(as.character(odit$ID)[i],','))[[1]][1]
}

dit$Text<-as.character(dit$Text)

levels(dit$Clause)[1]<-'ABS'

real<-subset(as.data.frame(rbind(odit,dit)),!is.na(Verb))

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

brit<-greal
save(brit,file='BritishData.RData')
