#!/bin/bash


module purge
module load lefse/1.0

# Get the phyla_table_rel_level files
cp ../exports/phyla_table_rel_level_2/phyla_table_rel_level_2.tsv .
cp ../exports/phyla_table_rel_level_3/phyla_table_rel_level_3.tsv .
cp ../exports/phyla_table_rel_level_4/phyla_table_rel_level_4.tsv .
cp ../exports/phyla_table_rel_level_5/phyla_table_rel_level_5.tsv .
cp ../exports/phyla_table_rel_level_6/phyla_table_rel_level_6.tsv .
cp ../exports/phyla_table_rel_level_7/phyla_table_rel_level_7.tsv .

# Generate the sample list with conditions
cut ../metadata.tsv -f 1,2 > sample_list_type.tsv

# Get the correct format to run LEfSe
python rel_format.py -i sample_list_type.tsv -r phyla_table_rel_level_2.tsv -o rel_level_2.tsv
python rel_format.py -i sample_list_type.tsv -r phyla_table_rel_level_3.tsv -o rel_level_3.tsv
python rel_format.py -i sample_list_type.tsv -r phyla_table_rel_level_4.tsv -o rel_level_4.tsv
python rel_format.py -i sample_list_type.tsv -r phyla_table_rel_level_5.tsv -o rel_level_5.tsv
python rel_format.py -i sample_list_type.tsv -r phyla_table_rel_level_6.tsv -o rel_level_6.tsv
python rel_format.py -i sample_list_type.tsv -r phyla_table_rel_level_7.tsv -o rel_level_7.tsv

lefse-format_input.py rel_level_2.tsv rel_level_2.in -c 1 -u 2 -o 1000000
run_lefse.py rel_level_2.in rel_level_2.res
lefse-plot_res.py rel_level_2.res rel_level_2.png --title 'Taxa enriched in normal vs CRC tumor tissues at phylum level' --dpi 300 


lefse-format_input.py rel_level_3.tsv rel_level_3.in -c 1 -u 2 -o 1000000
run_lefse.py rel_level_3.in rel_level_3.res
lefse-plot_res.py rel_level_3.res rel_level_3.png --title 'Taxa enriched in normal vs CRC tumor tissues at class level' --dpi 300 


lefse-format_input.py rel_level_4.tsv rel_level_4.in -c 1 -u 2 -o 1000000
run_lefse.py rel_level_4.in rel_level_4.res
lefse-plot_res.py rel_level_4.res rel_level_4.png --title 'Taxa enriched in normal vs CRC tumor tissues at order level' --dpi 300 


lefse-format_input.py rel_level_5.tsv rel_level_5.in -c 1 -u 2 -o 1000000
run_lefse.py rel_level_5.in rel_level_5.res
lefse-plot_res.py rel_level_5.res rel_level_5.png --title 'Taxa enriched in normal vs CRC tumor tissues at family level' --dpi 300 

    
lefse-format_input.py rel_level_6.tsv rel_level_6.in -c 1 -u 2 -o 1000000
run_lefse.py rel_level_6.in rel_level_6.res
lefse-plot_res.py rel_level_6.res rel_level_6.png --title 'Taxa enriched in normal vs CRC tumor tissues at genus level' --dpi 300 


lefse-format_input.py rel_level_7.tsv rel_level_7.in -c 1 -u 2 -o 1000000
run_lefse.py rel_level_7.in rel_level_7.res
lefse-plot_res.py rel_level_7.res rel_level_7.png --title 'Taxa enriched in normal vs CRC tumor tissues at species level' --dpi 300 


