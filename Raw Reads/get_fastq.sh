#!/bin/bash

# Load the module to download sequence data from NCBI Sequence Read Archive (SRA)
module load SRAtoolkit/2.11

# Accession list for the sequnces
acc_list_file='SRR_Acc_List.txt'

# Read line by line from the txt file to download the raw reads 
while read line; do
	echo "$line"
	fastq-dump $line --split-3 --outdir raw_reads
done < $acc_list_file
