#!/bin/bash

# Accession list for the sequnces
acc_list_file='SRR_Acc_List.txt'


# Counter
n=0

# Read line by line from the txt file to download the raw reads 
while read line; do
	echo "$line" | tr '\n' ' '
	n=$((n+1))
done < $acc_list_file
