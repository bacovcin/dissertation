library(ggplot2)
library(dplyr)
library(splines)
library(MASS)
library(lme4)
library(nloptr)

# Prepare British data (for looking at impact of NP weight)
load('../Rdata/britdat.RData')
britdat$era2 <- cut(britdat$year,breaks=c(700,1100,1450,1750,2000),labels=c('Old English','Middle English','Early Modern English','Late Modern English'))
real <- subset(britdat, NVerb!='SEND'&!is.na(isTo))
real$IOSize[real$isTo==1] <- real$IOSize[real$isTo==1] - 1
real$sizeratio<-log(real$IOSize)-log(real$DOSize)
real$sizequant<-cut(real$sizeratio,breaks=quantile(real$sizeratio,c(0,.33,.66,1)))

# Prepare American data (for combining with British data)
load('../Rdata/amdat.RData')
amdat$isDatAcc<-factor(amdat$Order)
levels(amdat$isDatAcc)<-c(0,1)
amdat$isDatAcc<-as.numeric(as.character(amdat$isDatAcc))

levels(amdat$IO)<-c('Recipient Noun','Recipient Pronoun')
levels(amdat$DO)<-c('Theme Noun','Theme Pronoun')
## Look at active changes
# Start with British English

# isTo modelling

fitUshape <- function(s1=rep(1,dim(xb1)[1]),s2=rep(1,dim(xb1)[1]), initb1=rep(0,dim(xb1)[2]), initb2=rep(0,dim(xb2)[2]), 
		      xb1, xb2, y, lltol = .1,
		      alg = 'NLOPT_LN_COBYLA',
		      printlevel = 0,
		      f_tol = 1e-8,
		      ll.only= F) {
	b1.nums <- 1:dim(xb1)[2]
	b2.nums <- (1+dim(xb1)[2]):(dim(xb1)[2]+dim(xb2)[2])
	ll.fun <- function(z) {
		b1 <- z[b1.nums]
		b2 <- z[b2.nums]
		p1 <- s1/(1+exp(-(as.matrix(xb1)%*%b1)))
		p2 <- 1-(s2)/(1+exp(-(as.matrix(xb2)%*%b2)))
		p <- p1*p2
		return(sum(-log(y*p+abs(y-1)*(1-p))))
	}
	stepwise.optim <- function(prevb1,prevb2,curopt='b1',prevll=Inf) {
		if (curopt == 'b1') {
			nextopt <- 'b2'
			fit <- nloptr(c(prevb1,prevb2),
				      eval_f=ll.fun,
				      opt=list(algorithm=alg,print_level=printlevel,ftol_rel=f_tol),
				      lb=c(rep(-Inf,length(prevb1)),prevb2),
				      ub=c(rep(Inf,length(prevb1)),prevb2))
		} else if (curopt == 'b2') {
			nextopt <- 'b1'
			fit <- nloptr(c(prevb1,prevb2),
				      eval_f=ll.fun,
				      opt=list(algorithm=alg,print_level=printlevel,ftol_rel=f_tol),
				      lb=c(prevb1,rep(-Inf,length(prevb2))),
				      ub=c(prevb1,rep(Inf,length(prevb2))))
		} else {
			stop('Impossible optimization choice')
		}
		ll <- fit$objective
		if ((abs(ll - prevll) < lltol) & curopt == 'b2') {
			r <- list()
			if (ll < prevll) {
				r$ll <- ll
				r$fit <- fit$sol
				return(r)
			} else {
				r$ll <- prevll
				r$fit <- c(prevb1,prevb2)
				return(r)
			}
		} else {
			return(stepwise.optim(fit$sol[b1.nums],
					      fit$sol[b2.nums],
					      nextopt,
					      ll))
		}
	}
	if (ll.only) {
		return(ll.fun(c(initb1,initb2)))
	} else {
		return(stepwise.optim(initb1,initb2))
	}
}

which.list.min <- function(x) {
	curmin = Inf
	curi = NA
	if (is.null(x)) { return(NA) }
	if (length(x) != 0) {
	for (i in 1:length(x)) {
		if (!is.null(x[[i]])){
		if (x[[i]] < curmin) {
			curmin <- x[[i]]
			curi <- i
		}
		}
	}
	return(curi)
	} else{
		return(NA)
	}
}

