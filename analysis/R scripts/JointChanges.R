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

#Load American data
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

rptnpas<-subset(gjoint,voice=='Passive'&IO=='Recipient Pronoun'&DO=='Theme Noun')
full<-glm(data=rptnpas,isRecPas~year*Verb,family=binomial)
noint<-glm(data=rptnpas,isRecPas~year+Verb,family=binomial)
noverb<-glm(data=rptnpas,isRecPas~year,family=binomial)
null<-glm(data=rptnpas,isRecPas~1,family=binomial)

anova(null,noverb,noint,full,test='Chisq')

act<-subset(rdata,Voice=='Active'&cond %in% c('gave him it','gave it to him'))


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

crit$decade<-cut(crit$year,breaks=seq(1800,2010,10),labels=seq(1805,2005,10))

bnact<-subset(crit,IO=='Recipient Noun'&DO=='Theme Noun')

levels(joint$cond)<-c('gave him it/he was given it','gave to him it/to him was given it','gave it to him/it was given to him','gave it him/it was given him',NA)

joint$Order<-factor(joint$cond)
levels(joint$Order)<-c('Recipient First','Recipient First','Theme First','Theme First')

joint$isRecFirst<-factor(joint$Order)
levels(joint$isRecFirst)<-c(1,0)
joint$isRecFirst<-as.numeric(as.character(joint$isRecFirst))

joint<-subset(joint,!is.na(DO))

table(joint$voice,joint$Verb)

greal$cond<-factor(paste(greal$isDatAcc,greal$isTo))
levels(greal$cond)<-c('gave it him/it was given him',
                      'gave it to him/it was given to him',
                      'gave him it/he was given it',
                      'gave to him it/to him was given it',
                      NA,
                      NA,
                      NA,
                      NA)

nsreal<-subset(greal,NVerb!='SEND'&NVerb!='OLDENG')

nsreal$period<-cut(nsreal$YoC,breaks=c(1,1300,1500,1700,2000),labels=c('Old English','Middle English','Early Modern English','Modern English'))

table(nsreal$Pas,nsreal$period)

omjoint<-data.frame(id=nsreal$ID,year=nsreal$YoC,genre=nsreal$NGenre,IO=nsreal$NIO,DO=nsreal$NDO,cond=nsreal$cond,voice=nsreal$Pas,Order=NA,isRecFirst=nsreal$isDatAcc,Verb='British')

njoint<-as.data.frame(rbind(joint,subset(omjoint,year>=1300&!is.na(isRecFirst))))

njoint$isTo<-factor(njoint$cond)
levels(njoint$isTo)<-c(0,1,1,0)
njoint$isTo<-as.numeric(as.character(njoint$isTo))

njoint$eras<-as.numeric(as.character(cut(njoint$year,
                                         breaks=c(seq(1300,2020,20)),
                                         labels=c(seq(1310,2010,20)))))

levels(njoint$voice)<-c('Passive','Active','Active','Passive')
njoint$IO<-factor(njoint$IO)
njoint$DO<-factor(njoint$DO)

# ns.ord<-group_by(njoint,eras,voice,IO,DO,Verb)%>%summarise(val=mean(isRecFirst),num=sum(!is.na(isRecFirst)))
# 
# njoint$DO<-relevel(njoint$DO,'Theme Noun')
# 
# ggplot(njoint,aes(year,isRecFirst,colour=Verb,linetype=voice))+
#   stat_smooth(method='loess',se=F)+
#   geom_point(data=ns.ord,aes(eras,val,size=log(num),shape=voice))+
#   facet_grid(DO~IO)+
#   scale_x_continuous(breaks=seq(850,2050,100))+
#   scale_y_continuous(name='% Recipient--Theme Orders',breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
#   coord_cartesian(ylim=c(-0.01,1.01))+
#   scale_size_continuous(name='Number of Tokens')+
#   scale_colour_discrete(name='Voice')+ 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1))

tpjoint<-subset(njoint,DO=='Theme Pronoun')
tab<-xtabs(tpjoint$isRecFirst~tpjoint$Verb+tpjoint$voice)/table(tpjoint$Verb,tpjoint$voice)
(sum(tab)-0.08278803)/5

tpjoint$Verb<-relevel(tpjoint$Verb,'British')
#Brit
full<-glm(data=subset(tpjoint,Verb=='British'),isRecFirst~year*voice,family=binomial)
noint<-glm(data=subset(tpjoint,Verb=='British'),isRecFirst~year+voice,family=binomial)
noyear<-glm(data=subset(tpjoint,Verb=='British'),isRecFirst~voice,family=binomial)
null<-glm(data=subset(tpjoint,Verb=='British'),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)
#Offer
full<-glm(data=subset(tpjoint,Verb=='offer'),isRecFirst~year*voice,family=binomial)
noint<-glm(data=subset(tpjoint,Verb=='offer'),isRecFirst~year+voice,family=binomial)
noyear<-glm(data=subset(tpjoint,Verb=='offer'),isRecFirst~voice,family=binomial)
null<-glm(data=subset(tpjoint,Verb=='offer'),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)

#Give
full<-glm(data=subset(tpjoint,Verb=='give'),isRecFirst~year*voice,family=binomial)
noint<-glm(data=subset(tpjoint,Verb=='give'),isRecFirst~year+voice,family=binomial)
noyear<-glm(data=subset(tpjoint,Verb=='give'),isRecFirst~voice,family=binomial)
null<-glm(data=subset(tpjoint,Verb=='give'),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)

bnjoint<-subset(njoint,IO=='Recipient Noun'&DO=='Theme Noun')

#British
full<-glm(data=subset(bnjoint,Verb=='British'),isRecFirst~year*voice,family=binomial)
noint<-glm(data=subset(bnjoint,Verb=='British'),isRecFirst~year+voice,family=binomial)
noyear<-glm(data=subset(bnjoint,Verb=='British'),isRecFirst~voice,family=binomial)
null<-glm(data=subset(bnjoint,Verb=='British'),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)

