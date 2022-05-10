#! /bin/bash

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

# Custom - multiplexed sample BAMs were retained

if [ -z "$1" ]
then
	echo "Please provide your config file, e.g. sh bam_stat_make_input.sh /path/to/cohort.config"
	exit
fi

config=$1
cohort=$(basename $config | cut -d'.' -f1)
logdir=./Logs/bam_stat
INPUTS=./Inputs
input_file=${INPUTS}/bam_stat.inputs
bamdir=../${cohort}_final_bams
outdir=../QC_reports/${cohort}_final_bams_bam_stat

mkdir -p ${INPUTS} ${logdir} ${outdir}

rm -rf ${input_file}

bams+=( $(ls $bamdir/*bam) )
for bam in "${bams[@]}"
do
	sampleid=$(basename $bam | cut -d'.' -f1)
	logfile=${logdir}/${sampleid}.log
	out=${outdir}/${sampleid}_bam_stat.txt
	echo "${sampleid},${bam},${logfile},${out}" >> ${input_file}
done

num_tasks=`wc -l ${input_file}| cut -d' ' -f 1`
echo "Number of tasks: ${num_tasks}"