calcAIC <- function(mod) {
	return(2*length(mod$fit)+2*mod$ll)
}

stepUAIC <- function(s1=rep(1,length(y)), s2=rep(1,length(y)), fullbx, y,
		     xb1.cols = c(1), xb2.cols = c(1), curAIC, direction='forward', turns.since.change = 0) {

	turns.since.change <- turns.since.change + 1
	print(direction)
	print(turns.since.change)

	nx <- 1:dim(fullbx)[2]

	if (direction == 'forward') {
		newb1<-nx[!(nx %in% xb1.cols)]
		newb2<-nx[!(nx %in% xb2.cols)]
	} else if (direction == 'backward') {
		newb1<-nx[nx %in% xb1.cols]
		newb2<-nx[nx %in% xb2.cols]
		newb1<-newb1[newb1 != 1]
		newb2<-newb2[newb2 != 1]
	}

	xb1AIC <- list()
	xb2AIC <- list()

	if (length(newb1) > 0) {
	for (cl in newb1) {
		if (direction == 'forward') {
			curxb1 <- c(xb1.cols,cl)
		} else if (direction == 'backward') {
			curxb1 <- xb1.cols[xb1.cols != cl]
		}
		newmod <- fitUshape(s1, s2,
				    xb1=as.data.frame(fullbx[,curxb1]),
				    xb2=as.data.frame(fullbx[,xb2.cols]),
				    y=y)
		xb1AIC[[cl]] <- calcAIC(newmod)
	}
	bestb1<-which.list.min(xb1AIC)
	} else {
		bestb1 <- NA
	}

	if (length(newb2) > 0) {
	for (cl in newb2) {
		if (direction == 'forward') {
			curxb2 <- c(xb2.cols,cl)
		} else if (direction == 'backward') {
			curxb2 <- xb2.cols[xb2.cols != cl]
		}
		newmod <- fitUshape(s1, s2,
				    xb1=as.data.frame(fullbx[,xb1.cols]),
				    xb2=as.data.frame(fullbx[,curxb2]),
				    y=y)
		xb2AIC[[cl]] <- calcAIC(newmod)
	}
	bestb2<-which.list.min(xb2AIC)
	} else {
		bestb2 <- NA
	}

	bests <- list()
	bests[[1]] <- unlist(xb1AIC[bestb1])
	bests[[2]] <- unlist(xb2AIC[bestb2])
	b = which.list.min(bests)
	if (b == 1) {
		if (xb1AIC[[bestb1]] < curAIC) {
			if (direction == 'forward') {
				print('XB1 add')
				return(stepUAIC(s1, s2, fullbx, y, 
						c(xb1.cols,bestb1),
						xb2.cols,
						xb1AIC[[bestb1]], 
						direction=direction, 
						turns.since.change=turns.since.change))
			} else if (direction == 'backward') {
				print('XB1 remove')
				return(stepUAIC(s1, s2, fullbx, y, 
						xb1.cols[xb1.cols != bestb1],
						xb2.cols,
						xb1AIC[[bestb1]], 
						direction=direction, 
						turns.since.change=turns.since.change))
			}
			print(bestb1)
		} else {
			if (turns.since.change <= 1) {
				return(list(list(xb1.cols),list(xb2.cols)))
			} else {
				if (direction == 'forward') {
					return(stepUAIC(s1, s2, fullbx, y, xb1.cols, xb2.cols, 
							curAIC, direction = 'backward', turns.since.change = 0))
				} else if (direction == 'backward') {
					return(stepUAIC(s1, s2, fullbx, y, xb1.cols, xb2.cols, 
							curAIC, direction = 'forward', turns.since.change = 0))
				}
			}
		}
	} else if (b == 2) {
		if (xb2AIC[[bestb2]] < curAIC) {
			if (direction == 'forward') {
				print('XB2 add')
				return(stepUAIC(s1, s2, fullbx, y, 
						xb1.cols,
						c(xb2.cols,bestb2),
						xb2AIC[[bestb2]], 
						direction=direction, 
						turns.since.change=turns.since.change))
			} else if (direction == 'backward') {
				print('XB2 remove')
				return(stepUAIC(s1, s2, fullbx, y, 
						xb1.cols,
						xb2.cols[xb2.cols != bestb2], 
						xb2AIC[[bestb2]], 
						direction=direction, 
						turns.since.change=turns.since.change))
			}
			print(bestb2)
		} else {
			if (turns.since.change <= 1) {
				return(list(list(xb1.cols),list(xb2.cols)))
			} else {
				if (direction == 'forward') {
					return(stepUAIC(s1, s2, fullbx, y, xb1.cols, xb2.cols, 
							curAIC, direction = 'backward', turns.since.change = 0))
				} else if (direction == 'backward') {
					return(stepUAIC(s1, s2, fullbx, y, xb1.cols, xb2.cols, 
							curAIC, direction = 'forward', turns.since.change = 0))
				}
			}
		}
	}
}

