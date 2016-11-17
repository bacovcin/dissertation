library(ggplot2)
library(dplyr)
library(splines)
library(MASS)
library(lme4)
library(nloptr)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

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

# isTo modelling functions for piecewise reanalysis
calcAIC <- function(mod) {
  return(2*sum(mod$sol!=0)+2*mod$obj)
}

unlogit <- function(x) {return(1/(1+exp(-x)))}

fitUshape <- function(x1,x2,x3,x4,y1,y2,y3,y4,
                      lb,
                      ub,
                      alg2 = 'NLOPT_LN_SBPLX',
                      printlevel = 0,
                      x_tol = 1e-8,
                      tr_reanalysis = TRUE) {
  # Four conditions:
  # 1: Theme--Recipient Recipient Noun
  # 2: Theme--Recipient Recipient Pronoun
  # 3: Recipient--Theme Recipient Noun
  # 4: Recipient--Theme Recipient Pronoun
  ll_fun <- function(z) {
    ry = z[1] # Reanalysis year
    rypro = z[1] + z[2]
    Int1 = z[3] # Intercept for Theme--Recipient orders with Recipient Nouns
    Slope1 = z[4]
    ProInt1 = z[5]
    ProSlope1 = z[6]
    RTInt1 = z[7]
    RTSlope1 = z[8]
    ProRTInt1 = z[9]
    ProRTSlope1 = z[10]
    Slope2 = z[11]
    ProSlope2 = z[12]
    Int2 = (Int1 + Slope1 * ry + RTInt1 + RTSlope1 * ry) - Slope2 * ry
    ProInt2 = (Int1 + Slope1 * rypro + 
               RTInt1 + RTSlope1 * rypro + 
               ProInt1 + ProSlope1 * rypro +
               ProRTInt1 + ProRTSlope1 * rypro) - (Slope2 * rypro + ProSlope2 * rypro)
    z1 <- Int1 + Slope1 * x1
    if (tr_reanalysis) { z1[x1>=ry] <- 100 }
    z2 <- Int1 + Slope1 * x2 + ProInt1 + ProSlope1 * x2
    if (tr_reanalysis) { z2[x2>=rypro] <- 100 }
    z3 <- Int1 + Slope1 * x3 + RTInt1 + RTSlope1 * x3
    z3[x3>=ry] <- Int2 + Slope2 * x3[x3>=ry]
    z4 <- Int1 + Slope1 * x4 + RTInt1 + RTSlope1 * x4 + ProInt1 + ProSlope1 * x4 + ProRTInt1 + ProRTSlope1 * x4
    z4[x4>=rypro] <- ProInt2 + Slope2 * x4[x4>=rypro] + ProSlope2 * x4[x4>=rypro]
    
    p1 <- unlogit(z1)
    p2 <- unlogit(z2)
    p3 <- unlogit(z3)
    p4 <- unlogit(z4)
    
    ll1 <- sum(-log(y1*p1+abs(y1-1)*(1-p1)))
    ll2 <- sum(-log(y2*p2+abs(y2-1)*(1-p2)))
    ll3 <- sum(-log(y3*p3+abs(y3-1)*(1-p3)))
    ll4 <- sum(-log(y4*p4+abs(y4-1)*(1-p4)))
    return(sum(c(ll1,ll2,ll3,ll4)))
  }
  res1 <- nloptr(c(mean(lb[1],ub[1]),
                   mean(lb[2],ub[2]),
                   mean(lb[3],ub[3]),
                   mean(lb[4],ub[4]),
                   mean(lb[5],ub[5]),
                   mean(lb[6],ub[6]),
                   rep(0,6)),
                 ll_fun,
                 lb=lb,
                 ub=ub,
                 opts=list(algorithm='NLOPT_GN_CRS2_LM',population=250,ftol_abs=0,print_level=printlevel,maxeval=15000))
  return(nloptr(res1$sol,
                ll_fun,
                lb=lb,
                ub=ub,
                opts=list(algorithm=alg2,print_level=printlevel,xtol_rel=x_tol,ftol_abs=0,xtol_rel=0,xtol_abs=0,maxeval=10000))) 
}

