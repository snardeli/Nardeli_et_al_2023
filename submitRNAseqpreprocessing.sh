#!/bin/bash -l

set -eu

#set -x

# vars
in=$(realpath ../data/raw/)
out=$(realpath ../data/)
reference=$(realpath ../reference)
singularity=$(realpath ../singularity/kogia)
start=2
end=7
sortmerna_fasta=$reference/rRNA/sortmerna/
sortmerna_inx=$reference/rRNA/sortmerna/
trimmomatic_adapter=$reference/Illumina/adapters/TruSeq3-PE.fa
salmon_index=$reference/Arabidopsis-thaliana/AtRTD2/indices/salmon/AtRTD2_QUASI_gentrome_salmon_v1dot4dot0

###Steps of preprocesing script:
##1) (fastQValidator*)
##2) FastQC
##3) SortMeRNA
##4) FastQC
##5) Trimmomatic
##6) FastQC
##7) Salmon
##8) Kallisto*
##9) STAR*
##10) (HTSeq-count*)

# env
#export SINGULARITY_BINDPATH="/scratch:/scratch,/users:/users,/projappl:/projappl"
export SINGULARITY_BINDPATH="/mnt:/mnt"

# run
for f in $(find $in -name "*_1.fq.gz"); do
  bash ../UPSCb-common/pipeline/runRNASeqPreprocessing.sh -s $start -e $end \
  -x $sortmerna_inx -X $sortmerna_fasta \
  -A $trimmomatic_adapter \
  -S $salmon_index \
  proj email $singularity $f ${f/_1.fq.gz/_2.fq.gz} $out
done