brit.act <- subset(real, Voice=='ACT'&!is.na(year)&!is.na(Adj)&!is.na(isDatAcc))
# Create numeric variables for everything (and zscore year)
brit.act$zYear <- (brit.act$year - mean(brit.act$year))/sd(brit.act$year)

brit.act$isAdj <- factor(brit.act$Adj)
levels(brit.act$isAdj) <- c(1,0,1,0)
brit.act$isAdj<-as.numeric(as.character(brit.act$isAdj))

brit.act$NAdj <- factor(brit.act$isAdj)
levels(brit.act$NAdj)<-c('Not Adjacent','Adjacent')

brit.act$isIOPro <- factor(brit.act$IO)
levels(brit.act$isIOPro)<-c(0,1)
brit.act$isIOPro <- as.numeric(as.character(brit.act$isIOPro))

brit.act$isDOPro <- factor(brit.act$DO)
levels(brit.act$isDOPro)<-c(0,1)
brit.act$isDOPro <- as.numeric(as.character(brit.act$isDOPro))

brit.act<-subset(brit.act,(year<=1100&isTo==0) | year>1100)

old.brit.act <- brit.act
# Try to just fit Theme Noun cases, since the scaling seems to cause problems
brit.act<-subset(brit.act, DO=='Theme Noun')

s1 <- rep(1,length(brit.act$isTo))
s2 <- brit.act$isDatAcc

fullbx <- data.frame(rep(1,dim(brit.act)[1]),					# 1 
		    brit.act$zYear,						# 2 
		    brit.act$isDatAcc,						# 3 
		    brit.act$isIOPro,						# 4
		    brit.act$zYear*brit.act$isDatAcc,				# 5
		    brit.act$zYear*brit.act$isIOPro,				# 6
		    brit.act$isDatAcc*brit.act$isIOPro,				# 7
	   	    brit.act$zYear*brit.act$isDatAcc*brit.act$isIOPro)          # 8

buildup <- stepUAIC(s2=s2, fullbx=fullbx,y=brit.act$isTo, curAIC=Inf)

buildup
# [[1]]
# [[1]][[1]]
# [1] 1 2 3 4
# 
# 
# [[2]]
# [[2]][[1]]
# [1] 1 4 2 6
# 
# 

xb1 <- fullbx[,buildup[[1]][[1]]]
xb2 <- fullbx[,buildup[[2]][[1]]]

outputcoef<-fitUshape(s1=s1,s2=s2,xb1=xb1,xb2=xb2,y=brit.act$isTo,printlevel=1)
b1.nums <- 1:(dim(xb1)[2])
b2.nums <- (1+dim(xb1)[2]):(dim(xb1)[2]+dim(xb2)[2])

outputb1<-outputcoef$fit[b1.nums]
outputb2<-outputcoef$fit[b2.nums]

outputb1
# [1]  8.318938  4.552710 -1.631080 -1.780673
outputb2
# [1] 0.997150 2.288093 1.073956 1.151659

pred<-expand.grid(year=seq(min(brit.act$year),max(brit.act$year),1),IO=c('Recipient Noun','Recipient Pronoun'),DO=c('Theme Noun','Theme Pronoun'),NAdj=c('Adjacent','Not Adjacent'),isDatAcc=c(0,1))
pred$zYear <- (pred$year - mean(brit.act$year))/sd(brit.act$year)

