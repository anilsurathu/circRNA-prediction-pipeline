#$ -cwd
#$ -l h_rt=048:00:00
#$ -l h_vmem=2G
#$ -S /bin/sh
#$ -P CDERID100
#$ -j y
#$ -o sysout
#$ -N align_STAR_PE
#$ -pe thread 23 

################
# Example: qsub align_STAR.sh <prefix> <cohort> <fastq file 1> <fastq file 2>
################

echo "Running job $JOB_NAME ($JOB_ID) on $HOSTNAME"

BASE=/scratch/anil.surathu/apps
export PATH=$BASE/STAR_v2_7_3a:$PATH

PREFIX=$1
COHORT=$2
FASTQ1=$3
FASTQ2=$4

INDEXDIR=$PWD/refgenome/hg38_STAR_index
OUTDIR=$PWD/output/align/$COHORT/$PREFIX/
mkdir -p $OUTDIR


time STAR --runMode alignReads \
          --outSAMtype BAM SortedByCoordinate \
          --outReadsUnmapped Fastx \
          --outSJfilterOverhangMin 15 15 15 15 \
          --alignSJoverhangMin 15 \
          --alignSJDBoverhangMin 15 \
          --outFilterMultimapNmax 20 \
          --outFilterScoreMin 1 \
          --outFilterMatchNmin 1 \
          --outFilterMismatchNmax 2 \
          --chimSegmentMin 15 \
          --chimScoreMin 15 \
          --chimScoreSeparation 10 \
          --chimJunctionOverhangMin 15 \
          --runThreadN $NSLOTS \
          --genomeDir $INDEXDIR \
          --readFilesCommand gunzip -c \
          --outFileNamePrefix $OUTDIR \
          --readFilesIn $FASTQ1 $FASTQ2
          

       
       
       




