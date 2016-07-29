library(ggplot2)
library(dplyr)
library(splines)
library(MASS)
library(lme4)
library(nloptr)

# Prepare British data (for looking at impact of NP weight)
load('../Rdata/britdat.RData')
britdat$era2 <- cut(britdat$year,breaks=c(700,1100,1450,1750,2000),labels=c('Old English','Middle English','Early Modern English','Late Modern English'))

britdat$isIOPro <- factor(britdat$IO)
levels(britdat$isIOPro)<-c(0,1)
britdat$isIOPro <- as.numeric(as.character(britdat$isIOPro))

britdat$isDOPro <- factor(britdat$DO)
levels(britdat$isDOPro)<-c(0,1)
britdat$isDOPro <- as.numeric(as.character(britdat$isDOPro))



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

brit.act<-subset(brit.act,(year<=1100&isTo==0) | year>1100)

old.brit.act <- brit.act
pdf(file='../../images/brit-tp.pdf',paper='USr')
gdat<-subset(old.brit.act,DO=='Theme Pronoun'&isDatAcc==0)

gpoints<-group_by(gdat,era,IO)%>%summarise(isTo=mean(isTo),n=n())
ggplot(gpoints,aes(era,isTo,linetype=factor(IO)))+geom_point(aes(size=log(n),pch=IO))+stat_smooth(method='loess',data=gdat,aes(x=year))+
	scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
	scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_size_continuous(name="Log(Number of Tokens/50yrs)")+
	scale_colour_discrete(name="Word Order")+
	scale_linetype_discrete(name="Recipient Status")+
	scale_shape_discrete(name="Recipient Status")
dev.off()


# Look at the Theme Pronoun cases
brit.tp<-subset(old.brit.act, DO=='Theme Pronoun' & isDatAcc == 0 & year>1500)

full <- glm(isTo~year*IO,brit.tp,family='binomial')
noint <- glm(isTo~year+IO,brit.tp,family='binomial')
noyear <- glm(isTo~IO,brit.tp,family='binomial')
null <- glm(isTo~1,brit.tp,family='binomial')

anova(null,noyear,noint,full,test='Chisq')
# Analysis of Deviance Table
# 
# Model 1: isTo ~ 1
# Model 2: isTo ~ IO
# Model 3: isTo ~ year + IO
# Model 4: isTo ~ year * IO
#   Resid. Df Resid. Dev Df Deviance Pr(>Chi)    
# 1       412     406.02                         
# 2       411     293.65  1  112.366  < 2e-16 ***
# 3       410     288.60  1    5.053  0.02458 *  
# 4       409     288.42  1    0.185  0.66679    
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
AIC(null,noyear,noint,full)
#        df      AIC
# null    1 408.0206
# noyear  2 297.6543
# noint   3 294.6013
# full    4 296.4159

brit.tp<-subset(old.brit.act, DO=='Theme Pronoun' & isDatAcc == 0)

brit.tp$IO<-factor(brit.tp$IO)

xtabs(brit.tp$isTo~brit.tp$era2+brit.tp$IO)/table(brit.tp$era2,brit.tp$IO)
#                       brit.tp$IO
# brit.tp$era2           Recipient Noun Recipient Pronoun
#   Old English               0.0000000         0.0000000
#   Middle English            0.9333333         0.2857143
#   Early Modern English      0.9319149         0.4836066
#   Late Modern English       1.0000000         0.6315789
table(brit.tp$era2,brit.tp$IO)
#                       
#                        Recipient Noun Recipient Pronoun
#   Old English                      43                20
#   Middle English                  105                42
#   Early Modern English            235               122
#   Late Modern English              76                38

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

pdf(file='../../images/brit-tn.pdf',paper='USr')
brit.act$Order<-factor(brit.act$isDatAcc)
levels(brit.act$Order)<-c('Theme-recipient','Recipient-theme')

pred$Order<-factor(pred$isDatAcc)
levels(pred$Order)<-c('Theme-recipient','Recipient-theme')

bpoints<-group_by(brit.act,era,IO,Order)%>%summarise(isTo=mean(isTo),n=n())
ggplot(bpoints,aes(era,isTo,linetype=factor(IO),colour=factor(Order)))+geom_point(aes(size=log(n),pch=IO))+geom_line(data=pred,aes(x=year))+
	scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
	scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_size_continuous(name="Log(Number of Tokens/50yrs)")+
	scale_colour_discrete(name="Word Order")+
	scale_linetype_discrete(name="Recipient Status")+
	scale_shape_discrete(name="Recipient Status")
dev.off()

pdf(file='../../images/to-use-bf-1400.pdf',paper='USr')
nbp<-subset(bpoints,Order=='Theme-recipient')
np<-subset(pred,Order=='Theme-recipient')

ggplot(nbp,aes(era,isTo,linetype=factor(IO),colour=factor(Order)))+geom_point(aes(size=log(n),pch=IO))+geom_line(data=np,aes(x=year))+
	scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
	scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_size_continuous(name="Log(Number of Tokens/50yrs)")+
	scale_colour_discrete(name="Word Order")+
	scale_linetype_discrete(name="Recipient Status")+
	scale_shape_discrete(name="Recipient Status")+
	coord_cartesian(xlim=c(min(np$year),1400))