pred$isIOPro <- factor(pred$IO)
levels(pred$isIOPro)<-c(0,1)
pred$isIOPro<-as.numeric(as.character(pred$isIOPro))

pred$isDOPro <- factor(pred$DO)
levels(pred$isDOPro)<-c(0,1)
pred$isDOPro<-as.numeric(as.character(pred$isDOPro))

pred$isAdj <- factor(pred$NAdj)
levels(pred$isAdj)<-c(1,0)
pred$isAdj<-as.numeric(as.character(pred$isAdj))


preds1 <- rep(1,length(pred$isDatAcc))
preds2 <- pred$isDatAcc

predfullbx<-as.matrix(data.frame(rep(1,dim(pred)[1]),
	    pred$zYear,
	    pred$isDatAcc,
	    pred$isIOPro,
	    pred$zYear*pred$isDatAcc,
	    pred$zYear*pred$isIOPro,
	    pred$isDatAcc*pred$isIOPro,
	    pred$zYear*pred$isDatAcc*pred$isIOPro))

pred$B1<-predfullbx[,buildup[[1]][[1]]]%*%outputb1
pred$B2<-predfullbx[,buildup[[2]][[1]]]%*%outputb2

pred$isTo <- (preds1/(1+exp(-pred$B1))) * (1-(preds2/(1+exp(-pred$B2))))

brit.act$era <- as.numeric(as.character(cut(brit.act$year,breaks=seq(800,1950,50),labels=seq(825,1925,50))))
brit.act.points<-group_by(brit.act,era,IO,isDatAcc)%>%summarise(isTo=mean(isTo),n=n())

pdf(file='../../images/to-marking-graph.pdf',paper='letter')
ggplot(brit.act.points,aes(year,isTo,color=factor(isDatAcc)))+geom_point(aes(x=era,size=log(n)))+
	geom_line(data=subset(pred,DO!='Theme Pronoun'))+facet_grid(~IO)+
	scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
	scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_size_continuous(name="Log(Number of Tokens/50yrs)")+scale_colour_discrete(name="Word Order",labels=c("Theme--recipient","Recipient--theme"))
dev.off()
#

### Look at changes in recipient vs theme passivisation
## Examine by verb rates of monotransitivity and see if those correlate with recipient passivisation
load('../Rdata/monotrans.RData')
monorats<-group_by(monotrans,Verb)%>%summarise(monoRec=mean(RecipientMono&!ThemeMono),monoThe=mean(ThemeMono&!RecipientMono),monoCP=mean(RecMonoThemeCP&!ThemeMono),monoN=n())

