---
title: "config_file_make"
author: "Nathalie Nataren"
date: "2024-04-22"
---

# The following script will generate a .config file used by various software packages (e.g. RSeQC)
# in the RNAseq-DE pipeline (https://github.com/NJNataren/RNASeq-DE)
  
# The Geuvadis Transcriptomic data metadata file was downloaded from https://www.internationalgenome.org/data-portal/population/CEU
# and then selecting the Geuvadis data collection and selecting "mRNA" under "Technologies"  

#Script will run in the following directory structure
#├── data
#│    └── raw_data
#│        └── igsr_Utah_residents_CEPH_with_Northern_and_Western_European_ancestry_undefined.tsv
#│    
#├── output
#│   └── CEPH.config
#├──config_file_make.R

#####################
# Read in .tsv file
#####################

library(tidyverse)

# path to file 
path = "data/raw_data/igsr_Utah_residents_CEPH_with_Northern_and_Western_European_ancestry_undefined.tsv"

# import the .tsv file and store as a data frame
df_import <- read_delim(path, delim = "\t")

# retrieve a list of column types
col_check <- spec(df_import)

# import .tsv with and provide specific column types
df <- read_delim(path, delim = "\t", col_types = col_check)

#######################
# Extract sample names
#######################

# Store the url column as a dataframe, extract sample ID from these
# url_links <- df$url %>% as.data.frame()
# colnames(url_links)<-c("url")

# Extract the Geuvadis identifiers from the URL and split into study, sample and fastq ids
# df$identifier <- str_extract(df$url, "(?<=fastq/).*(?=.fastq.gz)")  
df$identifier <- str_extract(df$url, "(?<=fastq/).*")  
df[c("geuvadis_study_id", "geuvadis_sample_id", "fastq")] <- str_split_fixed(df$identifier, '/', 3)
df$sampleid <-str_extract(df$fastq,".*(?=.fastq.gz)")


# sort by the fastq id 
df <- df[order(df$fastq), ]

###############################
# Create the config data frame
###############################

# Will need to populate some of columns with the same entry for all rows (DATASET, REFERENCE_GRCh38_GRCm38, 
# SEQUENCING_CENTRE, PLATFORM, RUN_TYPE_SINGLE_PAIRED, LIBRARY)

# to automatically populate rows, count the number of rows (files) in the patient metadata data frame above
metadata_entries <- nrow(df)

# Store the fastq file names to create a new config data frame
FASTQ <- df$fastq %>% data.frame()
colnames(FASTQ) <-c("#FASTQ")

# Store the fastq file names to create a new config data frame
SAMPLEID <- df$sampleid %>% data.frame()
colnames(SAMPLEID) <-c("SAMPLEID")

# Set variables for auto filling of columns
dataset_entry <- c("CEPH")
reference_entry <- c("GRCh38")
seq_centre_entry <-c("Geuvadis")
platform_entry <- c("ILLUMINA")
run_type_entry <- c("PAIRED")
libraries_paired <- metadata_entries/2
#libraries_single <- metadata_entries

# Create DATASET entries based on the number of rows in the metadata data frame 
DATASET <- data.frame(rep(dataset_entry , times = metadata_entries), row.names = NULL)
colnames(DATASET) <- c("DATASET")

# Create REFERENCE_GRCh38_GRCm38 entries based on the number of rows in the metadata data frame 
REFERENCE_GRCh38_GRCm38 <-data.frame(rep(reference_entry, times = metadata_entries), row.names = NULL)
colnames(REFERENCE_GRCh38_GRCm38) <- c("REFERENCE_GRCh38_GRCm38")
  
# Create SEQUENCING_CENTRE entries based on the number of rows in the metadata data frame 
SEQUENCING_CENTRE <-data.frame(rep(seq_centre_entry, times = metadata_entries), row.names = NULL)
colnames(SEQUENCING_CENTRE) <- c("SEQUENCING_CENTRE")

# Create PLATFORM entries based on the number of rows in the metadata data frame 
PLATFORM <-data.frame(rep(platform_entry, times = metadata_entries), row.names = NULL)
colnames(PLATFORM) <- c("PLATFORM")
  
# Create RUN_TYPE_SINGLE_PAIRED entries based on the number of rows in the metadata data frame 
RUN_TYPE_SINGLE_PAIRED <- data.frame(rep(run_type_entry, times = metadata_entries), row.names = NULL)
colnames(RUN_TYPE_SINGLE_PAIRED) <- c("RUN_TYPE_SINGLE_PAIRED")

# Create LIBRARY number entries based on the number of rows in the metadata data frame (divided by 2 if the libraries are paired)

LIBRARY <- data.frame(rep(seq(libraries_paired), each =2))
colnames(LIBRARY) <- c("LIBRARY")

#########################
# Write the config file
#########################

# Concatenate all of the data frames
config <- cbind(
  FASTQ,
  SAMPLEID,
  DATASET,
  REFERENCE_GRCh38_GRCm38,
  SEQUENCING_CENTRE,
  PLATFORM,
  RUN_TYPE_SINGLE_PAIRED,
  LIBRARY
  )

View(config)

# Write .config file as a plain text, tab delimited file
write.table(config,"output/CEPH.config", sep = "\t", row.names = FALSE, quote = FALSE)

# Session and package info

# R version 4.3.3 (2024-02-29)
# Platform: x86_64-pc-linux-gnu (64-bit)
# Running under: Ubuntu 22.04.4 LTS
# 
# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.10.0 
# LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.10.0
# 
# locale:
#   [1] LC_CTYPE=en_AU.UTF-8       LC_NUMERIC=C               LC_TIME=en_AU.UTF-8        LC_COLLATE=en_AU.UTF-8    
# [5] LC_MONETARY=en_AU.UTF-8    LC_MESSAGES=en_AU.UTF-8    LC_PAPER=en_AU.UTF-8       LC_NAME=C                 
# [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=en_AU.UTF-8 LC_IDENTIFICATION=C       
# 
# time zone: Australia/Adelaide
# tzcode source: system (glibc)
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] lubridate_1.9.3 forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4     purrr_1.0.2     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1   
# [9] ggplot2_3.5.0   tidyverse_2.0.0
# 
# loaded via a namespace (and not attached):
#   [1] bit_4.0.5         gtable_0.3.4      crayon_1.5.2      compiler_4.3.3    tidyselect_1.2.1  parallel_4.3.3    scales_1.3.0     
# [8] yaml_2.3.8        fastmap_1.1.1     R6_2.5.1          generics_0.1.3    knitr_1.46        munsell_0.5.1     pillar_1.9.0     
# [15] tzdb_0.4.0        rlang_1.1.3       utf8_1.2.4        stringi_1.8.3     xfun_0.43         bit64_4.0.5       timechange_0.3.0 
# [22] cli_3.6.2         withr_3.0.0       magrittr_2.0.3    digest_0.6.35     grid_4.3.3        vroom_1.6.5       rstudioapi_0.16.0
# [29] hms_1.1.3         lifecycle_1.0.4   vctrs_0.6.5       evaluate_0.23     glue_1.7.0        rsconnect_1.2.2   fansi_1.0.6      
# [36] colorspace_2.1-0  rmarkdown_2.26    tools_4.3.3       pkgconfig_2.0.3   htmltools_0.5.8.1
