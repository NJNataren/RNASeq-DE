#!/bin/bash

set -e

# input_file = /home/nnataren/Documents/PhD/Bioinformatics/eQTL_RNAseq/RNASeq-DE/CEPH/url_file/igsr_Utah_residents_CEPH_with_Northern_and_Western_European_ancestry_undefined.tsv


cat igsr_Utah_residents_CEPH_with_Northern_and_Western_European_ancestry_undefined.tsv | awk '{print $1}' | tail +1  > CEPH_url.txt

wget -i CEPH_url.txt