## Loss of recipient passivisation moving from Old to Modern British English
brit.jpas<-subset(britdat,Voice=='PAS')
brit.jpas$zYear<-(brit.jpas$year-mean(brit.jpas$year))/sd(brit.jpas$year)
memod<-glmer(data=brit.jpas,isDatAcc~zYear*IO+DO+(1|Verb),family='binomial')
summary(memod)
# Generalized linear mixed model fit by maximum likelihood (Laplace
#   Approximation) [glmerMod]
#  Family: binomial  ( logit )
# Formula: isDatAcc ~ zYear * IO + DO + (1 | Verb)
#    Data: brit.jpas
# 
#      AIC      BIC   logLik deviance df.resid 
#    766.1    798.8   -377.0    754.1     1714 
# 
# Scaled residuals: 
#     Min      1Q  Median      3Q     Max 
# -1.8742 -0.2881 -0.1586 -0.0355 15.8737 
# 
# Random effects:
#  Groups Name        Variance Std.Dev.
#  Verb   (Intercept) 1.658    1.288   
# Number of obs: 1720, groups:  Verb, 25
# 
# Fixed effects:
#                           Estimate Std. Error z value Pr(>|z|)    
# (Intercept)                -2.5445     0.3652  -6.966 3.25e-12 ***
# zYear                      -0.1651     0.1419  -1.164 0.244594    
# IORecipient Pronoun         1.3275     0.2020   6.571 5.00e-11 ***
# DOTheme Pronoun            -4.1768     0.9994  -4.179 2.92e-05 ***
# zYear:IORecipient Pronoun  -0.7349     0.2148  -3.421 0.000624 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#             (Intr) zYear  IORcpP DOThmP
# zYear       -0.095                     
# IORcpntPrnn -0.244  0.082              
# DOThemPronn -0.025  0.009 -0.013       
# zYr:IORcpnP  0.064 -0.628 -0.055  0.002
verbEffects<-data.frame(verb=rownames(coef(memod)$Verb),effect=coef(memod)$Verb[,1])
verbEffects[order(verbEffects$effect),]
#         verb     effect
# 20   RESTORE -3.7364004
# 23      SEND -3.7128370
# 21    RETURN -3.6277010
# 8      CARRY -3.5441218
# 10   DELIVER -3.3202945
# 27     YIELD -3.1080294
# 11      GIVE -2.8874046
# 7     BETAKE -2.5950156
# 14    NONREC -2.5681676
# 6   BEQUEATH -2.5605177
# 13      LEND -2.5587658
# 25      SHOW -2.4953222
# 26 VOUCHSAFE -2.4794327
# 18   PROFFER -2.3921918
# 12     GRANT -2.2143534
# 22      SELL -2.1468512
# 3     ASSIGN -2.0514768
# 9     DAELAN -2.0479328
# 2    APPOINT -1.9796844
# 1      ALLOT -1.9148999
# 5   BEHIEGHT -1.7509843
# 16       OWE -1.7332061
# 4     AYEVEN -1.5523257
# 24     SERVE -1.3400098
# 17       PAY -1.1277741
# 15     OFFER -0.8430387
# 19   PROMISE -0.4399314
oldeng<-subset(real,year<=1050)

brit.pas<-subset(real,Voice=='PAS')
full<-glm(isDatAcc~year*IO*DO,brit.pas,family='binomial')
no4way<-glm(isDatAcc~year+IO*DO+year*(IO+DO),brit.pas,family='binomial')
noIODO<-glm(isDatAcc~year*(IO+DO),brit.pas,family='binomial')
noyearDO<-glm(isDatAcc~year*(IO)+DO,brit.pas,family='binomial')
noDO<-glm(isDatAcc~year*IO,brit.pas,family='binomial')
noInt<-glm(isDatAcc~year+IO,brit.pas,family='binomial')
noYear<-glm(isDatAcc~year,brit.pas,family='binomial')
null<-glm(isDatAcc~1,brit.pas,family='binomial')

# Compare models (noyearDO) wins
anova(null,noYear,noInt,noDO,noyearDO,noIODO,no4way,full,test='Chisq')
AIC(null,noYear,noInt,noDO,noyearDO,noIODO,no4way,full)

brit.pred.pas<-expand.grid(IO=levels(factor(brit.pas$IO)),DO=levels(factor(brit.pas$DO)),year=seq(min(brit.pas$year),max(brit.pas$year),1),Dialect='British')
brit.pred.pas$isDatAcc<-predict(noyearDO,newdata=brit.pred.pas,type='response')

britpas.points <- group_by(brit.pas,era,IO,DO) %>% summarise(isDatAcc=mean(isDatAcc,na.rm=T),Dialect='British',n=n())

am.pas<-subset(amdat,Voice=='Passive'&!is.na(Order)&!is.na(DO))
full<-glm(isDatAcc~year*IO*DO,am.pas,family='binomial')
no4way<-glm(isDatAcc~year+IO*DO+year*(IO+DO),am.pas,family='binomial')
noIODO<-glm(isDatAcc~year*(IO+DO),am.pas,family='binomial')
noDOyear<-glm(isDatAcc~year*IO+DO,am.pas,family='binomial')
noDO<-glm(isDatAcc~year*IO,am.pas,family='binomial')
noInt<-glm(isDatAcc~year+IO,am.pas,family='binomial')
noYear<-glm(isDatAcc~IO,am.pas,family='binomial')
null<-glm(isDatAcc~1,am.pas,family='binomial')

