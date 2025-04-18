#$ -cwd
#$ -l h_rt=048:00:00
#$ -l h_vmem=2G
#$ -S /bin/sh
#$ -P CDERID100
#$ -j y
#$ -o sysout
#$ -N annotate_circex
#$ -pe thread 8 

################
# Example: qsub annotate_circex.sh <prefix> <cohort>
################

echo "Running job $JOB_NAME ($JOB_ID) on $HOSTNAME"

source /projects/mikem/applications/centos7/CIRCExplorer2/set-env.sh
conda activate qiime2-2019.4

PREFIX=$1
COHORT=$2

DATADIR=$PWD/refgenome
GENOME=$DATADIR/hg38_p12.fasta
ANNOT=$DATADIR/hg38_p12_kg_annot.txt
BKSPBED=$PWD/output/parse/$COHORT/$PREFIX/backsplice_fusionjuncs.bed
OUTDIR=$PWD/output/annotate/$COHORT/$PREFIX
mkdir -p $OUTDIR

time CIRCexplorer2 annotate -r $ANNOT -g $GENOME -b $BKSPBED -o $OUTDIR/known_circRNA.txt

conda deactivate


