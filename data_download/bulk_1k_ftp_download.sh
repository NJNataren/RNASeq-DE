#!/bin/bash

set -e

################################################
#
# Author : Nathalie Nataren
#
# This simple script will generate a list of ftp links from the sample information files downloaded from
# https://www.internationalgenome.org/data-portal/population/CEU, with Geuvadis selected
# and passes them to wget for bulk download on the Gadi HPC.
# The relevant .tsv file should be located within the data_download directory with this script.
#
################################################


cat igsr_Utah_residents_CEPH_with_Northern_and_Western_European_ancestry_undefined.tsv | awk '{print $1}' | tail +1  > CEPH_url.txt

wget -i CEPH_url.txt