brit.act <- subset(real, Voice=='ACT'&NVerb!='NONREC'&!is.na(year)&!is.na(Adj)&!is.na(isDatAcc))
# Create numeric variables for everything (and zscore year)

brit.act$isAdj <- factor(brit.act$Adj)
levels(brit.act$isAdj) <- c(1,0,1,0)
brit.act$isAdj<-as.numeric(as.character(brit.act$isAdj))

brit.act$NAdj <- factor(brit.act$isAdj)
levels(brit.act$NAdj)<-c('Not Adjacent','Adjacent')

# Remove spurious Old English examples with 'to' (actually goals)
brit.act<-subset(brit.act,(year<=1100&isTo==0) | year>1100)

# Test Constant Rate Effect for sentences with Theme Noun phrases before 1750
brit.act<-subset(brit.act, DO=='Theme Noun'&year<=1750)

testCRE <- function(minRY, maxRY, RYdiff, x1, x2, x3, x4, y1, y2, y3, y4, printlevel = 0, trreanalysis=FALSE) {
	results <- list()

	# Create temporary data frame to fit models for theme--recipient order
	tmp <- data.frame(y=c(y1,y2),x=c(x1,x2),type=c(rep('Noun',length(x1)),rep('Pronoun',length(x2))))

	glm3 <- glm(y~x+type,tmp,family='binomial')
	glm4 <- glm(y~x*type,tmp,family='binomial')

	g3.AIC <- AIC(glm3)
	g4.AIC <- AIC(glm4)

	results[[1]] <- c(g4.AIC,g3.AIC)

	if (g3.AIC<g4.AIC) {
		Int1Same = coef(glm3)[1] 
		Slope1Same = coef(glm3)[2]
		ProInt1Same = coef(glm3)[3]
		ProSlope1Same = 0
	} else {
		Int1Same = coef(glm4)[1] 
		Slope1Same = coef(glm4)[2]
		ProInt1Same = coef(glm4)[3]
		ProSlope1Same = coef(glm4)[4]
	}

	# Set the seed for reproducability given randomness in fitting algorithm
	set.seed(1123)

	# Check and see if the reanalysis point for nouns and pronouns is the same
	fitFull<-fitUshape(x1,x2,x3,x4,y1,y2,y3,y4,
                         lb=c(minRY,0,Int1Same,Slope1Same,ProInt1Same,ProSlope1Same,-25,-25,-25,-25,-25,-25),
                         ub=c(maxRY,RYdiff,Int1Same,Slope1Same,ProInt1Same,ProSlope1Same,25,25,25,25,25,25),
                         printlevel=printlevel,
                         tr_reanalysis = trreanalysis)

	fitSameRY<-fitUshape(x1,x2,x3,x4,y1,y2,y3,y4,
                           lb=c(minRY,0,Int1Same,Slope1Same,ProInt1Same,ProSlope1Same,-25,-25,-25,-25,-25,-25),
                           ub=c(maxRY,0,Int1Same,Slope1Same,ProInt1Same,ProSlope1Same,25,25,25,25,25,25),
                           printlevel=printlevel,
                           tr_reanalysis = trreanalysis)

	# Compare and find optimal choice 
	fullAIC<-calcAIC(fitFull)
	sameAIC<-calcAIC(fitSameRY)

	results[[2]] <- c(fullAIC,sameAIC)
	mod <- list()
	if (fullAIC < sameAIC) {
	  mod[[1]] <- fitFull
          lb=c(minRY,0,Int1Same,Slope1Same,ProInt1Same,ProSlope1Same,-25,0,-25,-25,-25,-25)
          ub=c(maxRY,RYdiff,Int1Same,Slope1Same,ProInt1Same,ProSlope1Same,25,0,25,25,25,25)
	} else {
	  mod[[1]] <- fitSameRY
          lb=c(minRY,0,Int1Same,Slope1Same,ProInt1Same,ProSlope1Same,-25,0,-25,-25,-25,-25)
          ub=c(maxRY,0,Int1Same,Slope1Same,ProInt1Same,ProSlope1Same,25,0,25,25,25,25)
	}

	mod[[2]]<-fitUshape(x1,x2,x3,x4,y1,y2,y3,y4,
			   lb=lb,
			   ub=ub,
                           printlevel=printlevel,
                           tr_reanalysis = trreanalysis)


	# Fit the model with CRE between theme--recipient and recipient--theme
	lb[10] <- 0
	ub[10] <- 0
	mod[[3]]<-fitUshape(x1,x2,x3,x4,y1,y2,y3,y4,
			   lb=lb,
			   ub=ub,
                           printlevel=printlevel,
                           tr_reanalysis = trreanalysis)

	# Fit the model with CRE between full noun phrase and pronoun recipient--theme
	lb[12] <- 0
	ub[12] <- 0
	mod[[4]]<-fitUshape(x1,x2,x3,x4,y1,y2,y3,y4,
			   lb=lb,
			   ub=ub,
                           printlevel=printlevel,
                           tr_reanalysis = trreanalysis)

	# Fit the model with identical intercept between full noun phrase and pronoun recipient--theme
	lb[9] <- 0
	ub[9] <- 0
	mod[[5]]<-fitUshape(x1,x2,x3,x4,y1,y2,y3,y4,
			   lb=lb,
			   ub=ub,
                           printlevel=printlevel,
                           tr_reanalysis = trreanalysis)

	# Fit the model with identical intercept between recipient--theme and theme--recipient
	lb[7] <- 0
	ub[7] <- 0
	mod[[6]]<-fitUshape(x1,x2,x3,x4,y1,y2,y3,y4,
			   lb=lb,
			   ub=ub,
                           printlevel=printlevel,
                           tr_reanalysis = trreanalysis)

	AICs <- c(
		calcAIC(mod[[1]]),
		calcAIC(mod[[2]]),
		calcAIC(mod[[3]]),
		calcAIC(mod[[4]]),
		calcAIC(mod[[5]]),
		calcAIC(mod[[6]])
		)

	objs <- c(
		mod[[1]]$obj,
		mod[[2]]$obj,
		mod[[3]]$obj,
		mod[[4]]$obj,
		mod[[5]]$obj,
		mod[[6]]$obj)

	print(mod[[1]]$sol)
	print(mod[[2]]$sol)
	print(mod[[3]]$sol)
	print(mod[[4]]$sol)
	print(mod[[5]]$sol)
	print(mod[[6]]$sol)

	results[[3]] <- AICs
	results[[4]] <- objs
	results[[5]] <- mod[[which.min(AICs)]]
	return(results)
}

