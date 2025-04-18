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

load("./Study_RData/Study3_CE2_Output.RData", verbose = T)

plotcolors <- c( "springgreen4", "orangered1") 


names(pretreat3_rawCounts)[2:ncol(pretreat3_rawCounts)] <- paste("PRE", names(pretreat3_rawCounts)[2:ncol(pretreat3_rawCounts)], sep="_" )
names(posttreat3_rawCounts)[2:ncol(posttreat3_rawCounts)] <- paste("POST", names(posttreat3_rawCounts)[2:ncol(posttreat3_rawCounts)], sep="_" )

#PCA with raw counts. 
cohort3 <- posttreat3_rawCounts %>% full_join(pretreat3_rawCounts, by="ID")


cohort3[is.na(cohort3)] <- 0
cohort3 <- FILTER_LOW_READ_FEATURES(cohort3, 2, 0.25)

plotids <- c(rep("Pre-treat",ncol(pretreat3_rawCounts)-1), 
             rep("Post-treat",ncol(posttreat3_rawCounts)-1)) 
             

#PCA with filtered and normalized counts
cohort3 <- cbind(ID=cohort3[,1], cohort3[,2:ncol(cohort3)] +1 ) 
cohort_3_normCounts <- DESeq2_NORMALIZATION(cohort3)

title<-""
pca<- GET_PCA(GET_DF_FOR_PCA(cohort_3_normCounts, plotids),title,"", FALSE, plotcolors)
pca
svg(filename="./plots/pca_study_3_circRNAs_normalized.svg", width=10, height=7, pointsize=12)
grid.arrange(pca, nrow=1)
dev.off()