dev.off()



### Look at changes in recipient vs theme passivisation
## Examine by verb rates of monotransitivity and see if those correlate with recipient passivisation
load('../Rdata/monotrans.RData')
monorats<-group_by(monotrans,Verb)%>%summarise(monoRec=mean(RecipientMono&!ThemeMono),monoThe=mean(ThemeMono&!RecipientMono),monoCP=mean(RecMonoThemeCP&!ThemeMono),monoN=n())

## Loss of recipient passivisation moving from Old to Modern British English
britdat2<-subset(britdat,!is.na(isDatAcc)&NVerb!='NONREC'&NVerb!='SEND'&era>=1200)

britdat2$isPas<-factor(britdat2$Voice)
levels(britdat2$isPas)<-c(0,1)
britdat2$isPas<-as.numeric(as.character(britdat2$isPas))

britdat2$Order<-factor(britdat2$isDatAcc)
levels(britdat2$Order)<-c('Theme-Recipient','Recipient-Theme')

summary(stepAIC(glm(isPas~year,subset(britdat2,Order=='Recipient-Theme'),family='binomial')))
# Start:  AIC=964.01
# isPas ~ year
# 
#        Df Deviance    AIC
# - year  1   961.36 963.36
# <none>      960.01 964.01
# 
# Step:  AIC=963.36
# isPas ~ 1
# 
# 
# Call:
# glm(formula = isPas ~ 1, family = "binomial", data = subset(britdat2, 
#     Order == "Recipient-Theme"))
# 
# Deviance Residuals: 
#     Min       1Q   Median       3Q      Max  
# -0.1614  -0.1614  -0.1614  -0.1614   2.9487  
# 
# Coefficients:
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  -4.3344     0.1061  -40.85   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 961.36  on 6954  degrees of freedom
# Residual deviance: 961.36  on 6954  degrees of freedom
# AIC: 963.36
# 
# Number of Fisher Scoring iterations: 7
# 
summary(stepAIC(glm(isPas~year,subset(britdat2,Order=='Theme-Recipient'),family='binomial')))
# Start:  AIC=2687.39
# isPas ~ year
# 
#        Df Deviance    AIC
# <none>      2683.4 2687.4
# - year  1   2693.1 2695.1
# 
# Call:
# glm(formula = isPas ~ year, family = "binomial", data = subset(britdat2, 
#     Order == "Theme-Recipient"))
# 
# Deviance Residuals: 
#     Min       1Q   Median       3Q      Max  
# -0.6337  -0.5852  -0.5487  -0.5012   2.1400  
# 
# Coefficients:
#               Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -3.3019122  0.4979008  -6.632 3.32e-11 ***
# year         0.0009285  0.0003003   3.092  0.00199 ** 
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 2693.1  on 3260  degrees of freedom
# Residual deviance: 2683.4  on 3259  degrees of freedom
# AIC: 2687.4
# 
# Number of Fisher Scoring iterations: 4
# 
summary(stepAIC(glm(isPas~year,subset(britdat2,Order=='Theme-Recipient'&year<1500),family='binomial')))
# Start:  AIC=499.18
# isPas ~ year
# 
#        Df Deviance    AIC
# <none>      495.18 499.18
# - year  1   500.18 502.18
# 
# Call:
# glm(formula = isPas ~ year, family = "binomial", data = subset(britdat2, 
#     Order == "Theme-Recipient" & year < 1500))
# 
# Deviance Residuals: 
#     Min       1Q   Median       3Q      Max  
# -0.5806  -0.5275  -0.4843  -0.4242   2.3616  
# 
# Coefficients:
#              Estimate Std. Error z value Pr(>|z|)   
# (Intercept) -6.946491   2.305881  -3.013  0.00259 **
# year         0.003503   0.001643   2.132  0.03300 * 
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 500.18  on 710  degrees of freedom
# Residual deviance: 495.18  on 709  degrees of freedom
# AIC: 499.18
# 
# Number of Fisher Scoring iterations: 5
# 
summary(stepAIC(glm(isPas~year,subset(britdat2,Order=='Theme-Recipient'&year>=1500),family='binomial')))
# Start:  AIC=2188.24
# isPas ~ year
# 
#        Df Deviance    AIC
# - year  1   2185.1 2187.1
# <none>      2184.2 2188.2
# 
# Step:  AIC=2187.08
# isPas ~ 1
# 
# 
# Call:
# glm(formula = isPas ~ 1, family = "binomial", data = subset(britdat2, 
#     Order == "Theme-Recipient" & year >= 1500))
# 
# Deviance Residuals: 
#    Min      1Q  Median      3Q     Max  
# -0.577  -0.577  -0.577  -0.577   1.937  
# 
# Coefficients:
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -1.70869    0.05496  -31.09   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 2185.1  on 2549  degrees of freedom
# Residual deviance: 2185.1  on 2549  degrees of freedom
# AIC: 2187.1
# 
# Number of Fisher Scoring iterations: 3
# 
pas <- read.csv('../Parsed Corpora/data/pas.txt',sep='\t')