bnjoint$NVerb<-factor(bnjoint$Verb)
levels(bnjoint$NVerb)<-c('American','American','British')

ns.ord<-group_by(bnjoint,eras,voice,NVerb)%>%summarise(val=mean(isRecFirst),num=sum(!is.na(isRecFirst)))

ggplot(bnjoint,aes(year,isRecFirst,linetype=NVerb,colour=voice))+
  stat_smooth(method='loess',se=F)+
  geom_point(data=ns.ord,aes(eras,val,size=log(num),shape=NVerb))+
  scale_x_continuous(name='Year of Composition',breaks=seq(1300,2000,50))+
  scale_y_continuous(name='% Recipient--Theme Orders',breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  coord_cartesian(ylim=c(-0.01,1.01))+
  scale_size_continuous(name='Number of Tokens (log)')+
  scale_colour_discrete(name='Voice')+ 
  scale_shape_discrete(name='Variety of English')+
  scale_linetype_discrete(name='Variety of English')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),text = element_text(size=20))

ambn<-subset(bnjoint,NVerb=='American')

#Active

full<-glm(data=subset(ambn,voice=='Active'),isRecFirst~year*Verb,family=binomial)
noint<-glm(data=subset(ambn,voice=='Active'),isRecFirst~year+Verb,family=binomial)
noyear<-glm(data=subset(ambn,voice=='Active'),isRecFirst~Verb,family=binomial)
null<-glm(data=subset(ambn,voice=='Active'),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)


#Passive

full<-glm(data=subset(ambn,voice=='Passive'),isRecFirst~year*Verb,family=binomial)
noint<-glm(data=subset(ambn,voice=='Passive'),isRecFirst~year+Verb,family=binomial)
noyear<-glm(data=subset(ambn,voice=='Passive'),isRecFirst~Verb,family=binomial)
null<-glm(data=subset(ambn,voice=='Passive'),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)


#American Voice

full<-glm(data=ambn,isRecFirst~year*voice,family=binomial)
noint<-glm(data=ambn,isRecFirst~year+voice,family=binomial)
noyear<-glm(data=ambn,isRecFirst~voice,family=binomial)
null<-glm(data=ambn,isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)

full<-glm(data=subset(ambn,year>=1930),isRecFirst~year*voice,family=binomial)
noint<-glm(data=subset(ambn,year>=1930),isRecFirst~year+voice,family=binomial)
noyear<-glm(data=subset(ambn,year>=1930),isRecFirst~voice,family=binomial)
null<-glm(data=subset(ambn,year>=1930),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)


full<-glm(data=subset(ambn,year>=1990),isRecFirst~Verb*voice,family=binomial)
noint<-glm(data=subset(ambn,year>=1990),isRecFirst~Verb+voice,family=binomial)
noyear<-glm(data=subset(ambn,year>=1990),isRecFirst~voice,family=binomial)
null<-glm(data=subset(ambn,year>=1990),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)

full<-glm(data=subset(ambn,voice=='Passive'&year<=1950&year>=1880),isRecFirst~year*Verb,family=binomial)
noint<-glm(data=subset(ambn,voice=='Passive'&year<=1950&year>=1880),isRecFirst~year+Verb,family=binomial)
noyear<-glm(data=subset(ambn,voice=='Passive'&year<=1950&year>=1880),isRecFirst~Verb,family=binomial)
null<-glm(data=subset(ambn,voice=='Passive'&year<=1950&year>=1880),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)


am.ord<-group_by(ambn,eras,voice,Verb)%>%summarise(val=mean(isRecFirst),num=sum(!is.na(isRecFirst)))

ggplot(ambn,aes(year,isRecFirst,linetype=Verb,colour=voice))+
  stat_smooth(method='loess',se=F)+
  geom_point(data=am.ord,aes(eras,val,size=log(num),shape=Verb))+
  scale_x_continuous(name='Year of Composition',breaks=seq(1800,2010,10))+
  scale_y_continuous(name='% Recipient--Theme Orders',breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  coord_cartesian(ylim=c(-0.01,1.01))+
  scale_size_continuous(name='Number of Tokens (log)')+
  scale_colour_discrete(name='Voice')+ 
  scale_shape_discrete(name='Verb',labels=c('GIVE','OFFER'))+
  scale_linetype_discrete(name='Verb',labels=c('GIVE','OFFER'))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),text = element_text(size=20))


toreal<-subset(nsreal,NAdj %in% c('Adjacent','ProIntervene')&YoC>=1300&cond %in% c('gave it him/it was given him','gave it to him/it was given to him'))
tojoint<-data.frame(id=toreal$ID,year=toreal$YoC,genre=toreal$NGenre,IO=toreal$NIO,DO=toreal$NDO,cond=toreal$cond,voice=toreal$Pas,Order=NA,isRecFirst=toreal$isDatAcc,Verb='British')

levels(tojoint$voice)<-c('Active','Passive')

bntoset<-as.data.frame(rbind(subset(joint,IO=='Recipient Noun'&isRecFirst==0&((DO=='Theme Pronoun')|(voice=='Passive'))),subset(tojoint,IO=='Recipient Noun')))

bntoset$eras<-as.numeric(as.character(cut(bntoset$year,
                                         breaks=c(seq(1300,2020,20)),
                                         labels=c(seq(1310,2010,20)))))


bntoset$isTo<-factor(bntoset$cond)
levels(bntoset$isTo)<-c(1,0)
bntoset$isTo<-as.numeric(as.character(bntoset$isTo))

bntoset$NVerb<-factor(bntoset$Verb)
levels(bntoset$NVerb)<-c('American','American','British')

