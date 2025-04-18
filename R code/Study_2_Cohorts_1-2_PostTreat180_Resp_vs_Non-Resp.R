
.libPaths('C:/R_Packages')
rm(list = ls())

library(DESeq2)
library(ggplot2)
library(tidyr)
library(dplyr)
source("utility_functions.R")

load("./Study_RData/Study2_CE2_Output.RData", verbose = T)
posttreat1 <- read.csv("./sample_stats/posttreat1.csv", header=TRUE, stringsAsFactors = FALSE)
posttreat2 <- read.csv("./sample_stats/posttreat2.csv", header=TRUE, stringsAsFactors = FALSE)

#Combine pretreat samples from cohort 1 & 2.
#Remove 180 day, AML, PR (partial response) & NA (no reponse) samples. 
samples <- rbind(posttreat1, posttreat2)
samples <- samples[,c("cohort", "samples","disease", "response", "treat.time" , "sex", "median_age")]
names(samples) <- c("cohort", "patient_id","disease", "response", "treatment",  "sex", "age")
samples <- samples[samples$disease!="AML", ]
samples <- samples[samples$treatment=="180", ]
samples <- samples[!is.na(samples$response), ]
samples <- samples[samples$response != "PR", ]
samples$cohort <- factor(samples$cohort)

countData <- posttreat1_rawCounts %>% full_join(posttreat2_rawCounts, by="ID")
countData[is.na(countData)] <- 0
countData <- countData[, c("ID", samples$patient_id)]
nrow(countData)

#apply pre-filtering
# countData <- FILTER_LOW_READ_FEATURES(countData, 2, 0.25)
# nrow(countData)

#DESeq2
countData <-countData[order(countData$ID),]

#add a pseudo count of 1 if needed. 
countData <- cbind(circID=countData[,1], countData[,2:ncol(countData)] + 1 )

#condition only.
dds <- DESeqDataSetFromMatrix(countData=countData,
                              colData=samples,
                              design=~response, tidy = TRUE)
#condition with gender. 
# dds <- DESeqDataSetFromMatrix(countData=countData,
#                               colData=samples,
#                               design=~sex+response, tidy = TRUE)
dds <- DESeq(dds)
#Set independentFiltering to false if you want to turn off deseq2's automatic filtering. 
res <- results(dds, tidy=TRUE, pAdjustMethod = "BH", contrast=c("response", "CR", "FAIL"),independentFiltering=TRUE)
res[res$padj <= 0.05 & !is.na(res$padj), ]

#following two are significant if you use pre-filtering and condition only. 
#                                     baseMean log2FoldChange    lfcSE      stat      pvalue       padj
# 1    ANKRD36B_chr2_97507563_97515945  2.56039      -2.100230 0.7609549 -2.759993 0.005780261 0.04913222
# 7 LINC00869_chr1_149655698_149669310  3.59112      -2.436614 0.7441563 -3.274331 0.001059123 0.01800510