pas$isPas<-factor(pas$Voice)
levels(pas$isPas)<-c(0,NA,1,NA)
pas$isPas<-as.numeric(as.character(pas$isPas))

pas<-subset(pas,!is.na(isPas))

bdat <- data.frame(year=britdat2$year,Order=britdat2$Order,isPas=britdat2$isPas)
pasdat <- data.frame(year=as.numeric(as.character(pas$YoC)),Order='General',isPas=pas$isPas)
joint<-subset(as.data.frame(rbind(bdat,pasdat)),year>=1200)

joint$era<-as.numeric(as.character(cut(joint$year,breaks=seq(1199,1999,100),labels=seq(1250,1950,100))))

brit.points<-group_by(joint,era,Order)%>%summarise(isPas=mean(isPas),tokens=n())
pdf(file='../../images/brit-pas.pdf',paper='letter')
ggplot(joint,aes(year,isPas,colour=Order))+stat_smooth()+geom_point(data=brit.points,aes(x=era,size=log(tokens)))+coord_cartesian(ylim=c(0,1))+
	scale_x_continuous(name='Year of Composition',breaks=seq(1200,1900,100),labels=seq(1200,1900,100))+
	scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_size_continuous(name="Log(Number of Tokens/100yrs)")
dev.off()

# American English
givepr<-read.csv('../COHA Data/give_pasrate_final.txt',sep='\t',quote='')
offerpr<-read.csv('../COHA Data/offer_pasrate_final.txt',sep='\t',quote='')
ampr<-as.data.frame(rbind(givepr,offerpr))

amdat$isTo<-factor(amdat$To)
levels(amdat$isTo)<-c(0,1)
amdat$isTo<-as.numeric(as.character(amdat$isTo))

amdat$counter <- 1

amprgb<-group_by(ampr,year,Verb,Voice)%>%summarise(pasCount=n())
amda<-filter(amdat,!is.na(To))%>%filter(!is.na(isDatAcc))%>%group_by(year,Voice,Verb)%>%summarise(isDatAccTo=sum(counter[isDatAcc==1&isTo==1])/n(),isDatAccNoTo=sum(counter[isDatAcc==1&isTo==0])/n(),isAccDatTo=sum(counter[isDatAcc==0&isTo==1])/n())

newam<-merge(amda,amprgb)
newam$DatAccToCount<-round(newam$pasCount*newam$isDatAccTo)
newam$DatAccNoToCount<-round(newam$pasCount*newam$isDatAccNoTo)
newam$AccDatToCount<-round(newam$pasCount*newam$isAccDatTo)
newam$AccDatNoToCount<-newam$pasCount-(newam$DatAccToCount+newam$DatAccNoToCount+newam$AccDatToCount)

newam2<-subset(newam,!is.nan(DatAccToCount)&!is.nan(DatAccNoToCount)&!is.nan(AccDatToCount)&!is.nan(AccDatNoToCount))

amtabdat<-subset(newam2,year>=1950)

amtabdat2<-group_by(amtabdat,Voice)%>%summarise(DatAcc=sum(DatAccNoToCount),AccDat=sum(AccDatToCount))

ammat <- matrix(c(amtabdat2$DatAcc,amtabdat2$AccDat),nrow=2)

prop.table(as.table(ammat),2)
#            A          B
# A 0.94077443 0.94582516
# B 0.05922557 0.05417484

chisq.test(as.table(ammat))

newam3<-group_by(newam2,year,Verb)%>%summarise(DatAccToTotal=sum(DatAccToCount),DatAccToAct=DatAccToCount[Voice=='Active'],DatAccToRate=1.0-(DatAccToAct/DatAccToTotal),
					       DatAccNoToTotal=sum(DatAccNoToCount),DatAccNoToAct=DatAccNoToCount[Voice=='Active'],DatAccNoToRate=1.0-(DatAccNoToAct/DatAccNoToTotal),
					       AccDatToTotal=sum(AccDatToCount),AccDatToAct=AccDatToCount[Voice=='Active'],AccDatToRate=1.0-(AccDatToAct/AccDatToTotal),
					       AccDatNoToTotal=sum(AccDatNoToCount),AccDatNoToAct=AccDatNoToCount[Voice=='Active'],AccDatNoToRate=1.0-(AccDatNoToAct/AccDatNoToTotal))



pdf(file='../../images/am-change-pass.pdf')
ggplot(newam3,aes(year,AccDatToRate,colour='Theme-Recipient',linetype=Verb,weight=AccDatToTotal))+stat_smooth()+stat_smooth(aes(y=DatAccNoToRate,weight=DatAccNoToTotal,colour='Recipient-Theme'))+coord_cartesian(ylim=c(0,.25))+scale_y_continuous(name="",breaks=c(0,0.05,0.1,0.15,0.2,0.25),labels=c('0%','5%','10%','15%','20%','25%'))+scale_colour_discrete(name="Word Order")
dev.off()

