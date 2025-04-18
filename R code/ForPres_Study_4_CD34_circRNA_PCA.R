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

load("./Study_RData/Study4_CE2_Output.RData", verbose = T)

plotcolors <- c( "blue3", "springgreen4") 

names(control4_rawCounts)[2:ncol(control4_rawCounts)] <- paste("C4", names(control4_rawCounts)[2:ncol(control4_rawCounts)], sep="_" )
names(disease4_rawCounts)[2:ncol(disease4_rawCounts)] <- paste("D4", names(disease4_rawCounts)[2:ncol(disease4_rawCounts)], sep="_" )


cohort4 <- control4_rawCounts %>% full_join(disease4_rawCounts, by="ID")
cohort4[is.na(cohort4)] <- 0
cohort4 <- FILTER_LOW_READ_FEATURES(cohort4, 2, 0.25)

plotids <- c(rep("MDS",ncol(disease4_rawCounts)-1), 
             rep("Control", ncol(control4_rawCounts)-1))

#PCA with filtered and normalized counts
cohort_4_normCounts <- DESeq2_NORMALIZATION(cohort4)

title<-""
pca<- GET_PCA(GET_DF_FOR_PCA(cohort_4_normCounts, plotids),title,"", FALSE, plotcolors)
pca
svg(filename="./plots/pca_study_4_circRNAs_normalized.svg", width=10, height=7, pointsize=12)
grid.arrange(pca, nrow=1)
dev.off()
