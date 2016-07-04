# Load the data
dit <- read.delim2('../Parsed Corpora/data/dit.txt')  
dit$YoC<-as.numeric(as.character(dit$YoC))
levels(dit$Clause)[2]<-'ABS' # Failed to correctly identify absolute clauses

# Convert Genre into Formal/Informal
dit$NGenre<-dit$Genre
levels(dit$NGenre)[levels(dit$NGenre)=='autobiography']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='biography']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='canon_law']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='charters_wills']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='comedy']<-"INFORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='diary']<-"INFORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='education']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='fiction']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='handbook']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='history']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='homily']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='medicine']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='philosophy']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='private_letter']<-"INFORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='public_letter']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='religion']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='religious_rule']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='science']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='sermon']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='statute']<-"WEIRD"
levels(dit$NGenre)[levels(dit$NGenre)=='travelogue']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='trial']<-"INFORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='wycliffe_tyndale_bible']<-"FORMAL"
levels(dit$NGenre)[levels(dit$NGenre)=='elizabeth_boethius']<-"WEIRD"
levels(dit$NGenre)[levels(dit$NGenre)=='king_james_bible']<-"WEIRD"

##Simplify Argument labels
dit$NDat<-dit$Dat

levels(dit$NDat)[levels(dit$NDat)=='DatDefinite']=c('DatNoun')
levels(dit$NDat)[levels(dit$NDat)=='DatIndefinite']=c('DatNoun')
levels(dit$NDat)[levels(dit$NDat)=='DatName']=c('DatNoun')
levels(dit$NDat)[levels(dit$NDat)=='DatConj']=c('DatNoun')
levels(dit$NDat)[levels(dit$NDat)=='DatNull']=c('DatNull')
levels(dit$NDat)[levels(dit$NDat)=='DatDPronoun']=c('DatNoun')
levels(dit$NDat)[levels(dit$NDat)=='DatWHEmpty']=c('DatEmpty')
levels(dit$NDat)[levels(dit$NDat)=='DatWHIndefinite']=c('DatNoun')
levels(dit$NDat)[levels(dit$NDat)=='DatWHPronoun']=c('DatPronoun')
levels(dit$NDat)[levels(dit$NDat)=='DatWPIndefinite']=c('DatNoun')
levels(dit$NDat)[levels(dit$NDat)=='DatWPPronoun']=c('DatPronoun')

dit$DatWH<-dit$Dat

levels(dit$DatWH)[levels(dit$DatWH)=='DatDefinite']=c('DatNotWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatIndefinite']=c('DatNotWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatName']=c('DatNotWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatConj']=c('DatNotWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatNull']=c('DatNotWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatDPronoun']=c('DatNotWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatEmpty']=c('DatNotWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatPronoun']=c('DatNotWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatWHEmpty']=c('DatWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatWHIndefinite']=c('DatWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatWHPronoun']=c('DatWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatWPIndefinite']=c('DatWH')
levels(dit$DatWH)[levels(dit$DatWH)=='DatWPPronoun']=c('DatWH')


dit$NAcc<-dit$Acc

levels(dit$NAcc)[levels(dit$NAcc)=='AccDefinite']=c('AccNoun')
levels(dit$NAcc)[levels(dit$NAcc)=='AccIndefinite']=c('AccNoun')
levels(dit$NAcc)[levels(dit$NAcc)=='AccName']=c('AccNoun')
levels(dit$NAcc)[levels(dit$NAcc)=='AccConj']=c('AccNoun')
levels(dit$NAcc)[levels(dit$NAcc)=='AccNull']=c('AccNull')
levels(dit$NAcc)[levels(dit$NAcc)=='AccDPronoun']=c('AccNoun')
levels(dit$NAcc)[levels(dit$NAcc)=='AccPronoun']=c('AccPronoun')
levels(dit$NAcc)[levels(dit$NAcc)=='AccEmpty']=c('AccEmpty')
levels(dit$NAcc)[levels(dit$NAcc)=='AccCP']=c('AccCP')
levels(dit$NAcc)[levels(dit$NAcc)=='AccWHEmpty']=c('AccEmpty')
levels(dit$NAcc)[levels(dit$NAcc)=='AccWHIndefinite']=c('AccNoun')
levels(dit$NAcc)[levels(dit$NAcc)=='AccWHPronoun']=c('AccPronoun')