ggplot(newam3,aes(year,AccDatToRate,colour='Theme-Recipient To',weight=AccDatToTotal))+stat_smooth()+stat_smooth(aes(y=DatAccNoToRate,weight=DatAccNoToTotal,colour='Recipient-Theme NoTo'))+coord_cartesian(ylim=c(0,.25))+scale_y_continuous(name="",breaks=c(0,0.05,0.1,0.15,0.2,0.25),labels=c('0%','5%','10%','15%','20%','25%'))

ggplot(newam3,aes(year,AccDatNoToRate,colour='Theme-Recipient NoTo',linetype=Verb,weight=DatAccToTotal))+stat_smooth()+stat_smooth(aes(y=DatAccNoToRate,weight=DatAccNoToTotal,colour='Recipient-Theme NoTo'))+stat_smooth(aes(y=AccDatToRate,weight=AccDatToTotal,colour='Theme-Recipient To'))+coord_cartesian(ylim=c(0.5,1))

# Study oblique vs nominative recipient passivisation
 brit.pas<-subset(britdat,Voice=='PAS'&NVerb!='SEND'&NVerb!='NONREC'&!is.na(isDatAcc))
recpas<-subset(brit.pas,isDatAcc==1&Envir!='Recipient Passive Verb Recipient--Theme (Oblique)' & Envir != 'Recipient Passive Verb Recipient--Theme')

recpas$isNom<-factor(recpas$Envir)
levels(recpas$isNom)<-c(0,1)
recpas$isNom<-as.numeric(as.character(recpas$isNom))

fitScaledLogit <- function(s=rep(1,dim(x)[1]),
		      x, y, lltol = .1,
		      initb=rep(0,dim(x)[2]), 
		      alg = 'NLOPT_LN_COBYLA',
		      printlevel = 0,
		      f_tol = 1e-8,
		      ll.only= F) {
	ll.fun <- function(z) {
		p <- s/(1+exp(-(as.matrix(x)%*%z)))
		return(sum(-log(y*p+abs(y-1)*(1-p))))
	}
	fit <- nloptr(initb,
		eval_f=ll.fun,
		opt=list(algorithm=alg,print_level=printlevel,ftol_rel=f_tol),
		lb=c(rep(-Inf,length(initb))),
		ub=c(rep(Inf,length(initb))))
	
	ll <- fit$objective
	r <- list()
	r$ll <- ll
	r$fit <- fit$sol
	return(r)
}




pseu <- read.csv('../Parsed Corpora/data/pseudopassives.csv')
pseu2 <- subset(pseu, selected != 'selnot' & Genre != 'X' & Genre != 'Y' & Genre != 'Z')

pseu2$isPas <- factor(pseu2$selected)
levels(pseu2$isPas)<-c(0,1)
pseu2$isPas <- as.numeric(as.character(pseu2$isPas))

pdat <- data.frame(Value = pseu2$isPas, year=pseu2$YoC, type='Pseudopassive')
bdat <- data.frame(Value = recpas$isNom, year=recpas$year, type='Recipient Passive')

joint.rp <- as.data.frame(rbind(pdat, bdat))

joint.rp$isPseudo <- factor(joint.rp$type)
levels(joint.rp$isPseudo)<-c(1,0)
joint.rp$isPseudo<-as.numeric(as.character(joint.rp$isPseudo))

pseuscale <- mean(joint.rp$Value[joint.rp$year >=1700 & joint.rp$type=='Pseudopassive'],na.rm=T)
recscale <- mean(joint.rp$Value[joint.rp$year >=1700 & joint.rp$type!='Pseudopassive'],na.rm=T)

joint.rp$scale<-NA
joint.rp$scale[joint.rp$type=='Pseudopassive']<-pseuscale
joint.rp$scale[joint.rp$type!='Pseudopassive']<-recscale

joint.rp$zYear<-(joint.rp$year-mean(joint.rp$year))/sd(joint.rp$year)

fullx<-data.frame(rep(1,dim(joint.rp)[1]),
		  joint.rp$zYear,
		  joint.rp$isPseudo,
		  joint.rp$zYear*joint.rp$isPseudo)
	      

joint.fit.full<-fitScaledLogit(s=joint.rp$scale, x=fullx, y=joint.rp$Value,printlevel=1)
joint.fit.noint<-fitScaledLogit(s=joint.rp$scale, x=fullx[,c(1,2,3)], y=joint.rp$Value,printlevel=1)
joint.fit.nocond<-fitScaledLogit(s=joint.rp$scale, x=fullx[,c(1,2)], y=joint.rp$Value,printlevel=1)
joint.fit.null<-fitScaledLogit(s=joint.rp$scale, x=as.data.frame(fullx[,c(1)]), y=joint.rp$Value,printlevel=1)

c(calcAIC(joint.fit.null),calcAIC(joint.fit.nocond),calcAIC(joint.fit.noint),calcAIC(joint.fit.full))
# [1] 1994.194 1884.509 1886.457 1888.775 Year only mod is best

pred <- expand.grid(year=seq(min(joint.rp$year),max(joint.rp$year),1),type=c('Pseudopassive','Recipient Passive'))

pred$zYear<-(pred$year-mean(joint.rp$year))/sd(joint.rp$year)

pred$isPseudo<-factor(pred$type)
levels(pred$isPseudo)<-c(1,0)
pred$isPseudo<-as.numeric(as.character(pred$isPseudo))

