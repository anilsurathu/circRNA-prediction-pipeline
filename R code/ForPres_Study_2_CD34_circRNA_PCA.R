#setwd("G:/circRNA/circRNA HSCs/Statistical Analysis")
.libPaths('C:/R_Packages')
rm(list = ls()) 
library(tidyr)
library(dplyr)
library(ggplot2)
library(grid)
library(RColorBrewer)
library(ggplotify)
library(gridExtra)
library(ggfortify)
library(DESeq2)
source("utility_functions.R")

load("./Study_RData/Study2_CE2_Output.RData", verbose = T)

plotcolors <- c( "blue3", "springgreen4", "orangered1") 

names(control2_rawCounts)[2:ncol(control2_rawCounts)] <- paste("C", names(control2_rawCounts)[2:ncol(control2_rawCounts)], sep="_" )
names(pretreat2_rawCounts)[2:ncol(pretreat2_rawCounts)] <- paste("PRE", names(pretreat2_rawCounts)[2:ncol(pretreat2_rawCounts)], sep="_" )
names(posttreat2_rawCounts)[2:ncol(posttreat2_rawCounts)] <- paste("POST", names(posttreat2_rawCounts)[2:ncol(posttreat2_rawCounts)], sep="_" )

#PCA with raw counts. 
cohort2 <- control2_rawCounts %>% full_join(pretreat2_rawCounts, by="ID")
cohort2 <- cohort2 %>% full_join(posttreat2_rawCounts, by="ID")

cohort2[is.na(cohort2)] <- 0
cohort2 <- FILTER_LOW_READ_FEATURES(cohort2, 2, 0.25)

plotids <- c(rep("Pre-treat",ncol(pretreat2_rawCounts)-1), 
             rep("Post-treat",ncol(posttreat2_rawCounts)-1), 
             rep("Control", ncol(control2_rawCounts)-1))

#PCA with filtered and normalized counts
cohort2<- cbind(ID=cohort2[,1], cohort2[,2:ncol(cohort2)] +1 ) 
cohort_2_normCounts <- DESeq2_NORMALIZATION(cohort2)

title<-""
pca<- GET_PCA(GET_DF_FOR_PCA(cohort_2_normCounts, plotids),title,"", FALSE, plotcolors)
pca
svg(filename="./plots/pca_study_2_cohort_2_circRNAs_normalized.svg", width=10, height=7, pointsize=12)
grid.arrange(pca, nrow=1)
dev.off()