#British
full<-glm(data=subset(bntoset,Verb=='British'&year>=1400),isTo~year*voice,family=binomial)
noint<-glm(data=subset(bntoset,Verb=='British'&year>=1400),isTo~year+voice,family=binomial)
noyear<-glm(data=subset(bntoset,Verb=='British'&year>=1400),isTo~voice,family=binomial)
null<-glm(data=subset(bntoset,Verb=='British'&year>=1400),isTo~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)

ns.to<-group_by(bntoset,eras,voice,NVerb)%>%summarise(val=mean(isTo,na.rm=T),num=sum(!is.na(isTo)))


ggplot(bntoset,aes(year,isTo,linetype=NVerb,colour=voice))+
  stat_smooth(method='loess',se=F)+
  geom_point(data=ns.to,aes(eras,val,size=log(num),shape=NVerb))+
  scale_x_continuous(name='Year of Composition',breaks=seq(1300,2000,100))+
  scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  coord_cartesian(ylim=c(-0.01,1.01))+
  scale_size_continuous(name='Number of Tokens (log)')+
  scale_colour_discrete(name='Voice')+ 
  scale_shape_discrete(name='Variety of English')+
  scale_linetype_discrete(name='Variety of English')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),text = element_text(size=20))

ambmto<-subset(bntoset,NVerb=='American')

#Active
full<-glm(data=subset(ambmto,voice=='Active'),isTo~year*Verb,family=binomial)
noint<-glm(data=subset(ambmto,voice=='Active'),isTo~year+Verb,family=binomial)
noyear<-glm(data=subset(ambmto,voice=='Active'),isTo~Verb,family=binomial)
null<-glm(data=subset(ambmto,voice=='Active'),isTo~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)


am.to<-group_by(ambmto,eras,voice,Verb)%>%summarise(val=mean(isTo,na.rm=T),num=sum(!is.na(isTo)))

ggplot(ambmto,aes(year,isTo,linetype=Verb,colour=voice))+
  stat_smooth(method='loess',se=F)+
  geom_point(data=am.to,aes(eras,val,size=log(num),shape=Verb))+
  scale_x_continuous(name='Year of Composition',breaks=seq(1300,2000,100))+
  scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  coord_cartesian(ylim=c(-0.01,1.01))+
  scale_size_continuous(name='Number of Tokens (log)')+
  scale_colour_discrete(name='Voice')+ 
  scale_shape_discrete(name='Verb',labels=c('GIVE','OFFER'))+
  scale_linetype_discrete(name='Verb',labels=c('GIVE','OFFER'))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),text = element_text(size=20))




gives<-read.csv('indepth_give_coded_final.txt',sep='\t')
offers<-read.csv('indepth_offer_coded_final.txt',sep='\t')
pases<-read.csv('indepth_pas_coded_final.txt',sep='\t')

gives$Verb<-'give'
offers$Verb<-'offer'
offers$isIdiom<-0
gives$Voice<-'Active'
pases$isIdiom<-0

indepth<-as.data.frame(rbind(gives,offers,pases))
indepth$Voice<-factor(indepth$Voice)
indepth$Verb<-factor(indepth$Verb)

indepth$isDOC<-factor(indepth$Order)
levels(indepth$isDOC)<-c(0,1)
indepth$isDOC<-as.numeric(as.character(indepth$isDOC))

indepth$difsign<-indepth$LengthDiff/abs(indepth$LengthDiff)
indepth$logdif<-log(abs(indepth$LengthDiff))*indepth$difsign
indepth$logdif[is.na(indepth$logdif)]<-0

indepth$period<-cut(indepth$year,breaks=c(1000,1900,3000),labels=c('Early','Late'))
full<-glm(data=indepth,isDOC~(IOAnim+IONum+DONum+logdif+IODef*DODef)*period*Verb*Voice,family='binomial')
onlyanimverbint<-glm(data=indepth,isDOC~(IOAnim+logdif+IODef+DODef)+Verb+Verb:IOAnim+period,family='binomial')
noverbint<-glm(data=indepth,isDOC~(IOAnim+logdif+IODef+DODef)+Verb+period,family='binomial')
noanim<-glm(data=indepth,isDOC~(logdif+IODef+DODef)+Verb+period,family='binomial')
noyear<-glm(data=indepth,isDOC~(logdif+IODef+DODef)+Verb,family='binomial')
noverb<-glm(data=indepth,isDOC~(logdif+IODef+DODef),family='binomial')
nodef<-glm(data=indepth,isDOC~(logdif),family='binomial')
null<-glm(data=indepth,isDOC~1,family='binomial')
up.mod<-stepAIC(data=indepth,null,scope=isDOC~(IOAnim+IONum+DONum+logdif+IODef*DODef)*period*Verb*Voice)
down.mod<-stepAIC(data=indepth,full,scope=isDOC~(IOAnim+IONum+DONum+logdif+IODef*DODef)*period*Verb*Voice)

anova(null,nodef,noverb,noyear,noanim,noverbint,onlyanimverbint,full,test='Chisq')
AIC(null,nodef,noverb,noyear,noanim,noverbint,onlyanimverbint,full)

# write("",file="indepth_formulae.txt")
# i<-0
# bootfun<-function(data,indices)
# {
#   i<<-i+1
#   print(i)
#   d <- data[indices,]
#   mod<-stepAIC(data=d,glm(data=d,isDOC~1,family='binomial'),scope=isDOC~(IOAnim+IONum+DONum+logdif+IODef*DODef)*period*Verb*Voice,trace=0)
#   print(formula(mod))
#   write(as.character(formula(mod))[3],file="indepth_formulae.txt",append=T)
#   return(as.character(formula(mod))[3])
# }
# 
# m.boot<-boot(data=indepth,statistic=bootfun,R=200)

#Calculation of % of bootstraps that have each variable/interaction

