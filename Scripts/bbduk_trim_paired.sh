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

module load bbmap/38.93

fastq1=`echo $1 | cut -d ',' -f 1`
fastq2=`echo $1 | cut -d ',' -f 2`
out1=`echo $1 | cut -d ',' -f 3`
out2=`echo $1 | cut -d ',' -f 4`
readlen=`echo $1 | cut -d ',' -f 5`
logdir=`echo $1 | cut -d ',' -f 6`
adapters=`echo $1 | cut -d ',' -f 7`
NCPUS=`echo $1 | cut -d ',' -f 8`

basename=$(basename "$fastq1" | cut -d. -f1)
uniq_basename="${basename::-1}"
logfile=${logdir}/${uniq_basename}trimming.log

# Export the bbmap directory to path to avoid error thrown by bbduk, "******  WARNING! A KMER OPERATION WAS CHOSEN BUT NO KMERS WERE LOADED.  ******
# ******  YOU NEED TO SPECIFY A REFERENCE FILE OR LITERAL SEQUENCE.       ******"
export PATH=$PATH:/apps/bbmap/38.93/opt/bbmap-38.93-0

rm -rf ${logfile}

bbduk.sh -Xmx6g \
	threads=${NCPUS} \
	in=${fastq1} \
	in2=${fastq2} \
	out=${out1} \
	out2=${out2} \
	ref=${adapters} \
	ktrim=r \
	k=23 \
	mink=11 \
	hdist=1 \
	tpe \
	tbo \
	overwrite=true \
	trimpolya=${readlen} >> ${logfile} 2>&1

