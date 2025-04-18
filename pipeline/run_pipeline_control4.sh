FPATH=/projects01/paula.hyland/azacytidine/control4
COHORT=control4

#paired
#qsub -N "STAR_A115" align_STAR_PE.sh A115 $COHORT $FPATH/SRX4143107_1.trimmed.fastq.gz $FPATH/SRX4143107_2.trimmed.fastq.gz
qsub -N "STAR_A133" align_STAR_PE.sh A133 $COHORT $FPATH/SRX4143125_1.trimmed.fastq.gz $FPATH/SRX4143125_2.trimmed.fastq.gz
qsub -N "STAR_A135" align_STAR_PE.sh A135 $COHORT $FPATH/SRX4143127_1.trimmed.fastq.gz $FPATH/SRX4143127_2.trimmed.fastq.gz
qsub -N "STAR_A137" align_STAR_PE.sh A137 $COHORT $FPATH/SRX4143129_1.trimmed.fastq.gz $FPATH/SRX4143129_2.trimmed.fastq.gz
qsub -N "STAR_A146" align_STAR_PE.sh A146 $COHORT $FPATH/SRX4143137_1.trimmed.fastq.gz $FPATH/SRX4143137_2.trimmed.fastq.gz
qsub -N "STAR_A159" align_STAR_PE.sh A159 $COHORT $FPATH/SRX4143148_1.trimmed.fastq.gz $FPATH/SRX4143148_2.trimmed.fastq.gz
qsub -N "STAR_A162" align_STAR_PE.sh A162 $COHORT $FPATH/SRX4143151_1.trimmed.fastq.gz $FPATH/SRX4143151_2.trimmed.fastq.gz
qsub -N "STAR_A169" align_STAR_PE.sh A169 $COHORT $FPATH/SRX4143158_1.trimmed.fastq.gz $FPATH/SRX4143158_2.trimmed.fastq.gz

#single 1
# qsub -N "STAR_A115_1" -hold_jid "STAR_A115" align_STAR_SE.sh A115_1 $COHORT $FPATH/SRX4143107_1.trimmed.fastq.gz
qsub -N "STAR_A133_1" -hold_jid "STAR_A133" align_STAR_SE.sh A133_1 $COHORT $FPATH/SRX4143125_1.trimmed.fastq.gz
qsub -N "STAR_A135_1" -hold_jid "STAR_A135" align_STAR_SE.sh A135_1 $COHORT $FPATH/SRX4143127_1.trimmed.fastq.gz
qsub -N "STAR_A137_1" -hold_jid "STAR_A137" align_STAR_SE.sh A137_1 $COHORT $FPATH/SRX4143129_1.trimmed.fastq.gz
qsub -N "STAR_A146_1" -hold_jid "STAR_A146" align_STAR_SE.sh A146_1 $COHORT $FPATH/SRX4143137_1.trimmed.fastq.gz
qsub -N "STAR_A159_1" -hold_jid "STAR_A159" align_STAR_SE.sh A159_1 $COHORT $FPATH/SRX4143148_1.trimmed.fastq.gz
qsub -N "STAR_A162_1" -hold_jid "STAR_A162" align_STAR_SE.sh A162_1 $COHORT $FPATH/SRX4143151_1.trimmed.fastq.gz
qsub -N "STAR_A169_1" -hold_jid "STAR_A169" align_STAR_SE.sh A169_1 $COHORT $FPATH/SRX4143158_1.trimmed.fastq.gz

#single 2
# qsub -N "STAR_A115_2" -hold_jid "STAR_A115" align_STAR_SE.sh A115_2 $COHORT $FPATH/SRX4143107_2.trimmed.fastq.gz
qsub -N "STAR_A133_2" -hold_jid "STAR_A133" align_STAR_SE.sh A133_2 $COHORT $FPATH/SRX4143125_2.trimmed.fastq.gz
qsub -N "STAR_A135_2" -hold_jid "STAR_A135" align_STAR_SE.sh A135_2 $COHORT $FPATH/SRX4143127_2.trimmed.fastq.gz
qsub -N "STAR_A137_2" -hold_jid "STAR_A137" align_STAR_SE.sh A137_2 $COHORT $FPATH/SRX4143129_2.trimmed.fastq.gz
qsub -N "STAR_A146_2" -hold_jid "STAR_A146" align_STAR_SE.sh A146_2 $COHORT $FPATH/SRX4143137_2.trimmed.fastq.gz
qsub -N "STAR_A159_2" -hold_jid "STAR_A159" align_STAR_SE.sh A159_2 $COHORT $FPATH/SRX4143148_2.trimmed.fastq.gz
qsub -N "STAR_A162_2" -hold_jid "STAR_A162" align_STAR_SE.sh A162_2 $COHORT $FPATH/SRX4143151_2.trimmed.fastq.gz
qsub -N "STAR_A169_2" -hold_jid "STAR_A169" align_STAR_SE.sh A169_2 $COHORT $FPATH/SRX4143158_2.trimmed.fastq.gz

#parse
# qsub -N "parse_circex_A115" -hold_jid "STAR_A115" parse_circex.sh A115 $COHORT
qsub -N "parse_circex_A133" -hold_jid "STAR_A133" parse_circex.sh A133 $COHORT
qsub -N "parse_circex_A135" -hold_jid "STAR_A135" parse_circex.sh A135 $COHORT
qsub -N "parse_circex_A137" -hold_jid "STAR_A137" parse_circex.sh A137 $COHORT
qsub -N "parse_circex_A146" -hold_jid "STAR_A146" parse_circex.sh A146 $COHORT
qsub -N "parse_circex_A159" -hold_jid "STAR_A159" parse_circex.sh A159 $COHORT
qsub -N "parse_circex_A162" -hold_jid "STAR_A162" parse_circex.sh A162 $COHORT
qsub -N "parse_circex_A169" -hold_jid "STAR_A169" parse_circex.sh A169 $COHORT

#annotate
# qsub -N "annot_circex_A115" -hold_jid "parse_circex_A115" annotate_circex.sh A115 $COHORT
qsub -N "annot_circex_A133" -hold_jid "parse_circex_A133" annotate_circex.sh A133 $COHORT
qsub -N "annot_circex_A135" -hold_jid "parse_circex_A135" annotate_circex.sh A135 $COHORT
qsub -N "annot_circex_A137" -hold_jid "parse_circex_A137" annotate_circex.sh A137 $COHORT
qsub -N "annot_circex_A146" -hold_jid "parse_circex_A146" annotate_circex.sh A146 $COHORT
qsub -N "annot_circex_A159" -hold_jid "parse_circex_A159" annotate_circex.sh A159 $COHORT
qsub -N "annot_circex_A162" -hold_jid "parse_circex_A162" annotate_circex.sh A162 $COHORT
qsub -N "annot_circex_A169" -hold_jid "parse_circex_A169" annotate_circex.sh A169 $COHORT

