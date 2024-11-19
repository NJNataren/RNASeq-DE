# Genotyping_labelling_and_config_manifest
# Author: Nathalie Nataren
# Contact: nj.nataren@gmail.com

This folder contains the neccessary scripts for generating .config files required by the RNAseq-DE pipeline in the format as shown below:

`#FASTQ	SAMPLEID	DATASET	REFERENCE_GRCh38_GRCm38	SEQUENCING_CENTRE	PLATFORM	RUN_TYPE_SINGLE_PAIRED	LIBRARY
ERR188022_1.fastq.gz	NA12812	CEPH	GRCh38	Geuvadis	ILLUMINA	PAIRED	1`

The genotype_cconfig_manifest_creation_<GOI>_<POPULATION>.Rmd files generate eQTL genotype annotations for all the samples in a RNAseq-DE cohort as shown below:
`Sample	genotype_forward_strand	gender	genotype	population
NA06984	T|T	M	HOMO_ALT	ALL, CEU, EUR
NA06985	T|T	F	HOMO_ALT	ALL, CEU, EUR`

Later revisions will collapse the different .Rmd for popultions into one file.