dit$AccWH<-dit$Acc

levels(dit$AccWH)[levels(dit$AccWH)=='AccDefinite']=c('AccNotWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccIndefinite']=c('AccNotWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccName']=c('AccNotWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccConj']=c('AccNotWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccNull']=c('AccNotWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccDPronoun']=c('AccNotWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccPronoun']=c('AccNotWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccEmpty']=c('AccNotWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccCP']=c('AccNotWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccWHEmpty']=c('AccWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccWHIndefinite']=c('AccWH')
levels(dit$AccWH)[levels(dit$AccWH)=='AccWHPronoun']=c('AccWH')

dit$NNom<-dit$Nom

levels(dit$NNom)[levels(dit$NNom)=='NomDefinite']=c('NomNoun')
levels(dit$NNom)[levels(dit$NNom)=='NomIndefinite']=c('NomNoun')
levels(dit$NNom)[levels(dit$NNom)=='NomConj']=c('NomNoun')
levels(dit$NNom)[levels(dit$NNom)=='NomName']=c('NomNoun')
levels(dit$NNom)[levels(dit$NNom)=='NomNull']=c('NomNull')
levels(dit$NNom)[levels(dit$NNom)=='NomEmpty']=c('NomEmpty')
levels(dit$NNom)[levels(dit$NNom)=='NomDPronoun']=c('NomPronoun')
levels(dit$NNom)[levels(dit$NNom)=='NomWHEmpty']=c('NomEmpty')
levels(dit$NNom)[levels(dit$NNom)=='NomWHIndefinite']=c('NomNoun')
levels(dit$NNom)[levels(dit$NNom)=='NomWHPronoun']=c('NomPronoun')

dit$NomWH<-dit$Nom

levels(dit$NomWH)[levels(dit$NomWH)=='NomDefinite']=c('NomNotWH')
levels(dit$NomWH)[levels(dit$NomWH)=='NomIndefinite']=c('NomNotWH')
levels(dit$NomWH)[levels(dit$NomWH)=='NomConj']=c('NomNotWH')
levels(dit$NomWH)[levels(dit$NomWH)=='NomName']=c('NomNotWH')
levels(dit$NomWH)[levels(dit$NomWH)=='NomNull']=c('NomNotWH')
levels(dit$NomWH)[levels(dit$NomWH)=='NomEmpty']=c('NomNotWH')
levels(dit$NomWH)[levels(dit$NomWH)=='NomDPronoun']=c('NomNotWH')
levels(dit$NomWH)[levels(dit$NomWH)=='NomWHEmpty']=c('NomWH')
levels(dit$NomWH)[levels(dit$NomWH)=='NomWHIndefinite']=c('NomWH')
levels(dit$NomWH)[levels(dit$NomWH)=='NomWHPronoun']=c('NomWH')

## Categorize Verbs
dit$NVerb<-dit$Verb

levels(dit$NVerb)[levels(dit$NVerb)=='ALLOT']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='APPOINT']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='ASSIGN']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='AYEVEN']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='BEHIEGHT']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='BEQUEATH']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='BETAKE']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='CARRY']<-c('SEND')
levels(dit$NVerb)[levels(dit$NVerb)=='DELIVER']<-c('SEND')
levels(dit$NVerb)[levels(dit$NVerb)=='FEED']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='GIVE']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='GRANT']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='LEND']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='OFFER']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='OWE']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='PAY']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='PROFFER']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='PROMISE']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='RESTORE']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='RETURN']<-c('SEND')
levels(dit$NVerb)[levels(dit$NVerb)=='SELL']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='SEND']<-c('SEND')
levels(dit$NVerb)[levels(dit$NVerb)=='SERVE']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='SHOW']<-c('GIVE')
levels(dit$NVerb)[levels(dit$NVerb)=='VOUCHSAFE']<-c('PROMISE')
levels(dit$NVerb)[levels(dit$NVerb)=='YIELD']<-c('GIVE')

