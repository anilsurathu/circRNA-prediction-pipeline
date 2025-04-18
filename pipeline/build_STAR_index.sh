#$ -cwd
#$ -l h_rt=048:00:00
#$ -l h_vmem=2G
#$ -S /bin/sh
#$ -P CDERID100
#$ -j y
#$ -o sysout
#$ -N STAR_index
#$ -pe thread 23 

echo "Running job $JOB_NAME ($JOB_ID) on $HOSTNAME"

BASE=/scratch/anil.surathu/apps
export PATH=$BASE/STAR_v2_7_3a:$PATH


WD=$PWD
OUT=$PWD/refgenome/hg38_STAR_index

DATADIR=$PWD/refgenome
GTF=$DATADIR/knownGenes.gtf
GENOME=$DATADIR/hg38_p12.fasta

APP="STAR --runMode genomeGenerate"

time $APP --runThreadN $NSLOTS --genomeDir $OUT --genomeFastaFiles $GENOME --sjdbGTFfile $GTF





