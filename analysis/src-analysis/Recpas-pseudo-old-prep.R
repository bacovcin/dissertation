#! /usr/bin/env Rscript
pseu <- read.csv('analysis/data/pseudopassives-old.csv')

pseu$isPas <- factor(pseu$selected)
levels(pseu$isPas)<-c(0,1)
pseu$isPas <- as.numeric(as.character(pseu$isPas))


pseu.old <- data.frame(Year=pseu$YoC,Val=pseu$isPas)

save(pseu.old,file='analysis/rdata-tmp/old-pseudopassives.RData')