pred$scale<-NA
pred$scale[pred$type=='Pseudopassive']<-pseuscale
pred$scale[pred$type!='Pseudopassive']<-recscale

pfullx<-data.frame(rep(1,dim(pred)[1]),
		  pred$zYear,
		  pred$isPseudo,
		  pred$zYear*pred$isPseudo)
	
pred$p<-pred$scale/(1+exp(-(as.matrix(pfullx[,c(1,2)])%*%joint.fit.nocond$fit)))
pred$p2<-pred$scale/(1+exp(-(as.matrix(pfullx)%*%joint.fit.full$fit)))

joint.rp$era<-as.numeric(as.character(cut(joint.rp$year,breaks=seq(800,2000,100),labels=seq(850,1950,100))))
joint.points<-group_by(joint.rp,era,type)%>%summarise(p=mean(Value),size=n())

pdf(file='../../images/recpas-pseudo.pdf')
ggplot(pred,aes(year,p,colour=type,linetype='0'))+stat_smooth(method=loess,data=joint.rp,aes(y=Value,linetype='1'))+geom_line()+#geom_point(data=joint.points,aes(x=era,size=log(size)))+
	coord_cartesian(ylim=c(0,1))+
	scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
	scale_y_continuous(name="% New Variant",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_linetype_discrete(name="Modelling Method",labels=c('Logistic Regression','LOESS'))+
	scale_colour_discrete(name="Construction")
dev.off()

# pdf(file='../../images/recpas-pseudo.pdf')
# ggplot(recpas,aes(year,isNom,colour='Nominative Recipient Passive'))+stat_smooth(method='loess')+stat_smooth(method='loess',data=pseu2,aes(x=YoC,y=isPas,colour='Pseudo-passive'))+scale_x_continuous(breaks=seq(1000,1900,100),labels=seq(1000,1900,100))+scale_colour_discrete(name='Construction')+
#         scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
#         scale_y_continuous(name="% New Variant",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))
# dev.off()

# Generate graph of American English direct theme passive rates
am.pas<-subset(amdat,Voice=='Passive'&!is.na(Order)&!is.na(DO))
am.the<-subset(am.pas,isDatAcc==0)

am.the$isTo<-factor(am.the$To)
levels(am.the$isTo)<-c(0,1)
am.the$isTo<-as.numeric(as.character(am.the$isTo))

pdf(file='../../images/directtheme-am.pdf')
ggplot(am.the,aes(year,isTo,colour=IO))+stat_smooth()+coord_cartesian(ylim=c(0,1))+
	scale_x_continuous(name='Year of Composition',breaks=seq(1800,2020,20),labels=seq(1800,2020,20))+
	scale_y_continuous(name="% To",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
	scale_colour_discrete(name="Recipient Status")

dev.off()
#Old Stuff
#sxc















# brit.jpas<-subset(britdat,Voice=='PAS'&year>=1375)
# brit.jpas$Verb<-factor(brit.jpas$Verb)
# brit.jpas$IO<-factor(brit.jpas$IO)
# brit.jpas$DO<-factor(brit.jpas$DO)
# brit.jpas$zYear<-(brit.jpas$year-mean(brit.jpas$year))/sd(brit.jpas$year)
# memod<-glmer(data=brit.jpas,isDatAcc~zYear*IO+DO+(1|Verb),family='binomial')
# summary(memod)
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
# verbEffects<-data.frame(verb=rownames(coef(memod)$Verb),effect=coef(memod)$Verb[,1])
# verbEffects[order(verbEffects$effect),]
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

# Early Modern
# brit.jpas<-subset(britdat,Voice=='PAS'&year>=1375&year<1600&Verb!='NONREC')
# brit.jpas$Verb<-factor(brit.jpas$Verb)
# brit.jpas$IO<-factor(brit.jpas$IO)
# brit.jpas$DO<-factor(brit.jpas$DO)
# brit.jpas$zYear<-(brit.jpas$year-mean(brit.jpas$year))/sd(brit.jpas$year)
# memod<-glmer(data=brit.jpas,isDatAcc~IO+DO+(1|Verb),family='binomial')
# verbEffects<-data.frame(verb=rownames(coef(memod)$Verb),effect=coef(memod)$Verb[,1])
# verbEffects[order(verbEffects$effect),]
#       verb      effect
# 14 RESTORE -3.35535507
# 5  DELIVER -3.31276143
# 15  RETURN -3.15525397
# 4    CARRY -3.10288914
# 20   YIELD -3.00900217
# 6     GIVE -2.96616707
# 17    SEND -2.94986666
# 19    SHOW -2.72806858
# 16    SELL -2.62116979
# 3   BETAKE -2.50873670
# 12 PROFFER -2.18868704
# 7    GRANT -1.64449121
# 1  APPOINT -1.55064216
# 9    OFFER -1.22318013
# 10     OWE -1.01224497
# 2   ASSIGN -0.74612157
# 11     PAY -0.68355533
# 13 PROMISE -0.33609862
# 18   SERVE -0.08750492

# Late Modern
# brit.jpas.lm<-subset(britdat,Voice=='PAS'&year>=1600&Verb!='NONREC')
# brit.jpas.lm$zYear<-(brit.jpas.lm$year-mean(brit.jpas.lm$year))/sd(brit.jpas.lm$year)
# memod<-glmer(data=brit.jpas.lm,isDatAcc~IO+(1|Verb),family='binomial')
# verbEffects<-data.frame(verb=rownames(coef(memod)$Verb),effect=coef(memod)$Verb[,1])
# verbEffects[order(verbEffects$effect),]
#         verb     effect
# 17      SEND -4.5748012
# 15    RETURN -4.1551450
# 14   RESTORE -4.1533747
# 5      CARRY -4.0402335
# 18     SERVE -3.7098562
# 3     ASSIGN -3.6586512
# 16      SELL -3.5643428
# 2    APPOINT -3.3544570
# 4   BEQUEATH -3.3352414
# 9       LEND -3.3352414
# 20 VOUCHSAFE -3.2615645
# 7       GIVE -3.1475111
# 6    DELIVER -3.1404883
# 8      GRANT -3.0710505
# 19      SHOW -2.3722668
# 1      ALLOT -2.1945216
# 12       PAY -1.5528601
# 11     OFFER -0.7816823
# 13   PROMISE -0.5116641

# brit.jpas<-subset(britdat,Voice=='PAS'&year>=1375&Verb!='NONREC')
# brit.jpas$after1600<-as.numeric(as.character(cut(brit.jpas$year,breaks=c(1000,1600,2000),labels=c('0','1'))))
# brit.jpas$zYear<-(brit.jpas$year-mean(brit.jpas$year))/sd(brit.jpas$year)
# memod<-glmer(data=brit.jpas,isDatAcc~zYear*IO+(after1600||Verb),family='binomial')
# verbEffects<-data.frame(verb=rownames(coef(memod)$Verb),effect=coef(memod)$Verb[,1],yearEffect=coef(memod)$Verb[,2])
# verbEffects[order(verbEffects$effect),]
#         verb      effect yearEffect
# 19      SEND -0.45139572 -3.7956881
# 20     SERVE -0.28848735 -1.0888050
# 3     ASSIGN -0.14063467 -2.5765851
# 13       PAY -0.14053602 -0.9866547
# 1      ALLOT -0.13883163 -1.8581311
# 17    RETURN -0.13109292 -4.2983085
# 2    APPOINT -0.12483879 -2.4565602
# 6      CARRY -0.11799480 -4.2110768
# 16   RESTORE -0.09048701 -4.3543178
# 9      GRANT -0.08123876 -2.3641253
# 18      SELL -0.04845462 -3.6924900
# 4   BEQUEATH -0.02080903 -3.0615019
# 10      LEND -0.01998323 -3.0561289
# 22 VOUCHSAFE -0.01173429 -3.0024581
# 5     BETAKE  0.00000000 -3.3917646
# 12       OWE  0.00000000 -1.5280226
# 14   PROFFER  0.00000000 -3.1590776
# 23     YIELD  0.00000000 -3.5889577
# 21      SHOW  0.21563843 -2.6586233
# 7    DELIVER  0.22644397 -3.6588364
# 15   PROMISE  0.30291922 -0.6043801
# 8       GIVE  0.37555799 -3.2895328
# 11     OFFER  0.62651199 -1.1927854

# verbEffects[order(verbEffects$effect+verbEffects$yearEffect),]
#         verb      effect yearEffect
# 16   RESTORE -0.09048701 -4.3543178
# 17    RETURN -0.13109292 -4.2983085
# 6      CARRY -0.11799480 -4.2110768
# 19      SEND -0.45139572 -3.7956881
# 18      SELL -0.04845462 -3.6924900
# 23     YIELD  0.00000000 -3.5889577
# 7    DELIVER  0.22644397 -3.6588364
# 5     BETAKE  0.00000000 -3.3917646
# 14   PROFFER  0.00000000 -3.1590776
# 4   BEQUEATH -0.02080903 -3.0615019
# 10      LEND -0.01998323 -3.0561289
# 22 VOUCHSAFE -0.01173429 -3.0024581
# 8       GIVE  0.37555799 -3.2895328
# 3     ASSIGN -0.14063467 -2.5765851
# 2    APPOINT -0.12483879 -2.4565602
# 9      GRANT -0.08123876 -2.3641253
# 21      SHOW  0.21563843 -2.6586233
# 1      ALLOT -0.13883163 -1.8581311
# 12       OWE  0.00000000 -1.5280226
# 20     SERVE -0.28848735 -1.0888050
# 13       PAY -0.14053602 -0.9866547
# 11     OFFER  0.62651199 -1.1927854
# 15   PROMISE  0.30291922 -0.6043801

# oldeng<-subset(real,year<=1050)
# oldeng$IO<-factor(oldeng$IO)
# oldeng$DO<-factor(oldeng$DO)
# ftable(xtabs(oldeng$isDatAcc~oldeng$Voice+oldeng$IO+oldeng$DO)/table(oldeng$Voice,oldeng$IO,oldeng$DO))
# 
# brit.pas<-subset(britdat,Voice=='PAS'&NVerb!='SEND'&NVerb!='NONREC'&!is.na(isDatAcc))

# Try relabeling passive types (to count direct theme passives as dat-acc orders)
# brit.pas2<-brit.pas

# brit.pas2$isDatAcc[brit.pas2$isTo==0]<-1

# Other stuff

# pas.tn<-subset(brit.pas,DO=='Theme Noun')
# pas.tn$IO<-factor(pas.tn$IO)
# pas.tn$era<-cut(pas.tn$year,breaks=seq(899,2099,200),labels=seq(1000,2000,200))

# xtabs(pas.tn$isDatAcc~pas.tn$era+pas.tn$IO)/table(pas.tn$era,pas.tn$IO)
#           pas.tn$IO
# pas.tn$era Recipient Noun Recipient Pronoun
#       1000     0.15789474        1.00000000
#       1200     0.16666667        0.83333333
#       1400     0.17948718        0.42424242
#       1600     0.10483871        0.36470588
#       1800     0.05172414        0.11864407
#       2000     0.33333333        0.60000000
# table(pas.tn$era,pas.tn$IO)
#       
#        Recipient Noun Recipient Pronoun
#   1000             19                12
#   1200              6                 6
#   1400             39                33
#   1600            124                85
#   1800            116                59
#   2000             12                 5

# full<-glm(isDatAcc~year*IO*DO,brit.pas,family='binomial')
# no4way<-glm(isDatAcc~year+IO*DO+year*(IO+DO),brit.pas,family='binomial')
# noIODO<-glm(isDatAcc~year*(IO+DO),brit.pas,family='binomial')
# noyearDO<-glm(isDatAcc~year*(IO)+DO,brit.pas,family='binomial')
# noInt<-glm(isDatAcc~year+IO+DO,brit.pas,family='binomial')
# noDO<-glm(isDatAcc~year+IO,brit.pas,family='binomial')
# noYear<-glm(isDatAcc~year,brit.pas,family='binomial')
# null<-glm(isDatAcc~1,brit.pas,family='binomial')

# Compare models (noyearDO) wins
# anova(null,noYear,noDO,noInt,noyearDO,noIODO,no4way,full,test='Chisq')
# Analysis of Deviance Table
# 
# Model 1: isDatAcc ~ 1
# Model 2: isDatAcc ~ year
# Model 3: isDatAcc ~ year + IO
# Model 4: isDatAcc ~ year + IO + DO
# Model 5: isDatAcc ~ year * (IO) + DO
# Model 6: isDatAcc ~ year * (IO + DO)
# Model 7: isDatAcc ~ year + IO * DO + year * (IO + DO)
# Model 8: isDatAcc ~ year * IO * DO
#   Resid. Df Resid. Dev Df Deviance  Pr(>Chi)    
# 1      1638     942.25                          
# 2      1637     933.56  1    8.686  0.003206 ** 
# 3      1636     870.77  1   62.788 2.303e-15 ***
# 4      1635     786.55  1   84.225 < 2.2e-16 ***
# 5      1634     786.44  1    0.109  0.741829    
# 6      1633     786.33  1    0.111  0.739096    
# 7      1632     785.01  1    1.319  0.250794    
# 8      1631     785.01  1    0.000  0.999903    
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# AIC(null,noYear,noDO,noInt,noyearDO,noIODO,no4way,full)
#          df      AIC
# null      1 944.2452
# noYear    2 937.5589
# noDO      3 876.7714
# noInt     4 794.5463
# noyearDO  5 796.4378
# noIODO    6 798.3269
# no4way    7 799.0080
# full      8 801.0080

# brit.pred.pas<-expand.grid(IO=levels(factor(brit.pas$IO)),DO=levels(factor(brit.pas$DO)),year=seq(min(brit.pas$year),max(brit.pas$year),1),Dialect='British')
# brit.pred.pas$isDatAcc<-predict(noInt,newdata=brit.pred.pas,type='response')


# am.pas<-subset(amdat,Voice=='Passive'&!is.na(Order)&!is.na(DO))
# full<-glm(isDatAcc~year*IO*DO*Verb,am.pas,family='binomial')
# sub1<-glm(isDatAcc~year+IO+DO+Verb+year:IO+year:DO+year:Verb,am.pas,family='binomial')

# noVerbInt<-glm(isDatAcc~year*IO*DO+Verb,am.pas,family='binomial')


# no4way<-glm(isDatAcc~year+IO*DO+year*(IO+DO),am.pas,family='binomial')
# noIODO<-glm(isDatAcc~year*(IO+DO),am.pas,family='binomial')
# noDOyear<-glm(isDatAcc~year*IO+DO,am.pas,family='binomial')
# noDO<-glm(isDatAcc~year*IO,am.pas,family='binomial')
# noInt<-glm(isDatAcc~year+IO,am.pas,family='binomial')
# noYear<-glm(isDatAcc~IO,am.pas,family='binomial')
# null<-glm(isDatAcc~1,am.pas,family='binomial')

# Compare models (Interaction between IO and DO significant here)
# anova(null,noYear,noInt,noDO,noDOyear,noIODO,no4way,full,test='Chisq')

# Analysis of Deviance Table
# 
# Model 1: isDatAcc ~ 1
# Model 2: isDatAcc ~ IO
# Model 3: isDatAcc ~ year + IO
# Model 4: isDatAcc ~ year * IO
# Model 5: isDatAcc ~ year * IO + DO
# Model 6: isDatAcc ~ year * (IO + DO)
# Model 7: isDatAcc ~ year + IO * DO + year * (IO + DO)
# Model 8: isDatAcc ~ year * IO * DO
#   Resid. Df Resid. Dev Df Deviance  Pr(>Chi)    
# 1     10580    11266.2                          
# 2     10579    11109.1  1   157.06 < 2.2e-16 ***
# 3     10578     9581.0  1  1528.14 < 2.2e-16 ***
# 4     10577     9558.6  1    22.36 2.255e-06 ***
# 5     10576     9352.6  1   205.99 < 2.2e-16 ***
# 6     10575     9347.0  1     5.57   0.01828 *  
# 7     10574     9344.7  1     2.32   0.12741    
# 8     10573     9344.6  1     0.09   0.76840    
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# AIC(null,noYear,noInt,noDO,noDOyear,noIODO,no4way,full)
#          df       AIC
# null      1 11268.154
# noYear    2 11113.098
# noInt     3  9586.953
# noDO      4  9566.589
# noDOyear  5  9362.604
# noIODO    6  9359.035
# no4way    7  9358.711
# full      8  9360.624

# am.pas$era<-as.numeric(as.character(cut(am.pas$year,breaks=seq(1750,2050,100),labels=seq(1800,2000,100))))

# brit.pas.dat<-data.frame(year=brit.pas$year,isDatAcc=brit.pas$isDatAcc,Dialect='British',IO=brit.pas$IO,DO=brit.pas$DO)
# am.pas.dat<-data.frame(year=am.pas$year,isDatAcc=am.pas$isDatAcc,Dialect='American',IO=am.pas$IO,DO=am.pas$DO)

# ampas.points <- group_by(am.pas,era,IO,DO) %>% summarise(isDatAcc=mean(isDatAcc,na.rm=T),Dialect='American',n=n())
# britpas.points <- group_by(brit.pas,era,IO,DO) %>% summarise(isDatAcc=mean(isDatAcc,na.rm=T),Dialect='British',n=n())

# pas.points<-as.data.frame(rbind(britpas.points,ampas.points))
# joint.dat<-as.data.frame(rbind(brit.pas.dat,am.pas.dat))

# pas.points$Dialect<-factor(pas.points$Dialect,levels=c('British','American'))
# joint.dat$Dialect<-factor(joint.dat$Dialect,levels=c('British','American'))

# Graph both British and American changes together
# pdf(file='../../images/rec-pas-graph.pdf')
# ggplot(joint.dat,aes(year,isDatAcc,color=Dialect))+stat_smooth()+geom_point(data=pas.points,aes(x=era,size=log(n)))+facet_grid(IO~DO)+
#         scale_x_continuous(name='Year of Composition',breaks=seq(800,2000,100),labels=seq(800,2000,100))+
#         scale_y_continuous(name='% Recipient Passivisation',breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%')) +
#         scale_size_continuous(name='Log(Number of Tokens/century)')+scale_linetype_discrete(name='')
# dev.off()

# am.pas$era<-cut(am.pas$year,breaks=c(1799,1899,1999,2099),labels=c('19th Century','20th Century', '21st Century'))

# ftable(xtabs(am.pas$isDatAcc~am.pas$era+am.pas$IO+am.pas$DO)/table(am.pas$era,am.pas$IO,am.pas$DO))
#                                am.pas$DO Theme Noun Theme Pronoun
# am.pas$era   am.pas$IO                                           
# 19th Century Recipient Noun              0.05317248    0.03773585
#              Recipient Pronoun           0.11282844    0.01785714
# 20th Century Recipient Noun              0.26698541    0.07534247
#              Recipient Pronoun           0.46153846    0.16181230
# 21st Century Recipient Noun              0.42857143    0.18181818
#              Recipient Pronoun           0.81981982    0.15384615

# ftable(am.pas$era,am.pas$IO,am.pas$DO)
#                                 Theme Noun Theme Pronoun
#                                                         
# 19th Century Recipient Noun           2238           212
#              Recipient Pronoun        1294           224
# 20th Century Recipient Noun           3974           292
#              Recipient Pronoun        1703           309
# 21st Century Recipient Noun            189            22
#              Recipient Pronoun         111            13

### Look for changes in object ordering
# full<-glm(data=brit.act, isDatAcc ~ year * (IO * DO + IOCP * DOCP) * sizeratio, family=binomial)
# builddown<-stepAIC(full)
# null<-glm(data=brit.act, isDatAcc ~ 1, family=binomial)
# buildup<-stepAIC(glm(data=brit.act, isDatAcc ~ 1, family = binomial), ~ year * bs(year) * IO * DO * IOCP * DOCP * sizeratio)

# Build up model wins!
# anova(null,buildup,builddown,full,test='Chisq')

# summary(buildup)
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