# period: 100.0%
# logdif: 100.0%
# IODef: 100.0%
# IOAnim: 100.0%
# DODef: 100.0%
# period:Voice: 99.5%
# logdif:Voice: 99.5%
# Voice: 99.5%
# Verb: 78.11%
# IONum: 77.61%
# period:IOAnim: 71.64%
# IOAnim:Verb: 65.67%
# Voice:Verb: 58.71%
# period:DODef: 42.79%
# Verb:IONum: 28.86%
# period:IODef: 26.87%
# IONum:Verb: 26.37%
# IOAnim:Voice: 24.88%
# DONum: 23.38%
# Voice:DODef: 21.89%
# logdif:Verb: 19.4%
# DODef:Voice: 18.91%
# Verb:Voice: 18.91%
# period:IONum: 15.92%
# IODef:Verb: 15.92%
# Voice:IOAnim: 15.42%
# Voice:IODef: 13.93%
# IODef:Voice: 13.43%
# period:logdif: 12.94%
# DODef:Verb: 11.44%
# period:DONum: 11.44%
# IODef:DODef: 10.95%
# Voice:IONum: 10.45%
# Verb:DONum: 9.95%
# period:Verb: 9.45%
# Voice:DONum: 7.46%
# DODef:IODef: 6.47%
# IOAnim:Voice:Verb: 5.47%
# logdif:period: 4.98%
# period:IOAnim:Voice: 4.98%
# Verb:DODef: 4.48%
# Voice:IOAnim:Verb: 3.48%
# DONum:Verb: 3.48%
# logdif:Voice:Verb: 2.99%
# period:logdif:Voice: 2.99%
# period:Voice:IOAnim: 2.49%
# period:Voice:Verb: 2.49%
# Verb:IODef: 2.49%
# IOAnim:Verb:Voice: 1.99%
# period:Voice:DONum: 1.49%
# DODef:Verb:Voice: 1.49%
# Voice:IODef:Verb: 1.49%
# logdif:Verb:Voice: 1.49%
# IONum:Voice: 1.49%
# Voice:DONum:Verb: 1.0%
# period:Verb:DONum: 1.0%
# Voice:DODef:Verb: 1.0%
# period:Verb:Voice: 1.0%
# IOAnim:period: 1.0%
# Verb:IOAnim: 1.0%
# period:IODef:Voice: 1.0%
# period:IOAnim:Verb: 1.0%
# period:DODef:Voice: 1.0%
# period:DODef:IODef: 1.0%
# period:Voice:DODef: 1.0%
# Voice:Verb:DONum: 0.5%
# Verb:Voice:IONum: 0.5%
# Voice:IONum:Verb: 0.5%
# IODef:Verb:Voice: 0.5%
# Verb:Voice:DONum: 0.5%
# Verb:DODef:Voice: 0.5%
# period:Voice:IONum: 0.5%
# DONum:Voice: 0.5%
# IODef:Voice:Verb: 0.5%
# period:IODef:DODef: 0.5%
# DODef:Voice:Verb: 0.5%
# IONum:Verb:Voice: 0.5%
# period:Voice:IODef: 0.5%
# Voice:IODef:DODef: 0.5%

i<-0
boot.vals<-function(data,indices)
{
  i<<-i+1
  d <- data[indices,]
  mod <- glm(data=d,isDOC~period + logdif + IODef + IOAnim + DODef + period:Voice + logdif:Voice + Voice + Verb + IONum + period:IOAnim + IOAnim:Verb + Voice:Verb,family=binomial)
  print(i)
  return(c(AIC(mod),coef(mod)))
}

coef.boot<-boot(data=indepth,statistic=boot.vals,R=2000)

boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=1)
# Intervals : 
#   Level      Normal              Basic         
# 95%   (595.6, 711.9 )   (596.2, 713.5 )  
# 
# Level     Percentile            BCa          
# 95%   (567.0, 684.2 )   (595.8, 713.9 )
boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=2) # period
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-1.6639, -0.0576 )   (-1.6507, -0.0173 )  
# 
# Level     Percentile            BCa          
# 95%   (-1.7273, -0.0939 )   (-1.7549, -0.1129 )  

boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=3) # logdif
# Intervals : 
#   Level      Normal              Basic         
# 95%   ( 0.499,  1.810 )   ( 0.472,  1.791 )  
# 
# Level     Percentile            BCa          
# 95%   ( 0.552,  1.872 )   ( 0.517,  1.832 )

boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=4) # IODef
# Intervals : 
#   Level      Normal              Basic         
# 95%   ( 0.964,  1.762 )   ( 0.932,  1.726 )  
# 
# Level     Percentile            BCa          
# 95%   ( 1.089,  1.882 )   ( 1.053,  1.815 ) 

boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=5) # IOAnim
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-1.4234, -0.5234 )   (-1.4139, -0.5140 )  
# 
# Level     Percentile            BCa          
# 95%   (-1.4770, -0.5770 )   (-1.4315, -0.5399 )

boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=6) # DODef
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-1.1814,  0.3474 )   (-1.1512,  0.3594 )  
# 
# Level     Percentile            BCa          
# 95%   (-1.2380,  0.2726 )   (-1.2082,  0.2935 )
boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=7) # period:Voice
# Intervals : 
#   Level      Normal              Basic         
# 95%   ( 0.621,  1.680 )   ( 0.595,  1.655 )  
# 
# Level     Percentile            BCa          
# 95%   ( 0.691,  1.752 )   ( 0.645,  1.713 ) 
boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=8) # logdif:Voice
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-4.218, -2.313 )   (-4.145, -2.221 )  
# 
# Level     Percentile            BCa          
# 95%   (-4.563, -2.638 )   (-4.269, -2.434 )
boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=9) # Voice
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-1.739, -0.440 )   (-1.723, -0.425 )  
# 
# Level     Percentile            BCa          
# 95%   (-1.787, -0.489 )   (-1.767, -0.464 )
boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=10) # Verb
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-0.0332,  0.8982 )   (-0.0355,  0.9017 )  
# 
# Level     Percentile            BCa          
# 95%   (-0.0249,  0.9122 )   (-0.0249,  0.9122 ) 
boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=11) # IONum
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-1.784, -0.790 )   (-1.779, -0.774 )  
# 
# Level     Percentile            BCa          
# 95%   (-1.879, -0.873 )   (-1.790, -0.802 )
boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=12) # period:IOAnim
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-1.784, -0.790 )   (-1.779, -0.774 )  
# 
# Level     Percentile            BCa          
# 95%   (-1.879, -0.873 )   (-1.790, -0.802 )
boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=13) # IOAnim:Verb
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-1.929, -0.073 )   (-1.919, -0.086 )  
# 
# Level     Percentile            BCa          
# 95%   (-1.950, -0.117 )   (-1.942, -0.098 )
boot.ci(boot.out=coef.boot,type=c('norm','basic','perc','bca'),index=14) # Voice:Verb
# Intervals : 
#   Level      Normal              Basic         
# 95%   (-3.061,  1.013 )   (-2.202,  0.323 )  
# 
# Level     Percentile            BCa          
# 95%   (-2.649, -0.124 )   (-2.328,  0.011 )


cur.full<-glm(data=indepth,isDOC~period + logdif + IODef + IOAnim + DODef + period:Voice + logdif:Voice + Voice + Verb + IONum + period:IOAnim + IOAnim:Verb + Voice:Verb,family=binomial)
cur.small<-glm(data=indepth,isDOC~period + logdif + IODef + DODef + period:Voice + logdif:Voice + Voice + Verb + IONum + period:IOAnim + IOAnim:Verb + Voice:Verb,family=binomial)
anova(cur.small,cur.full,test='Chisq')

all.vars(as.formula(cur.full)) 


pred<-expand.grid(Verb=c('give','offer'),logdif=0,IONum=c('Singular'),DONum=c('Singular'),IODef=c('Definite','Indefinite'),DODef=c('Definite','Indefinite'),IOAnim=c('Inanimate','Animate'),period=c('Early','Late'),Voice=c('Active','Passive'),IONum='Singular')
pred$isDOC<-predict(cur.full,newdata=pred,type='response')

pred$Year<-pred$period
levels(pred$Year)<-c(0,1)
pred$Year<-as.numeric(as.character(pred$Year))

ggplot(data=subset(pred,Voice=='Active'&IODef=='Definite'&DODef=='Definite'),aes(Year,isDOC,colour=Verb,linetype=IOAnim,shape=IOAnim))+geom_point()+geom_line()
ggplot(data=subset(pred,Voice=='Passive'&IODef=='Definite'&DODef=='Definite'),aes(Year,isDOC,colour=Verb,linetype=IOAnim,shape=IOAnim))+geom_point()+geom_line()
ggplot(data=subset(pred,Verb=='give'&IODef=='Definite'&DODef=='Definite'),aes(Year,isDOC,colour=Voice,linetype=IOAnim,shape=IOAnim))+geom_point()+geom_line()
ggplot(data=subset(pred,Verb=='offer'&IODef=='Definite'&DODef=='Definite'),aes(Year,isDOC,colour=Voice,linetype=IOAnim,shape=IOAnim))+geom_point()+geom_line()

