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

sampleid=`echo $1 | cut -d ',' -f 1`
bam=`echo $1 | cut -d ',' -f 2`
cohort=`echo $1 | cut -d ',' -f 3`
gtf=`echo $1 | cut -d ',' -f 4`
strand=`echo $1 | cut -d ',' -f 5`
logfile=`echo $1 | cut -d ',' -f 6`
NCPUS=`echo $1 | cut -d ',' -f 7`

# Provide path to miniconda python bin for conda environment where htseq is installed
# Below, the path is provided for the miniconda3 'rnaseq-de' environment in which I have istalled htseq
export PYTHONPATH=$HOME/miniconda3/envs/rnaseq-de/bin/python

echo $PYTHONPATH

outdir=../${cohort}_htseq-count
out=${outdir}/${sampleid}.counts

mkdir -p ${outdir}
rm -rf ${logfile}

echo "$(date): Running htseq-count to obtain raw counts. Sample ID:${sampleid}, BAM:${bam}, Cohort:${cohort}, Reference:${gtf}, Strand:${strand}, Output:${out}, Log file:${logfile}, NCPUS:${NCPUS}" >> ${logfile} 2>&1 

# Call the htseq-count package
htseq-count -f bam -r pos --mode=union -s ${strand} ${bam} ${gtf} > ${out}
