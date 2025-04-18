#Goal of this script is to hold all reusable functions pertaining to data access and formatting. 

#Adds an ID column composed of gene name, chromosome, start and end coords separated by "_"
ADD_ID <- function(CE2_df)
{
  CE2_df$ID = paste(CE2_df$CE2_geneName, CE2_df$CE2_chrom, CE2_df$CE2_start, CE2_df$CE2_end, sep="_")
  return(CE2_df)
}

#function to read the circExplorer2 output file into a dataframe. 
READ_CE2_OUTPUT <- function(samp_prefix, sampFile)
{
  CE2_colNames <- c("chrom","start","end","name","score","strand","thickStart","thickEnd","itemRgb",
                    "exonCount","exonSizes","exonOffsets","readNumber","circType","geneName","isoformName",
                    "index","flankIntron")
  CE2_colNames <- paste("CE2",  CE2_colNames, sep="_")
  CE2_circRNA<-read.csv(file=sampFile, sep="\t",stringsAsFactors=FALSE)
  names(CE2_circRNA) <- CE2_colNames
  dropcols<- c("CE2_thickStart","CE2_thickEnd","CE2_itemRgb")
  CE2_circRNA <- CE2_circRNA %>% select(-one_of(dropcols))
  
  return(CE2_circRNA)
}

#Builds and returns a circRNA dataframe give the alignment stats file and CE2 output folder.
GET_circRNA_CE2_OUTPUT <- function(ce_output_folder) {
  
  ce_output_files <- list.files(path=ce_output_folder,  recursive = TRUE)
  circRNA_DF <-data.frame()
  
  for(file in ce_output_files)
  {
    f <- unlist(strsplit(file, "/"))
    circRNAs <- ADD_ID(READ_CE2_OUTPUT(f[1], paste(ce_output_folder,f[1], f[2], sep="/")))
    circRNA_DF <- rbind(circRNA_DF, cbind(circRNAs, sampID=f[1]))
  }
  return(circRNA_DF)
}

#Reshape the circRNA output list into a matrix form
RESHAPE_circRNA_CE2_OUTPUT <- function(df)
{
  df_matrix <- df[,c("ID", "sampID", "CE2_readNumber" )]
  df_matrix <- dcast(df_matrix,ID~sampID, fill = 0)
  return(df_matrix)
}