# Z-score year for computational reasons
brit.act$zYear <- (brit.act$year - mean(brit.act$year))/sd(brit.act$year)

# Extract predictors and dependent variables for each context
x1 <- brit.act$zYear[brit.act$isDatAcc==0 & brit.act$isIOPro == 0]
x2 <- brit.act$zYear[brit.act$isDatAcc==0 & brit.act$isIOPro == 1]
x3 <- brit.act$zYear[brit.act$isDatAcc==1 & brit.act$isIOPro == 0]
x4 <- brit.act$zYear[brit.act$isDatAcc==1 & brit.act$isIOPro == 1]

y1 <- brit.act$isTo[brit.act$isDatAcc==0 & brit.act$isIOPro == 0]
y2 <- brit.act$isTo[brit.act$isDatAcc==0 & brit.act$isIOPro == 1]
y3 <- brit.act$isTo[brit.act$isDatAcc==1 & brit.act$isIOPro == 0]
y4 <- brit.act$isTo[brit.act$isDatAcc==1 & brit.act$isIOPro == 1]

# Try to identify inflection point
test <- data.frame(year=seq(1200,1700,1))
test$zYear <- (test$year - mean(brit.act$year))/sd(brit.act$year)
diffYears <- 25/sd(brit.act$year)

for (i in 1:dim(test)[1]) {
	test$meanBef[i] <- mean(y3[x3<(test$zYear[i]-diffYears/2)&(x3>=test$zYear[i]-(diffYears+diffYears/2))],na.rm=T)
	test$meanSelf[i] <- mean(y3[x3<=(test$zYear[i]+diffYears/2)&x3>=(test$zYear[i]-diffYears/2)],na.rm=T)
	test$meanAft[i] <- mean(y3[x3>(test$zYear[i]+diffYears/2)&x3<=(test$zYear[i]+diffYears+diffYears/2)],na.rm=T)
}