ggplot(data=subset(pred,IODef=='Definite'&DODef=='Definite'),aes(Year,isDOC,linetype=IOAnim,shape=IOAnim))+
  stat_summary(fun.y=mean,geom='point')+stat_summary(fun.y=mean,geom='line')+
  facet_grid(~Voice)+
  coord_cartesian(ylim=c(0,1))+
  scale_y_continuous(name='Predicted Percent "verbed John the book"',breaks=c(0,0.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  scale_x_continuous(name='Period',breaks=c(0,1),labels=c('Early','Late'))+
  scale_shape_discrete(name='Recipient Animacy')+scale_linetype_discrete(name='Recipient Animacy')

early<-subset(indepth,period=='Early')

summary(glm(data=early,isDOC~logdif + IODef + IOAnim + DODef  + Voice + Verb + IONum + IOAnim:Verb + Voice:Verb,family=binomial))

idpred<-expand.grid(Verb=c('give','offer'),logdif=0,IONum=c('Singular'),DONum=c('Singular'),IODef=c('Definite','Indefinite'),DODef=c('Definite','Indefinite'),IOAnim=c('Inanimate','Animate'),period=c('Early','Late'))
idpred$prob.best<-predict(onlyanimverbint,newdata=idpred,type='response')
idpred$prob.smod<-predict(smod,newdata=idpred,type='response')
idpred$year<-factor(idpred$period)
levels(idpred$year)<-c(1820,2000)
idpred$year<-as.numeric(as.character(idpred$year))
ggplot(idpred,aes(year,prob.best,colour=Verb,linetype=IOAnim))+geom_line()+facet_grid(IODef~DODef)
ggplot(idpred,aes(year,prob.smod,colour=Verb,linetype=IOAnim))+geom_line()+facet_grid(IODef~DODef)

indepth$pyear<-factor(indepth$period)
levels(indepth$pyear)<-c(1820,2000)
indepth$pyear<-as.numeric(as.character(indepth$pyear))
ggplot(indepth,aes(pyear,isDOC,colour=Verb,linetype=IOAnim))+stat_summary(fun.y=mean,geom='line')+facet_grid(IODef~DODef)
as.data.frame(group_by(indepth,IODef,DODef,IOAnim,Verb,period)%>%summarise(val=mean(isDOC),num=n()))

require(partykit)
plot(ctree(data=indepth,factor(isDOC)~(period+IOAnim+IONum+DONum+logdif+IODef+DODef+Verb)))

rpjoint<-subset(njoint,IO=='Recipient Pronoun'&DO=='Theme Noun')

rpjoint$NVerb<-factor(rpjoint$Verb)
levels(rpjoint$NVerb)<-c('American','American','British')

full<-glm(data=subset(rpjoint,Verb=='British'&voice=='Passive'),isRecFirst~year,family=binomial)
null<-glm(data=subset(rpjoint,Verb=='British'&voice=='Passive'),isRecFirst~1,family=binomial)
anova(null,full,test='Chisq')

full<-glm(data=subset(rpjoint,Verb=='British'&voice=='Active'),isRecFirst~year,family=binomial)
null<-glm(data=subset(rpjoint,Verb=='British'&voice=='Active'),isRecFirst~1,family=binomial)
anova(null,full,test='Chisq')


ns.ord<-group_by(rpjoint,eras,voice,NVerb)%>%summarise(val=mean(isRecFirst),num=sum(!is.na(isRecFirst)))

ggplot(rpjoint,aes(year,isRecFirst,linetype=NVerb,colour=voice))+
  stat_smooth(method='loess',se=F)+
  geom_point(data=ns.ord,aes(eras,val,size=log(num),shape=NVerb))+
  scale_x_continuous(name='Year of Composition',breaks=seq(1300,2000,50))+
  scale_y_continuous(name='% Recipient--Theme Orders',breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  coord_cartesian(ylim=c(-0.01,1.01))+
  scale_size_continuous(name='Number of Tokens (log)')+
  scale_colour_discrete(name='Voice')+ 
  scale_shape_discrete(name='Variety of English')+
  scale_linetype_discrete(name='Variety of English')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),text = element_text(size=20))

amrp<-subset(rpjoint,NVerb=='American')

#Active

full<-glm(data=subset(amrp,voice=='Active'),isRecFirst~year*Verb,family=binomial)
noint<-glm(data=subset(amrp,voice=='Active'),isRecFirst~year+Verb,family=binomial)
noyear<-glm(data=subset(amrp,voice=='Active'),isRecFirst~Verb,family=binomial)
null<-glm(data=subset(amrp,voice=='Active'),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)


#Passive

full<-glm(data=subset(amrp,voice=='Passive'&year>=1900),isRecFirst~year*Verb,family=binomial)
noint<-glm(data=subset(amrp,voice=='Passive'&year>=1900),isRecFirst~year+Verb,family=binomial)
noyear<-glm(data=subset(amrp,voice=='Passive'&year>=1900),isRecFirst~Verb,family=binomial)
null<-glm(data=subset(amrp,voice=='Passive'&year>=1900),isRecFirst~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)


am.ord<-group_by(amrp,eras,voice,Verb)%>%summarise(val=mean(isRecFirst),num=sum(!is.na(isRecFirst)))

ggplot(amrp,aes(year,isRecFirst,linetype=Verb,colour=voice))+
  stat_smooth(method='loess',se=F)+
  geom_point(data=am.ord,aes(eras,val,size=log(num),shape=Verb))+
  scale_x_continuous(name='Year of Composition',breaks=seq(1800,2010,10))+
  scale_y_continuous(name='% Recipient--Theme Orders',breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  coord_cartesian(ylim=c(-0.01,1.01))+
  scale_size_continuous(name='Number of Tokens (log)')+
  scale_colour_discrete(name='Voice')+ 
  scale_shape_discrete(name='Verb',labels=c('GIVE','OFFER'))+
  scale_linetype_discrete(name='Verb',labels=c('GIVE','OFFER'))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),text = element_text(size=20))


rptoset<-as.data.frame(rbind(subset(joint,IO=='Recipient Pronoun'&isRecFirst==0&((DO=='Theme Pronoun')|(voice=='Passive'))),subset(tojoint,IO=='Recipient Pronoun')))

rptoset$eras<-as.numeric(as.character(cut(rptoset$year,
                                          breaks=c(seq(1300,2020,20)),
                                          labels=c(seq(1310,2010,20)))))


rptoset$isTo<-factor(rptoset$cond)
levels(rptoset$isTo)<-c(1,0)
rptoset$isTo<-as.numeric(as.character(rptoset$isTo))

rptoset$NVerb<-factor(rptoset$Verb)
levels(rptoset$NVerb)<-c('American','American','British')

#British
full<-glm(data=subset(rptoset,Verb=='British'&year>=1400),isTo~year*voice,family=binomial)
noint<-glm(data=subset(rptoset,Verb=='British'&year>=1400),isTo~year+voice,family=binomial)
noyear<-glm(data=subset(rptoset,Verb=='British'&year>=1400),isTo~voice,family=binomial)
null<-glm(data=subset(rptoset,Verb=='British'&year>=1400),isTo~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)


ns.to<-group_by(rptoset,eras,voice,NVerb)%>%summarise(val=mean(isTo,na.rm=T),num=sum(!is.na(isTo)))


ggplot(rptoset,aes(year,isTo,linetype=NVerb,colour=voice))+
  stat_smooth(method='loess',se=F)+
  geom_point(data=ns.to,aes(eras,val,size=log(num),shape=NVerb))+
  scale_x_continuous(breaks=seq(1300,2000,100))+
  scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  coord_cartesian(ylim=c(-0.01,1.01))+
  scale_size_continuous(name='Number of Tokens (log)')+
  scale_colour_discrete(name='Voice')+ 
  scale_shape_discrete(name='Variety of English')+
  scale_linetype_discrete(name='Variety of English')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),text = element_text(size=20))

amrpto<-subset(rptoset,NVerb=='American')

#Passive (pre-1950)
full<-glm(data=subset(amrpto,voice=='Passive'&year<=1930),isTo~year*Verb,family=binomial)
noint<-glm(data=subset(amrpto,voice=='Passive'&year<=1930),isTo~year+Verb,family=binomial)
noyear<-glm(data=subset(amrpto,voice=='Passive'&year<=1930),isTo~Verb,family=binomial)
null<-glm(data=subset(amrpto,voice=='Passive'&year<=1930),isTo~1,family=binomial)