# Identify whether the recipient is adjacent to the verb
dit$NAdj<-factor(dit$Adj)
levels(dit$NAdj)<-c(levels(dit$NAdj),'ProIntervene','NounIntervene')

dit$NAdj[dit$NAcc=='AccPronoun'&dit$NAdj=='DOIntervene']<-'ProIntervene'
dit$NAdj[dit$NAdj=='DOIntervene']<-'NounIntervene'

dit$NAdj[dit$NAcc=='AccPronoun'&dit$NAdj=='PreverbDOIntervene']<-'ProIntervene'
dit$NAdj[dit$NAdj=='PreverbDOIntervene']<-'NounIntervene'

dit$NAdj[dit$NNom=='NomPronoun'&dit$NAdj=='NomIntervene']<-'ProIntervene'
dit$NAdj[dit$NAdj=='NomIntervene']<-'NounIntervene'

dit$NAdj[dit$NNom=='NomPronoun'&dit$NAdj=='PreverbNomIntervene']<-'ProIntervene'
dit$NAdj[dit$NAdj=='PreverbNomIntervene']<-'NounIntervene'

dit$NAdj<-factor(dit$NAdj)

levels(dit$NAdj)[levels(dit$NAdj)=='Adjacent']='Adjacent'
levels(dit$NAdj)[levels(dit$NAdj)=='NegIntervene']='OtherInterveners'
levels(dit$NAdj)[levels(dit$NAdj)=='OtherInterveners']='OtherInterveners'
levels(dit$NAdj)[levels(dit$NAdj)=='PreverbAdjacent']='Adjacent'
levels(dit$NAdj)[levels(dit$NAdj)=='PreverbAdvIntervene']='OtherInterveners'
levels(dit$NAdj)[levels(dit$NAdj)=='PreverbFiniteIntervene']='OtherInterveners'
levels(dit$NAdj)[levels(dit$NAdj)=='PreverbNegIntervene']='OtherInterveners'
levels(dit$NAdj)[levels(dit$NAdj)=='ProIntervene']='ProIntervene'
levels(dit$NAdj)[levels(dit$NAdj)=='NounIntervene']='NounIntervene'

# Create response variable for presence/absence of 'to'
dit$isTo<-factor(dit$PP)
levels(dit$isTo)<-c(0,NA,1,1)
dit$isTo<-as.numeric(as.character(dit$isTo))

## Examine rates of monotransitivity
notweird<-subset(dit,NGenre!='POETRY'&NGenre!='WEIRD'&NGenre!='TRANSLATION')
monotrans<-data.frame(Verb=notweird$Verb[notweird$Pas=='ACT'],
		      year=notweird$YoC[notweird$Pas=='ACT'],
		      genre=notweird$Genre[notweird$Pas=='ACT'],
		      ThemeMono=(notweird$NDat[notweird$Pas=='ACT']=='DatNull'),
		      RecipientMono=(notweird$NAcc[notweird$Pas=='ACT']=='AccNull'),
		      RecMonoThemeCP=(notweird$NAcc[notweird$Pas=='ACT']=='AccCP'))

save(monotrans,file='../Rdata/monotrans.RData')

## Deal with differences between active and passive clauses (and eliminate cases from atypical text and non-ditransitive clauses)
# Active clauses first
adit<-subset(notweird,NDat!='DatNull'&NDat!='DatEmpty'&NAcc!='AccNull'&NAcc!='AccCP'&Pas=='ACT')

# Rename output variables
adit$IO<-factor(adit$NDat)
adit$IOSize <- adit$DatSize
adit$IOCP <- adit$DatCP
adit$DO<-factor(adit$NAcc)
adit$DOSize <- adit$AccSize
adit$DOCP <- adit$AccCP

# Describe clause type
adit$Envir<-factor(paste(adit$DatVerb,adit$AccVerb,adit$DatAcc))