# Compare models (Interaction between IO and DO significant here)
anova(null,noYear,noInt,noDO,noDOyear,noIODO,no4way,full,test='Chisq')
AIC(null,noYear,noInt,noDO,noDOyear,noIODO,no4way,full)

am.pred.pas<-expand.grid(IO=levels(factor(am.pas$IO)),DO=levels(factor(am.pas$DO)),year=seq(min(am.pas$year),max(am.pas$year),1),Dialect='American')
am.pred.pas$isDatAcc<-predict(noIODO,newdata=am.pred.pas,type='response')

am.pas$era<-as.numeric(as.character(cut(am.pas$year,breaks=seq(1750,2050,100),labels=seq(1800,2000,100))))
ampas.points <- group_by(am.pas,era,IO,DO) %>% summarise(isDatAcc=mean(isDatAcc,na.rm=T),Dialect='American',n=n())

pred.pas<-as.data.frame(rbind(brit.pred.pas,am.pred.pas))
pas.points<-as.data.frame(rbind(britpas.points,ampas.points))

# Graph both British and American changes together
ggplot(pred.pas,aes(year,isDatAcc,color=IO,linetype=Dialect))+stat_smooth()+geom_point(data=pas.points,aes(x=era,pch=Dialect,size=log(n)))+facet_wrap(~DO) 


### Look for changes in object ordering
full<-glm(data=brit.act, isDatAcc ~ year * (IO * DO + IOCP * DOCP) * sizeratio, family=binomial)
builddown<-stepAIC(full)
null<-glm(data=brit.act, isDatAcc ~ 1, family=binomial)
buildup<-stepAIC(glm(data=brit.act, isDatAcc ~ 1, family = binomial), ~ year * bs(year) * IO * DO * IOCP * DOCP * sizeratio)

# Build up model wins!
anova(null,buildup,builddown,full,test='Chisq')

summary(buildup)
# 
# Call:
# glm(formula = isDatAcc ~ sizeratio + IO + DO + DOCP + IOCP + 
#     year + sizeratio:DOCP + sizeratio:IOCP + IO:IOCP + sizeratio:year + 
#     IO:year + sizeratio:IO + sizeratio:IO:IOCP + sizeratio:IO:year, 
#     family = binomial, data = brit.act)
# 
# Deviance Residuals: 
#     Min       1Q   Median       3Q      Max  
# -3.5412  -0.3964   0.1019   0.4619   3.2875  
# 
# Coefficients:
#                                             Estimate Std. Error z value Pr(>|z|)    
# (Intercept)                                0.5901079  0.3853750   1.531 0.125706    
# sizeratio                                 -0.7412591  0.3392752  -2.185 0.028901 *  
# IORecipient Pronoun                        0.7283106  1.1912148   0.611 0.540934    
# DOTheme Pronoun                           -4.3158708  0.1760049 -24.521  < 2e-16 ***
# DOCPAccNoCP                                0.3143622  0.2086114   1.507 0.131829    
# IOCPDatNoCP                               -0.2693376  0.3158331  -0.853 0.393779    
# year                                      -0.0008924  0.0001241  -7.193 6.32e-13 ***
# sizeratio:DOCPAccNoCP                      1.0953015  0.1412110   7.756 8.73e-15 ***
# sizeratio:IOCPDatNoCP                      0.7735061  0.2260272   3.422 0.000621 ***
# IORecipient Pronoun:IOCPDatNoCP            0.0406644  1.0846234   0.037 0.970093    
# sizeratio:year                            -0.0012172  0.0001399  -8.698  < 2e-16 ***
# IORecipient Pronoun:year                   0.0011425  0.0003227   3.540 0.000400 ***
# sizeratio:IORecipient Pronoun             -5.5466104  2.6803383  -2.069 0.038511 *  
# sizeratio:IORecipient Pronoun:IOCPDatNoCP  4.9468404  2.6222717   1.886 0.059231 .  
# sizeratio:IORecipient Pronoun:year         0.0005650  0.0003611   1.565 0.117667    
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 20006.8  on 14859  degrees of freedom
# Residual deviance:  9477.6  on 14845  degrees of freedom
#   (1043 observations deleted due to missingness)
# AIC: 9507.6
# 
# Number of Fisher Scoring iterations: 9
# 
