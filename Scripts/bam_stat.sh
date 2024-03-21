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

# To use the the miniconda python for a specific conda environment (such as my environment 'rna-seq-de' where
# I have uninstalled software for this pipeline
# the path to the miniconda environment needs to be exported to the bash environment PATH with the line below.
# Provide the name of your environment in the path below
export PYTHONPATH=$HOME/miniconda3/envs/<provide-name-of-conda-environment>/bin/python

sampleid=`echo $1 | cut -d ',' -f 1`
bam=`echo $1 | cut -d ',' -f 2`
logfile=`echo $1 | cut -d ',' -f 3`
out=`echo $1 | cut -d ',' -f 4`

echo "$(date): Running RSeQC's bam_stat.py to collect a summary of alignment metrics. Sample ID:${sampleid}, BAM:${bam}, Log file:${logfile}, Out:${out}" >> ${logfile} 2>&1

# Here, the miniconda python is called to execute the rseqc bam_stat.py script
python $HOME/miniconda3/pkgs/rseqc-5.0.3-py310h4b81fae_0/bin/bam_stat.py -i ${bam} > ${out} 2>${logfile}