levels(adit$Envir)[levels(adit$Envir)=="DatV AccV AccDat"]="Active Theme--Recipient Verb"
levels(adit$Envir)[levels(adit$Envir)=="DatV AccV DatAcc"]="Active Recipient--Theme Verb"
levels(adit$Envir)[levels(adit$Envir)=="DatV NA NA"]=NA
levels(adit$Envir)[levels(adit$Envir)=="DatV VAcc AccDat"]=NA
levels(adit$Envir)[levels(adit$Envir)=="DatV VAcc DatAcc"]="Active Recipient Topicalisation"
levels(adit$Envir)[levels(adit$Envir)=="NA AccV NA"]=NA
levels(adit$Envir)[levels(adit$Envir)=="NA VAcc NA"]=NA
levels(adit$Envir)[levels(adit$Envir)=="NA NA AccDat"]=NA
levels(adit$Envir)[levels(adit$Envir)=="NA NA DatAcc"]=NA
levels(adit$Envir)[levels(adit$Envir)=="NA NA NA"]=NA
levels(adit$Envir)[levels(adit$Envir)=="VDat AccV AccDat"]="Active Theme Topicalisation"
levels(adit$Envir)[levels(adit$Envir)=="VDat NA NA"]=NA
levels(adit$Envir)[levels(adit$Envir)=="VDat VAcc AccDat"]="Active Verb Theme--Recipient"
levels(adit$Envir)[levels(adit$Envir)=="VDat VAcc DatAcc"]="Active Verb Recipient--Theme"
levels(adit$Envir)[levels(adit$Envir)=="VDat VAcc NA"]=NA

# Deal with OldEng related peculiarities w.r.t. passivisation (namely oblique subjects)
oedit<-subset(dit,YoC<=1100&NGenre!='POETRY'&NGenre!='WEIRD'&NGenre!='TRANSLATION'&Pas=='PAS')
oedit$IO<-factor(oedit$NDat)
oedit$IOSize<-oedit$DatSize
oedit$IOCP<-oedit$DatCP
oedit$DO<-factor(oedit$NNom)
oedit$DOSize<-oedit$NomSize
oedit$DOCP<-oedit$NomCP
oedit$Envir<-factor(paste(oedit$DatVerb,oedit$NomVerb,oedit$NomDat))
levels(oedit$Envir)[levels(oedit$Envir)=="DatV NA NA"]=NA
levels(oedit$Envir)[levels(oedit$Envir)=="DatV NomV DatNom"]="Theme Passive Recipient Topicalisation"
levels(oedit$Envir)[levels(oedit$Envir)=="DatV NomV NA"]="Theme Passive Recipient Topicalisation"
levels(oedit$Envir)[levels(oedit$Envir)=="VDat NomV NA"]="Theme Passive Theme Verb Recipient"
levels(oedit$Envir)[levels(oedit$Envir)=="DatV NomV NomDat"]="Recipient Passive Theme Topicalisation"
levels(oedit$Envir)[levels(oedit$Envir)=="DatV VNom DatNom"]="Recipient Passive Recipient Verb Theme"
levels(oedit$Envir)[levels(oedit$Envir)=="DatV VNom NomDat"]=NA
levels(oedit$Envir)[levels(oedit$Envir)=="NA NA NA"]=NA
levels(oedit$Envir)[levels(oedit$Envir)=="NA NomV NA"]=NA
levels(oedit$Envir)[levels(oedit$Envir)=="NA VNom NA"]=NA
levels(oedit$Envir)[levels(oedit$Envir)=="VDat NA NA"]=NA
levels(oedit$Envir)[levels(oedit$Envir)=="VDat NomV NomDat"]="Theme Passive Theme Verb Recipient"
levels(oedit$Envir)[levels(oedit$Envir)=="VDat VNom DatNom"]="Recipient Passive Verb Recipient--Theme"
levels(oedit$Envir)[levels(oedit$Envir)=="VDat VNom NomDat"]="Theme Passive Verb Theme--Recipient"
levels(oedit$Envir)[levels(oedit$Envir)=="NA NA NomDat"]=NA


