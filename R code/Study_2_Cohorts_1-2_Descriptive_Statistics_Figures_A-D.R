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
library(stringi) 
library(reshape2)
source("data_functions.R")
source("utility_functions.R")

# This script will generate four figures that are similar to figure 2 A-D from study 1. 
# CE2 circRNA output from Study 2 Cohorts 1 & 2 control samples is combined and used to generate these figures. 

load("./Study_RData/Study2_CE2_Output.RData", verbose = T)

######## Figure A - Gene and circRNA counts by chromosome ################
#get gene counts for each chromosome from hg38 known gene annotation file
hg38_genes<- read.table('./hg38_annot_DBs/hg38_p12_kg_annot.txt', sep="\t", stringsAsFactors=FALSE)
hg38_genes<- hg38_genes[,c(1,3)]
names(hg38_genes) <- c("gene", "chrom")

chrom <- strsplit(hg38_genes$chrom, "_")
hg38_genes$chrom <-sapply(chrom, `[`, 1)

hg38_genes <- unique(hg38_genes)
hg38_genes_by_chrom <- data.frame(hg38_genes %>% group_by(chrom) %>% tally())
hg38_genes_by_chrom <- hg38_genes_by_chrom[!hg38_genes_by_chrom$chrom %in% c("chrM", "chrUn"),]

hg38_genes_by_chrom$chrom <- substring(hg38_genes_by_chrom$chrom, 4,length(hg38_genes_by_chrom$chrom))
names(hg38_genes_by_chrom) <- c("chrom", "gene_count")

#Get circRNA count data for control 1 and 2. 
dropcols<- c("CE2_readNumber", "sampID", "CE2_name")
control1_unique <- unique(control1_circRNAs %>% select(-one_of(dropcols)))
control2_unique <- unique(control2_circRNAs %>% select(-one_of(dropcols)))
circRNAs <- unique(rbind(control1_unique, control2_unique))

chrom <- strsplit(circRNAs$CE2_chrom, "_")
circRNAs$CE2_chrom <-sapply(chrom, `[`, 1)

circRNA_by_chrom <- data.frame(circRNAs %>% group_by(CE2_chrom) %>% tally())
names(circRNA_by_chrom) <- c("chrom", "circRNA_count")
circRNA_by_chrom$chrom <- substring(circRNA_by_chrom$chrom, 4,length(circRNA_by_chrom$chrom))

coeff <- 10
plot_df <- rbind(data.frame(chrom=hg38_genes_by_chrom$chrom, count=hg38_genes_by_chrom$gene_count, type="genes"), 
                 data.frame(chrom=circRNA_by_chrom$chrom, count=circRNA_by_chrom$circRNA_count*coeff, type="circRNAs"), 
                 data.frame(chrom="Y", count=0, type="circRNAs"))

#sort the dataframe by chromosome number. 
plot_df_XY <- plot_df[plot_df$chrom %in% c("X","Y"),]
plot_df <- plot_df[!plot_df$chrom %in% c("X","Y"),]
plot_df$chrom <- as.numeric(plot_df$chrom)
plot_df$chrom <- factor(plot_df$chrom, levels=names(sort(table(plot_df$chrom), decreasing=FALSE)))
plot_df <- rbind(plot_df,plot_df_XY)

p <- ggplot(data=plot_df, aes(x=chrom, y=count, fill=type)) +
  geom_bar(stat="identity", color="black", position=position_dodge())+
  scale_fill_manual(values=c('grey80','grey50')) + 
  theme(legend.title = element_blank())+ xlab("Chromosome") + 
  scale_y_continuous(name = "No. of Genes", sec.axis = sec_axis(~./coeff, name="Number of CircRNAs"))

svg(filename="./plotsForPres/descriptive_stats_fig_A_counts_by_chromosome.svg", width=16, height=8, pointsize=12)
grid.arrange(p, nrow=1)
dev.off()
################################################################################################

######## Figure B - Putative exons per circRNA################
p <- ggplot(circRNAs, aes(x=CE2_exonCount)) + 
  geom_histogram(binwidth=1, color="darkblue", fill="lightblue") + 
  xlab("No. of exons per circRNA") + ylab("No. of circRNAs") + 
  geom_text(x=50, y=200, label=paste("Mean = ", round(mean(circRNAs$CE2_exonCount),2), sep=""), color="black")

svg(filename="./plotsForPres/descriptive_stats_fig_B_exon_counts.svg", width=10, height=7, pointsize=12)
grid.arrange(p, nrow=1)
dev.off()
################################################################################################

######## Figure C - Putative spliced length################

ex_sizes <- stri_split_fixed(circRNAs$CE2_exonSizes, ',', simplify=T)
ex_sizes <- `dim<-`(as.numeric(ex_sizes), dim(ex_sizes)) 
splice_len <-  data.frame(len=rowSums(ex_sizes, na.rm=T))

p <- ggplot(splice_len, aes(x=len)) + 
  geom_histogram(binwidth=100, color="darkblue", fill="lightblue") + 
  xlab("splice length (nt)") + ylab("No. of circRNAs") + 
  geom_text(x=22000, y=125, label=paste("Mean = ", round(mean(splice_len$len),2), " nt", sep=""), color="black") +
  scale_x_continuous(breaks = seq(0, 22000, by =2000 ))
p
svg(filename="./plotsForPres/descriptive_stats_fig_C_splice_length.svg", width=10, height=7, pointsize=12)
grid.arrange(p, nrow=1)
dev.off()
################################################################################################

######## Figure D - circRNA per gene ################

circRNA_by_gene <- data.frame(circRNAs %>% group_by(CE2_geneName) %>% tally())
names(circRNA_by_gene) <- c("gene", "count")

p <- ggplot(circRNA_by_gene, aes(x=count)) + 
     geom_histogram(binwidth=1, color="darkblue", fill="lightblue", alpha=1, position="identity") + 
     xlab("circRNAs per gene") + ylab("No. of genes") + 
     geom_text(x=12, y=600, label=paste("Mean = ", round(mean(circRNA_by_gene$count),2), sep=""), color="black") +
     geom_text(x=11.8, y=580, label=paste("Max = ", max(circRNA_by_gene$count), sep=""), color="black") + 
     scale_x_continuous(breaks = seq(0, 14, by =2 ))

svg(filename="./plotsForPres/descriptive_stats_fig_D_counts_by_gene.svg", width=7, height=7, pointsize=12)
grid.arrange(p, nrow=1)
dev.off()
################################################################################################



