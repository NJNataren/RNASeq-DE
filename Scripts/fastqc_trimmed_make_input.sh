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

if [ -z "$1" ]
then
	echo "Please run this script with the path to your config file, e.g. sh fastqc_trimmed_make_input.sh cohort.config"
	exit
fi

config=$1
cohort=$(basename "$config" | cut -d'.' -f 1)
logs=./Logs/fastQC_trimmed
INPUTS=./Inputs
unsorted=${INPUTS}/fastqc_trimmed.inputs_unsorted
input_file=${INPUTS}/fastqc_trimmed.inputs
NCPUS=1

mkdir -p ${INPUTS}
mkdir -p ${logs}

rm -rf ${input_file}

while read -r fastq sampleid dataset reference seqcentre platform run_type library; do
	if [[ ! ${fastq} =~ ^#.*$ ]]; then
		basename=$(basename "$fastq" | cut -d. -f1)
		in=../${dataset}_trimmed/${basename}_trimmed.fastq.gz
		logdir=${logs}/${cohort}/${dataset}_trimmed
		logfile=${logdir}/${basename}.log
		out=../${dataset}\_fastQC_trimmed
		bytes=$(ls -s "${in}" | awk '{print $1}')
		in=../${dataset}_trimmed/${basename}_trimmed.fastq.gz
		mkdir -p ${out}
		mkdir -p ${logdir}

		echo "${in},${out},${logfile},${NCPUS},${bytes}" >> ${unsorted}
	fi
done < "${config}"

# Reverse numeric sort bytes, comma delimited unsorted file
sort -rnk 5 -t ',' ${unsorted} > ${input_file}
rm -rf ${unsorted}

echo "Number of tasks: $(wc -l ${input_file} | awk '{print $1}')"