anova(null,noyear,noint,full,test='Chisq')
AIC(null,noyear,noint,full)

#Passive (after-1950)
full<-glm(data=subset(amrpto,voice=='Passive'&year>=1930),isTo~year*Verb,family=binomial)
noint<-glm(data=subset(amrpto,voice=='Passive'&year>=1930),isTo~year+Verb,family=binomial)
noverb<-glm(data=subset(amrpto,voice=='Passive'&year>=1930),isTo~year,family=binomial)
null<-glm(data=subset(amrpto,voice=='Passive'&year>=1930),isTo~1,family=binomial)

anova(null,noverb,noint,full,test='Chisq')
AIC(null,noverb,noint,full)

am.to<-group_by(amrpto,eras,voice,Verb)%>%summarise(val=mean(isTo,na.rm=T),num=sum(!is.na(isTo)))

ggplot(amrpto,aes(year,isTo,linetype=Verb,colour=voice))+
  stat_smooth(method='loess',se=F)+
  geom_point(data=am.to,aes(eras,val,size=log(num),shape=Verb))+
  scale_x_continuous(name='Year of Composition',breaks=seq(1300,2000,100))+
  scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  coord_cartesian(ylim=c(-0.01,1.01))+
  scale_size_continuous(name='Number of Tokens (log)')+
  scale_colour_discrete(name='Voice')+ 
  scale_shape_discrete(name='Verb',labels=c('GIVE','OFFER'))+
  scale_linetype_discrete(name='Verb',labels=c('GIVE','OFFER'))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),text = element_text(size=20))


















#############3


njoint$isAm<-factor(njoint$Verb)
levels(njoint$isAm)<-c(1,1,0)
njoint$isAm<-as.numeric(as.character(njoint$isAm))

njoint$isOffer<-factor(njoint$Verb)
levels(njoint$isOffer)<-c(0,1,0)
njoint$isOffer<-as.numeric(as.character(njoint$isOffer))

nn.act<-subset(njoint,voice=='Active'&IO=='Recipient Noun'&DO=='Theme Noun')
full<-glm(data=nn.act,isRecFirst~year*(isAm+isOffer),family='binomial')
nooffint<-glm(data=nn.act,isRecFirst~year*isAm+isOffer,family='binomial')
noint<-glm(data=nn.act,isRecFirst~year+isAm+isOffer,family='binomial')
nooff<-glm(data=nn.act,isRecFirst~year+isAm,family='binomial')
noam<-glm(data=nn.act,isRecFirst~year,family='binomial')
null<-glm(data=nn.act,isRecFirst~1,family='binomial')

anova(null,noam,nooff,noint,nooffint,full,test='Chisq')
AIC(null,noam,nooff,noint,nooffint,full)
BIC(null,noam,nooff,noint,nooffint,full)

np.pas<-subset(njoint,voice=='Passive'&IO=='Recipient Pronoun'&DO=='Theme Noun')
ggplot(np.pas,aes(year,isRecFirst,colour=Verb))+stat_smooth(method='loess')+ylim(0,1)

full<-glm(data=np.pas,isRecFirst~year*(isAm+isOffer),family='binomial')
noamint<-glm(data=np.pas,isRecFirst~year*isOffer+isAm,family='binomial')
noint<-glm(data=np.pas,isRecFirst~year+isAm+isOffer,family='binomial')
noam<-glm(data=np.pas,isRecFirst~year+isOffer,family='binomial')
nooff<-glm(data=np.pas,isRecFirst~year,family='binomial')
null<-glm(data=np.pas,isRecFirst~1,family='binomial')

anova(null,nooff,noam,noint,noamint,full,test='Chisq')
AIC(null,nooff,noam,noint,noamint,full)
BIC(null,nooff,noam,noint,noamint,full)


full<-glm(data=np.pas,isRecFirst~year*(isAm+isOffer),family='binomial')
nooffint<-glm(data=np.pas,isRecFirst~year*isAm+isOffer,family='binomial')
noint<-glm(data=np.pas,isRecFirst~year+isAm+isOffer,family='binomial')
nooff<-glm(data=np.pas,isRecFirst~year+isAm,family='binomial')
noam<-glm(data=np.pas,isRecFirst~year,family='binomial')
null<-glm(data=np.pas,isRecFirst~1,family='binomial')

anova(null,noam,nooff,noint,nooffint,full,test='Chisq')
AIC(null,noam,nooff,noint,nooffint,full)
BIC(null,noam,nooff,noint,nooffint,full)

am.pas<-subset(np.pas,Verb!='British'&year>=1900)
full<-glm(data=am.pas,isRecFirst~year*Verb,family='binomial')
noint<-glm(data=am.pas,isRecFirst~year+Verb,family='binomial')
noverb<-glm(data=am.pas,isRecFirst~year,family='binomial')
null<-glm(data=am.pas,isRecFirst~1,family='binomial')

anova(null,noverb,noint,full,test='Chisq')
AIC(null,noverb,noint,full)
BIC(null,noverb,noint,full)



nn.pas<-subset(njoint,voice=='Passive'&IO=='Recipient Noun'&DO=='Theme Noun')

ggplot(nn.pas,aes(year,isRecFirst,colour=Verb))+stat_smooth(method='loess')

full<-glm(data=nn.pas,isRecFirst~year*(isAm+isOffer),family='binomial')
nooffint<-glm(data=nn.pas,isRecFirst~year*isAm+isOffer,family='binomial')
noint<-glm(data=nn.pas,isRecFirst~year+isAm+isOffer,family='binomial')
nooff<-glm(data=nn.pas,isRecFirst~year+isAm,family='binomial')
noam<-glm(data=nn.pas,isRecFirst~year,family='binomial')
null<-glm(data=nn.pas,isRecFirst~1,family='binomial')