# Deal with passive examples 
thedit<-subset(dit,YoC>1100&NGenre!='POETRY'&NGenre!='WEIRD'&NGenre!='TRANSLATION'&NDat!='DatNull'&NDat!='DatEmpty'&NAcc=='AccNull'&NNom!='NomNull'&Pas=='PAS')
thedit$IO<-factor(thedit$NDat)
thedit$IOSize<-thedit$DatSize
thedit$IOCP<-thedit$DatCP
thedit$DO<-factor(thedit$NNom)
thedit$DOSize<-thedit$NomSize
thedit$DOCP<-thedit$NomCP
thedit$Envir<-factor(paste(thedit$DatVerb,thedit$NomVerb,thedit$NomDat))
levels(thedit$Envir)[levels(thedit$Envir)=="DatV NA NA"]=NA
levels(thedit$Envir)[levels(thedit$Envir)=="DatV NomV DatNom"]="Theme Passive Recipient Topicalisation"
levels(thedit$Envir)[levels(thedit$Envir)=="DatV NomV NA"]="Theme Passive Recipient Topicalisation"
levels(thedit$Envir)[levels(thedit$Envir)=="DatV NomV NomDat"]="Recipient Passive Theme Topicalisation"
levels(thedit$Envir)[levels(thedit$Envir)=="DatV VNom DatNom"]="Recipient Passive Recipient Verb Theme"
levels(thedit$Envir)[levels(thedit$Envir)=="DatV VNom NomDat"]=NA
levels(thedit$Envir)[levels(thedit$Envir)=="NA NA NA"]=NA
levels(thedit$Envir)[levels(thedit$Envir)=="NA NomV NA"]=NA
levels(thedit$Envir)[levels(thedit$Envir)=="NA VNom NA"]=NA
levels(thedit$Envir)[levels(thedit$Envir)=="VDat NA NA"]=NA
levels(thedit$Envir)[levels(thedit$Envir)=="VDat NomV NomDat"]="Theme Passive Theme Verb Recipient"
levels(thedit$Envir)[levels(thedit$Envir)=="VDat VNom DatNom"]="Recipient Passive Verb Recipient--Theme"
levels(thedit$Envir)[levels(thedit$Envir)=="VDat VNom NomDat"]="Theme Passive Verb Theme--Recipient"
thedit$Envir<-as.character(thedit$Envir)
thedit$Envir[thedit$Envir=='Recipient Passive Recipient Verb Theme'&thedit$isTo==1]<-'Locative Inversion'
thedit$Envir<-factor(thedit$Envir)

recdit<-subset(dit,YoC>1100&NGenre!='POETRY'&NGenre!='WEIRD'&NGenre!='TRANSLATION'&NDat=='DatNull'&NAcc!='AccCP'&NAcc!='AccNull'&NNom!='NomNull'&Pas=='PAS')
recdit$IO<-factor(recdit$NNom)
recdit$IOSize<-recdit$NomSize
recdit$IOCP<-recdit$NomCP
recdit$DO<-factor(recdit$NAcc)
recdit$DOSize<-recdit$AccSize
recdit$DOCP<-recdit$AccCP
recdit$Envir<-factor(paste(recdit$NomVerb,recdit$AccVerb,recdit$NomAcc))
levels(recdit$Envir)[levels(recdit$Envir)=="NA VAcc NA"]=NA
levels(recdit$Envir)[levels(recdit$Envir)=="NomV AccV AccNom"]='Recipient Passive Theme Topicalisation'
levels(recdit$Envir)[levels(recdit$Envir)=="NomV NA NA"]=NA
levels(recdit$Envir)[levels(recdit$Envir)=="NA NA NA"]=NA
levels(recdit$Envir)[levels(recdit$Envir)=="NomV VAcc NomAcc"]="Recipient Passive Recipient Verb Theme"
levels(recdit$Envir)[levels(recdit$Envir)=="NomV VAcc NA"]="Recipient Passive Recipient Verb Theme"
levels(recdit$Envir)[levels(recdit$Envir)=="VNom VAcc NomAcc"]="Recipient Passive Verb Recipient--Theme"

# Recombine data

ndit<-as.data.frame(rbind(adit,oedit,thedit,recdit))

# Relabel data for ease of use
gdit<-ndit

# Create word order response variable
gdit$isDatAcc<-factor(gdit$Envir)

levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=='Active Theme--Recipient Verb']<-0
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Active Recipient--Theme Verb"]<-1
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Active Recipient Topicalisation"]<-NA        
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Active Theme Topicalisation"]<-NA
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Active Verb Theme--Recipient"]<-0
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Active Verb Recipient--Theme"]<-1       
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Theme Passive Recipient Topicalisation"]<-NA
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Theme Passive Theme Verb Recipient"]<-0
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Theme Passive Verb Recipient--Theme"]<-1
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Theme Passive Verb Theme--Recipient"]<-0
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Recipient Passive Theme Topicalisation"]<-NA
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Recipient Passive Recipient Verb Theme"]<-1
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Recipient Passive Verb Recipient--Theme"]<-1
levels(gdit$isDatAcc)[levels(gdit$isDatAcc)=="Locative Inversion"]<-NA

gdit$isDatAcc<-as.numeric(as.character(gdit$isDatAcc))

# Relabel IO and DO variables
gdit$NIO<-factor(gdit$IO)
levels(gdit$NIO)<-c('Recipient Noun','Recipient Pronoun','Recipient Empty','Recipient Null','Recipient Noun', 'Recipient Pronoun', 'Recipient Empty')

gdit$NDO<-factor(gdit$DO)
levels(gdit$NDO)<-c('Theme Noun','Theme Empty','Theme Pronoun','Theme Noun','Theme Pronoun','Theme Empty','Theme Null')

# Create bins for graphing
gdit$YoC<-as.numeric(as.character(gdit$YoC))
gdit$eras<-as.numeric(as.character(cut(gdit$YoC,breaks=seq(750,1950,100),labels=seq(800,1900,100))))

# Finish eliminating problem cases
gdit<-subset(gdit,NIO!='Recipient Null'&NDO!='Theme Null'&NDO!='Theme Empty'&NIO!='Recipient Empty')

#Load American data
data <- read.csv('../COHA Data/give_act_coded_final.txt',sep='\t',quote="")
oadata <- read.csv('../COHA Data/offer_act_coded_final.txt',sep='\t',quote="")
opdata <- read.csv('../COHA Data/offer_pas_coded_final.txt',sep='\t',quote="")

# Code for source
oadata$Verb<-'offer'
opdata$Verb<-'offer'
data$Verb<-'give'

# Add information about idomaticity to offer
oadata$isIdiom<-0
opdata$isIdiom<-0

# Indicate that the give data is all active
data$Voice<-'Active'

# Combine data 
rdata<-as.data.frame(rbind(data,oadata,opdata))
rdata$Verb<-factor(rdata$Verb)

# Load give passive and active it data
data <- read.csv('../COHA Data/give_old_coded_final.txt',sep='\t', quote = "")

# Make variables match with previous material
rdata$old_id <- NA
data$isIdiom <- 0
data$Verb <- 'give'

am.joint<- as.data.frame(rbind(rdata,data))

# Rename conditions
am.joint$cond<-factor(paste(am.joint$To,am.joint$Order))
levels(am.joint$cond)<-c('NA','gave it him','gave him it','gave it to him','gave to him it')

# Save out the preped datasets
nbrit <- subset(gdit, !is.na(Envir))
nbrit$Envir <- factor(nbrit$Envir)


britdat <- data.frame(year=nbrit$YoC,
		      era=nbrit$eras,
		      isTo=nbrit$isTo,
		      IO=nbrit$NIO,
		      DO=nbrit$NDO,
		      Envir=nbrit$Envir,
		      isDatAcc=nbrit$isDatAcc,
		      IOSize=nbrit$IOSize,
		      DOSize=nbrit$DOSize,
		      IOCP=nbrit$IOCP,
		      DOCP=nbrit$DOCP,
		      Adj=nbrit$NAdj,
		      Verb=nbrit$Verb,
		      NVerb=nbrit$NVerb,
		      Genre=nbrit$NGenre,
		      Voice=nbrit$Pas)
save(britdat,file='../Rdata/britdat.RData')

amdat <- data.frame(genre=am.joint$genre,
		    year=am.joint$year,
		    IO=am.joint$IO,
		    DO=am.joint$DO,
		    To=am.joint$To,
		    Order=am.joint$Order,
		    Verb=am.joint$Verb,
		    Voice=am.joint$Voice,
		    cond=am.joint$cond)
save(amdat,file='../Rdata/amdat.RData')