test$BefDiff<-test$meanSelf-test$meanBef
test$AftDiff<-test$meanSelf-test$meanAft
test$SumDiff<-test$BefDiff+test$AftDiff

ryGuess<-test[which.max(test$SumDiff),'zYear']
#     year      zYear meanBef meanSelf   meanAft BefDiff   AftDiff  SumDiff
# 162 1361 -0.8612881     0.4        1 0.5208333     0.6 0.4791667 1.079167
test <- data.frame(year=seq(1200,1700,1))
test$zYear <- (test$year - mean(brit.act$year))/sd(brit.act$year)
diffYears <- 25/sd(brit.act$year)

for (i in 1:dim(test)[1]) {
	test$meanBef[i] <- mean(y4[x4<(test$zYear[i]-diffYears/2)&(x4>=test$zYear[i]-(diffYears+diffYears/2))],na.rm=T)
	test$meanSelf[i] <- mean(y4[x4<=(test$zYear[i]+diffYears/2)&x4>=(test$zYear[i]-diffYears/2)],na.rm=T)
	test$meanAft[i] <- mean(y4[x4>(test$zYear[i]+diffYears/2)&x4<=(test$zYear[i]+diffYears+diffYears/2)],na.rm=T)
}

test$BefDiff<-test$meanSelf-test$meanBef
test$AftDiff<-test$meanSelf-test$meanAft
test$SumDiff<-test$BefDiff+test$AftDiff

ryProGuess<-test[which.max(test$SumDiff),'zYear']

rySD <- abs(ryGuess-ryProGuess)

ryMeans <- mean(c(ryGuess, ryProGuess))

stan.dat <- list(ryMean = ryMeans,
		 ryProMean = ryMeans,
		 rySD = rySD,
		 N1 = length(x1),
		 N2 = length(x2),
		 N3 = length(x3),
		 N4 = length(x4),
		 x1 = x1,
		 x2 = x2,
		 x3 = x3,
		 x4 = x4,
		 y1 = y1,
		 y2 = y2,
		 y3 = y3,
		 y4 = y4)
glm1 <- glm(y1~x1,family='binomial')
glm2 <- glm(y2~x2,family='binomial')
glm3b <- glm(y3[x3>ryGuess]~x3[x3>ryGuess],family='binomial')
glm3a <- glm(y3[x3<ryGuess]~x3[x3<ryGuess],family='binomial')
glm4b <- glm(y4[x4>ryProGuess]~x4[x4>ryProGuess],family='binomial')
glm4a <- glm(y4[x4<ryProGuess]~x4[x4<ryProGuess],family='binomial')

stan.init <- list(ry=ryGuess,
		  rypro=ryProGuess,
		  Int1=coef(glm1)[1],
		  Slope1=coef(glm1)[2],
		  ProInt1=coef(glm2)[1]-coef(glm1)[1],
		  ProSlope1=coef(glm2)[2]-coef(glm1)[2],
		  RTInt1=coef(glm3a)[1]-coef(glm1)[1],
		  RTSlope1=coef(glm3a)[2]-coef(glm1)[2],
		  Slope2=coef(glm3b)[2],
		  ProSlope2=coef(glm4b)[2]-coef(glm3b)[2],
		  ProRTInt1=NA,
		  ProRTSlope1=NA)

stan.init$ProRTInt1 <- coef(glm4a)[1]-(stan.init$Int1+stan.init$ProInt1+stan.init$RTInt1)
stan.init$ProRTSlope1 <- coef(glm4a)[2]-(stan.init$Slope1+stan.init$ProSlope1+stan.init$RTSlope1)

