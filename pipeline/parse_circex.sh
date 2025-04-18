#$ -cwd
#$ -l h_rt=048:00:00
#$ -l h_vmem=2G
#$ -S /bin/sh
#$ -P CDERID100
#$ -j y
#$ -o sysout
#$ -N parse_circex
#$ -pe thread 8 

################
# Example: qsub parse_circex.sh <prefix> <cohort>
################

echo "Running job $JOB_NAME ($JOB_ID) on $HOSTNAME"

source /projects/mikem/applications/centos7/CIRCExplorer2/set-env.sh
conda activate qiime2-2019.4

PREFIX=$1
COHORT=$2

INDIR=$PWD/output/align/$COHORT/$PREFIX
OUTDIR=$PWD/output/parse/$COHORT/$PREFIX
mkdir -p $OUTDIR

#parse STAR output 
time CIRCexplorer2 parse -b $OUTDIR/backsplice_fusionjuncs.bed -t STAR $INDIR/Chimeric.out.junction

conda deactivate

