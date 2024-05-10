#!/bin/bash

set -e

# Specify the manifest file to be used and run with bash command on Gadi i.e., $bash bulk_1k-ftp_download.sh
# Replace <population_manifest.txt> with the desired _manifest.txt file e.g., ceph_test_manifest file
# and replace <population> with the relevant population i.e., CEPH_test
cat <population_manifest.txt> | awk '{print $4}' | tail -n +2  > <population>_url.txt

wget -i <population>_url.txt