fit <- stan(file = 'ToReanalysis.stan', data=stan.dat,
	    iter = 7000, chains = 4, warmup = 4000,
	    init=list('a'=stan.init,'b'=stan.init,'c'=stan.init,'d'=stan.init),
	    seed=12304,
	    verbose = T)

saveRDS(fit,file='ToRaising-Stan-Fit2.RDS')
print(fit, digits=1)
# Inference for Stan model: ToReanalysis.
# 4 chains, each with iter=7000; warmup=4000; thin=1; 
# post-warmup draws per chain=3000, total post-warmup draws=12000.
# 
#                mean se_mean  sd    2.5%     25%     50%     75%   97.5% n_eff
# ry             -0.9     0.0 0.0    -0.9    -0.9    -0.9    -0.8    -0.8   116
# rypro          -0.8     0.0 0.1    -0.9    -0.8    -0.8    -0.7    -0.7    15
# Int1            7.3     0.1 0.6     6.2     6.8     7.3     7.7     8.7   111
# Slope1          4.2     0.0 0.4     3.5     3.9     4.1     4.4     5.0   108
# ProInt1        -1.4     0.1 0.9    -3.1    -2.0    -1.4    -0.8     0.5    92
# ProSlope1       0.0     0.1 0.7    -1.3    -0.5     0.0     0.4     1.5    97
# RTInt1         -3.3     0.1 0.8    -4.9    -3.9    -3.3    -2.7    -1.8   130
# RTSlope1       -0.5     0.1 0.6    -1.6    -0.9    -0.5    -0.1     0.6   128
# ProRTInt1       1.2     0.1 1.1    -0.7     0.4     1.1     1.8     3.4    90
# ProRTSlope1     1.5     0.1 1.0    -0.3     0.8     1.4     2.1     3.6    87
# Slope2         -1.8     0.0 0.1    -2.1    -1.9    -1.8    -1.7    -1.5   169
# ProSlope2      -0.1     0.0 0.2    -0.6    -0.3    -0.1     0.0     0.3    92
# Int2           -0.7     0.0 0.1    -0.9    -0.8    -0.7    -0.7    -0.6   630
# ProInt2        -2.2     0.0 0.1    -2.4    -2.3    -2.2    -2.1    -2.0   953
# lp__        -1308.2     0.2 2.7 -1314.3 -1309.7 -1307.8 -1306.2 -1304.1   148
#             Rhat
# ry           1.0
# rypro        1.2
# Int1         1.0
# Slope1       1.0
# ProInt1      1.1
# ProSlope1    1.0
# RTInt1       1.0
# RTSlope1     1.0
# ProRTInt1    1.0
# ProRTSlope1  1.0
# Slope2       1.0
# ProSlope2    1.0
# Int2         1.0
# ProInt2      1.0
# lp__         1.0
# 
# Samples were drawn using NUTS(diag_e) at Tue Nov  8 16:28:49 2016.
# For each parameter, n_eff is a crude measure of effective sample size,
# and Rhat is the potential scale reduction factor on split chains (at 
# convergence, Rhat=1).
# NULL
plot(fit)

a <- as.data.frame(extract(fit))

reanalysis.diff <- (a$rypro*sd(brit.act$year)+mean(brit.act$year)) - (a$ry*sd(brit.act$year)+mean(brit.act$year))
quantile(reanalysis.diff,c(0.025,.5,.975))
#        2.5%         50%       97.5% 
# -0.07877529  0.07982899  0.18304503 
mean(reanalysis.diff)
# [1] 0.06637736

pred <- expand.grid(year = min(brit.act$year):max(brit.act$year),
                    Order = c('TR','RT'),
                    IO = c('Noun','Pronoun'))

pred$x <- (pred$year - mean(brit.act$year))/sd(brit.act$year)

