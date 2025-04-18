#Goal of this script is to hold all "utility" functions that can be reused. 

#Returns a PCA plot for the dataframe. 
#Dataframe should be transposed with samples as rows and features as columns. 
#First column in the dataframe should be a column named "plotid" that includes the cohort designation, used in legend and colors. 
GET_PCA <- function(df, plot_title, legend_title, withLabels, colorvec) {
  pca.res <-prcomp(df[,2:ncol(df)])
  pca<-autoplot(pca.res, data=df, colour='plotid', size=2) + #, label = TRUE, label.size = 3) +
  labs(colour = legend_title) +
  scale_color_manual(values = colorvec) +
  ggtitle(plot_title)
  if(withLabels)
  {
    pca<- pca + geom_text(aes(label = rownames(df)), size = 2.5, nudge_y = 0.02)
  }
  return (pca)
} 

#transpose the dataframe to plot a PCA. 
GET_DF_FOR_PCA <- function(df, plotids)
{
  rownames(df) <- df[,1]
  df <- df[,2:ncol(df)]
  df <- t(as.matrix(df))
  return(cbind(plotid=plotids, data.frame(df)))
  
}

#method to apply DESeq2 normalization to a dataframe. 
DESeq2_NORMALIZATION <- function(df)
{
  samples <- colnames(df)
  samples <- data.frame(sample=samples[2:length(samples)], cohort=1)

  deseq <- DESeqDataSetFromMatrix(countData=df, colData=samples, design=~1, tidy = TRUE)
  est_sf <- estimateSizeFactors(deseq)
  sf<- sizeFactors(est_sf)
  norm_df <- sweep(df[,2:ncol(df)], 2, sf, `/`)
  norm_df <- cbind(ID=df[,1], norm_df)
  return (norm_df)
}

#method to filter low read count rows. Retain rows if the have at least minCount in at least X percentage of samples.
#percentSamples parameter is a decimal number, for example 0.25 for 25% 
FILTER_LOW_READ_FEATURES <- function(df, minCount, percentSamples)
{
  temp <- df[,2:ncol(df)] >= minCount
  rownames(temp) <- df[,1]
  temp[isTRUE(temp)] <- 1
  retain <- rownames(temp[rowSums(temp) >= ceiling(ncol(temp)*percentSamples),])
  df <- df[ df[,1] %in% retain, ]
  return(df)
}