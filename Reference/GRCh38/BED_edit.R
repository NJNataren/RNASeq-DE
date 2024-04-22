# BED file edit
# The bed file was downloaded from the link below, to the UCSC genome browser
# https://genome.ucsc.edu/cgi-bin/hgTables?hgsid=2029405592_igJyKRAGWIvobmB0ZVuJqYODSRTG&clade=mammal&org=Human&db=hg38&hgta_group=genes&hgta_track=wgEncodeGencodeV45&hgta_table=0&hgta_regionType=genome&position=chr7%3A155%2C799%2C529-155%2C812%2C871&hgta_outputType=primaryTable&hgta_outFileName=
# In order to make this BED file work with RSeQC, I need to remove the "chr" prefix in the first column

library(tidyverse)
# df <- read_tsv('data/Homo_sapiens.GRCh38.111.bed', sep= "\t", col_names = FALSE), quote ="" removes any hidden quote characters
bed <- as.data.frame(read.table("data/Homo_sapiens.GRCh38.111.bed", header = FALSE, sep = "\t", stringsAsFactors = FALSE, quote=""))
bed$V1 <-str_remove(bed$V1, "chr")

# setting quotes as false prevents the insertion of ""
write.table(bed,"output/Homo_sapiens.GRCh38.111.bed", sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)