ry = mean(a$ry)
rypro = mean(a$rypro)
Int1 = mean(a$Int1) 
Slope1 = mean(a$Slope1)
ProInt1 = mean(a$ProInt1)
ProSlope1 = mean(a$ProSlope1)
RTInt1 = mean(a$RTInt1)
RTSlope1 = mean(a$RTSlope1)
ProRTInt1 = mean(a$ProRTInt1)
ProRTSlope1 = mean(a$ProRTSlope1)
Slope2 = mean(a$Slope2)
ProSlope2 = mean(a$ProSlope2)
Int2 = (Int1 + Slope1 * ry + RTInt1 + RTSlope1 * ry) - Slope2 * ry
ProInt2 = (Int1 + Slope1 * rypro + 
             RTInt1 + RTSlope1 * rypro + 
             ProInt1 + ProSlope1 * rypro +
             ProRTInt1 + ProRTSlope1 * rypro) - (Slope2 * rypro + ProSlope2 * rypro)

pred$z <- NA

pred$z[pred$Order=='TR'&pred$IO=='Noun'] <- Int1 + Slope1 * pred$x[pred$Order=='TR'&pred$IO=='Noun']
#pred$z[pred$Order=='TR'&pred$IO=='Noun'&pred$x>=ry] <- 10
pred$z[pred$Order=='TR'&pred$IO=='Pronoun'] <- Int1 + Slope1 * pred$x[pred$Order=='TR'&pred$IO=='Pronoun'] + 
      ProInt1 + ProSlope1 * pred$x[pred$Order=='TR'&pred$IO=='Pronoun']
#pred$z[pred$Order=='TR'&pred$IO=='Pronoun'&pred$x>=ry] <- 10
pred$z[pred$Order=='RT'&pred$IO=='Noun'] <- Int1 + Slope1 * pred$x[pred$Order=='RT'&pred$IO=='Noun'] + RTInt1 + 
      RTSlope1 * pred$x[pred$Order=='RT'&pred$IO=='Noun']
pred$z[pred$Order=='RT'&pred$IO=='Noun'&pred$x>=ry] <- Int2 + Slope2 * pred$x[pred$Order=='RT'&pred$IO=='Noun'&pred$x>=ry]
pred$z[pred$Order=='RT'&pred$IO=='Pronoun'] <- Int1 + Slope1 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'] + 
      RTInt1 + RTSlope1 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'] + 
      ProInt1 + ProSlope1 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'] + 
      ProRTInt1 + ProRTSlope1 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun']
pred$z[pred$Order=='RT'&pred$IO=='Pronoun'&pred$x>=rypro] <- ProInt2 + Slope2 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'&pred$x>=rypro] + ProSlope2 * pred$x[pred$Order=='RT'&pred$IO=='Pronoun'&pred$x>=rypro]

pred$isTo <- unlogit(pred$z)

brit.act$era <- as.numeric(as.character(cut(brit.act$year,breaks=seq(800,1950,50),labels=seq(825,1925,50))))
brit.act.points<-group_by(brit.act,era,IO,isDatAcc)%>%summarise(isTo=mean(isTo),n=n())

brit.act$Order<-factor(brit.act$isDatAcc)
levels(brit.act$Order)<-c('Theme-recipient','Recipient-theme')

levels(pred$Order)<-c('Theme-recipient','Recipient-theme')
levels(pred$IO)<-c('Recipient Noun','Recipient Pronoun')

bpoints<-group_by(brit.act,era,IO,Order)%>%summarise(isTo=mean(isTo),n=n())
pdf(file='../../images/to-use.pdf')
ggplot(bpoints,aes(era,isTo,colour=factor(Order)))+geom_point(aes(size=n))+geom_line(data=pred,aes(x=year))+
  scale_x_continuous(name='Year of Composition',breaks=seq(900,1900,100),labels=seq(900,1900,100))+
  scale_y_continuous(name="% `To'-marking",breaks=c(0,.2,.4,.5,.6,.8,1),labels=c('0%','20%','40%','50%','60%','80%','100%'))+
  scale_size_continuous(name="Number of Tokens/50yrs")+
  scale_colour_discrete(name="Word Order")+
  scale_linetype_discrete(name="Recipient Status")+
  scale_shape_discrete(name="Recipient Status")+facet_wrap(~IO)
dev.off()