anova(null,noam,nooff,noint,nooffint,full,test='Chisq')
AIC(null,noam,nooff,noint,nooffint,full)
BIC(null,noam,nooff,noint,nooffint,full)

am.pas<-subset(nn.pas,Verb!='British'&year<=1940&year>=1850)
full<-glm(data=am.pas,isRecFirst~year*Verb,family='binomial')
noint<-glm(data=am.pas,isRecFirst~year+Verb,family='binomial')
noverb<-glm(data=am.pas,isRecFirst~year,family='binomial')
null<-glm(data=am.pas,isRecFirst~1,family='binomial')

anova(null,noverb,noint,full,test='Chisq')
AIC(null,noverb,noint,full)
BIC(null,noverb,noint,full)



nn.pas$x<-(nn.pas$year-mean(nn.pas$year))/(2*sd(nn.pas$year))

nn.pas.g<-subset(nn.pas,Verb=='give')
nn.pas.o<-subset(nn.pas,Verb=='offer')
nn.pas.b<-subset(nn.pas,Verb=='Brit')

xPas.give<-nn.pas.g$x
xPas.offer<-nn.pas.o$x
xPas.brit<-nn.pas.b$x

yPas.give<-nn.pas.g$isRecFirst
yPas.offer<-nn.pas.o$isRecFirst
yPas.brit<-nn.pas.b$isRecFirst


prob_ll<-function(ag=0,bg=0,hg=.75,ao=0,bo=0,ho=.75,ab=0,bb=0,hb=.75){
  pPas.g<-(hg/(1+exp(-((ag+bg*xPas.give)))))
  pPas.o<-(ho/(1+exp(-((ao+bo*xPas.offer)))))
  pPas.b<-(hb/(1+exp(-((ab+bb*xPas.brit)))))
  sumPas.g=-sum(stats::dbinom(yPas.give, 1, pPas.g,log=TRUE),na.rm=T)
  sumPas.o=-sum(stats::dbinom(yPas.offer, 1, pPas.o,log=TRUE),na.rm=T)
  sumPas.b=-sum(stats::dbinom(yPas.brit, 1, pPas.b,log=TRUE),na.rm=T)
  results<-sum(sumPas.g,sumPas.o,sumPas.b)
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

full_fit<-mle2(prob_ll,start=list(ag=0,bg=0,ao=0,bo=0,ab=0,bb=0))

cff<-coef(full_fit)

pred.g<-data.frame(year=seq(1800,2000,1),verb='give')
pred.g$x<-(pred.g$year-mean(nn.pas$year))/(2*sd(nn.pas$year))
pred.g$y<-.75/(1+exp(-(cff[1]+cff[2]*pred.g$x)))

pred.o<-data.frame(year=seq(1800,2000,1),verb='offer')
pred.o$x<-(pred.o$year-mean(nn.pas$year))/(2*sd(nn.pas$year))
pred.o$y<-.75/(1+exp(-(cff[3]+cff[4]*pred.o$x)))

pred<-as.data.frame(rbind(pred.g,pred.o))
pred$verb<-factor(pred$verb)

ggplot(pred,aes(year,y,colour=verb,linetype='reduced'))+geom_line()+stat_smooth(method='glm',family='binomial',data=nn.pas,aes(year,isRecFirst,colour=Verb,linetype='full'))



full<-glm(data=indepth,isDOC~(IOAnim+IONum+DONum+logdif+IODef*DODef)+period+
            period:IOAnim+period:IONum+period:DONum+
            period:logdif+period:IODef+period:DODef+
            period:IODef:DODef,family='binomial')
nonum<-glm(data=indepth,isDOC~(IOAnim+logdif+IODef*DODef)+period+
            period:IOAnim+
            period:logdif+period:IODef+period:DODef+
            period:IODef:DODef,family='binomial')
nodefint<-glm(data=indepth,isDOC~(IOAnim+logdif+IODef+DODef)+period+
             period:IOAnim+
             period:logdif+period:IODef+period:DODef,family='binomial')
noanimint<-glm(data=indepth,isDOC~(IOAnim+logdif+IODef+DODef)+period+
                period:logdif+period:IODef+period:DODef,family='binomial')
nolenint<-glm(data=indepth,isDOC~(IOAnim+logdif+IODef+DODef)+period+
                period:IODef+period:DODef,family='binomial')
noioint<-glm(data=indepth,isDOC~(IOAnim+logdif+IODef+DODef)+period+
                period:DODef,family='binomial')
nodefyear<-glm(data=indepth,isDOC~(IOAnim+logdif+IODef+DODef)+period,family='binomial')
noanim<-glm(data=indepth,isDOC~(logdif+IODef+DODef)+period,family='binomial')
nododef<-glm(data=indepth,isDOC~(logdif+IODef)+period,family='binomial')
noyear<-glm(data=indepth,isDOC~(logdif+IODef),family='binomial')
nodef<-glm(data=indepth,isDOC~(logdif),family='binomial')
null<-glm(data=indepth,isDOC~1,family='binomial')

anova(null,nodef,noyear,nododef,noanim,nodefyear,noioint,nolenint,noanimint,nodefint,nonum,full,test='Chisq')
AIC(null,nodef,noyear,nododef,noanim,nodefyear,noioint,nolenint,noanimint,nodefint,nonum,full)


group_by(indepth,period)%>%summarise(ld=mean(logdif))

toset<-subset(njoint,cond %in% c('gave it to him/it was given to him','gave it him/it was given him'))

toset$isTo<-factor(toset$cond)
levels(toset$isTo)<-c(1,0)
toset$isTo<-as.numeric(as.character(toset$isTo))

ggplot(toset,aes(eras,isTo,colour=Verb,linetype=voice))+
  stat_summary(fun.y=mean,geom='line')+
  facet_grid(IO~DO)+ylim(0,1)
