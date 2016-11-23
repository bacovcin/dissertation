#! /usr/bin/env Rscript
readRDS('../mcmc-runs/ToRaising-Stan-Fit.RDS')
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

