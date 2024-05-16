#!/bin/bash

set -e

#########################################################
#
# Platform: NCI Gadi HPC
#
# Author: Tracy Chew
# tracy.chew@sydney.edu.au
#
# If you use this script towards a publication, please acknowledge the
# Sydney Informatics Hub (or co-authorship, where appropriate).
#
# Suggested acknowledgement:
# The authors acknowledge the scientific and technical assistance
# <or e.g. bioinformatics assistance of <PERSON>> of Sydney Informatics
# Hub and resources and services from the National Computational
# Infrastructure (NCI), which is supported by the Australian Government
# with access facilitated by the University of Sydney.
#
#########################################################

# Set the PBS_O_WORKDIR to the scripts directory where the jobs are being queued from
PBS_O_WORKDIR=/scratch/bt64/nn8573/eqtl/ceph/RNASeq-DE/Scripts
cd "${PBS_O_WORKDIR}"

# Activate conda base to access rseqc
export PATH=$HOME/miniconda3/envs/rnaseq-de/bin:$PATH
source activate rnaseq-de

# Export the rnaseq-de conda env python to the shell
export PYTHONPATH=$HOME/miniconda3/envs/rnaseq-de/bin/python

if [ -z "$1" ]
then
        echo "Please provide the path to the directory containing BAMs, e.g. sh infer_experiment_final_bams.sh ../cohort_final_bams"
        exit
fi

bamdir=$(echo $1 | sed 's/\/$//')
outfileprefix=$(basename $bamdir)
refbed=../Reference/GRCh38/Homo_sapiens.GRCh38.111.bed
outdir=../QC_reports/${outfileprefix}_infer_experiment
outfile=${outdir}/${outfileprefix}.txt

logdir=./Logs/infer_experiment

mkdir -p ${logdir} ${outdir}

# infer_experiment.sh in parallel on login node (48 parallel tasks)
ls $bamdir/*final.bam | xargs -i -n 1 -P 48 sh -c 'sample=$(basename {} | cut -d'.' -f1) && dir=$(basename $(dirname {} )) && infer_experiment.py -r ../Reference/GRCh38/Homo_sapiens.GRCh38.111.bed -i {} 1>../QC_reports/${dir}_infer_experiment/${sample}.txt 2>./Logs/infer_experiment/$sample.log'

# Collect results into matrix table
echo "#FILE REVERSE FORWARD" > ${outfile}
ls ${outdir}/*txt | grep -v ${outfile} | xargs -i sh -c 'file=$(basename {}) && reverse=$(grep "1+-,1-+,2++,2--" {} | cut -d':' -f2) && forward=$(grep "1++,1--,2+-,2-+" {}| cut -d':' -f2) && echo $file $reverse $forward' >> ${outfile}
