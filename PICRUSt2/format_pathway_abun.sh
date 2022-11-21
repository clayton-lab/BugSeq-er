#!/bin/bash

module purge
module load lefse/1.1

cd /work/claytonlab/ereisher/philzoo2/qiime2/picrust/vis-lefse

# Get the path_abun_unstrat.tsv file
cp /work/claytonlab/ereisher/philzoo2/qiime2/picrust/results/pathways_out/path_abun_unstrat.tsv.gz /work/claytonlab/ereisher/philzoo2/qiime2/picrust/vis-lefse/
gunzip path_abun_unstrat.tsv.gz

# Generate the sample list with conditions
cut /work/claytonlab/ereisher/philzoo2/qiime2/PhilMetadata.tsv -f 1,11 > sample_list_type.tsv

# Get the correct format to run LEfSe
python pathway_format.py -i sample_list_type.tsv -r /work/claytonlab/ereisher/philzoo2/qiime2/picrust/vis-lefse/path_abun_unstrat.tsv -o path_abun_modified.tsv

lefse_format_input.py path_abun_modified.tsv path_abun_modified.in -c 1 -s 2 -u 1 -o 1000000
lefse_run.py /work/claytonlab/ereisher/philzoo2/qiime2/picrust/vis-lefse/path_abun_modified.in path_abun_modified.res
lefse_plot_res.py path_abun_modified.res path_abun_modified.png --title 'Pathway abundance unstrat' --dpi 300 

