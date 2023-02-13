1. Get raw reads sequnces (fastq): reference files can be found in the [Raw Reads folder](https://github.com/clayton-lab/BugSeq-er/tree/main/Raw%20Reads)
    - Create a directory for this analysis with a project-specific title (e.g., 'PhilZoo_date'). 
    - Copy get_fastq.sh to the project directory to retrieve sequnces from NCBI Sequence Read Archive (SRA)
        * Before running the script, go to the SRA Run Selector (https://www.ncbi.nlm.nih.gov/Traces/study/)
        * Insert the Sequence Read Archive (SRA) BioProject ID as an accession
        * Select the samples you want then downlowd the accession list and metadata for the selected samples
    - Check the accession list file and name it 'SRR_Acc_List.txt'. Each line should have one accession number.
    - Finally, run 'bash get_fastq.sh' in the project directory.

2. Pre-process the data using FastQC and MultiQC: reference files can be found in the [Pre-process folder](https://github.com/clayton-lab/BugSeq-er/tree/main/Pre-process)
    - Create project subdirectory 'qc' within the project directory, then create a subdirectory of 'qc' named 'script_output'
    - Copy get_sample_name_dic.sh and qc.slurm to the project directory
    - Run 'bash get_sample_name_dic.sh > sample_dic.txt' in the project directory to retrieve the sample list where each accession number is space-delimited
    - Copy the contents of sample_dic.txt to qc.slurm for the 'sample_name' variable 
    - Edit the paths in lines 8, 9, 20, 28, and 29, then run 'sbatch qc.slurm'

3. Run Qiime2: reference files can be found in the [qiime2 folder](https://github.com/clayton-lab/BugSeq-er/tree/main/qiime2)
    - Create project subdirectory 'qiime2'
    - Ensure QIIME2 version 2021.4 installed by running 'module load qiime2/(most recent package)
        * All HCC module names and versions can be found [in the HCC documentation](https://hcc.unl.edu/docs/applications/modules/available_software_for_crane/)
    - Download the latest release for the reference SILVA database to your local computer [here](https://docs.qiime2.org/2020.6/data-resources/#taxonomy-classifiers-for-use-with-q2-feature-classifier)
        * To download, select the "Silva 138 99% OTUs full-length sequences" under the "Naive Bayes classifiers trained on:" section 
    - Upload the reference SILVA database to the qiime2 subdirectory
    - Copy metadata.tsv and manifest to the 
    - Bulid the manifest file using the 'manifest_builder.py' by specifiying -i acc_list_file -p path_to_the_raw_reads
    - Get the metadata.tsv in the right formate [(example is provided).](https://github.com/clayton-lab/BugSeq-er/blob/main/sample_metadata.tsv)
    - Part 1 before running 'part1.slurm' check the following: 
        * Edit the path in line 8, 9, and 20.
        * If your data contain adapter sequnces removed them using cutadapt line 35-40 (make sure to change line 37, and 38 with your adapter sequnces).
        * If your data dosen't contain adapter sequnces then comment out lines 35-44.
        * Finally, run the 'sbatch part1.slurm'
    - Part 2 before running 'part2.slurm' check the following: 
        * Edit the path in line 8, 9, and 28.
        * In addition, look at the demux visulasation in the artifacts directory to assign trimming and truncating values.
        * If adapter sequnces were removed, look at the 'paired-end-demux-trimmed.qzv'
        * If no adapter sequnces were removed, look at the 'demux.qzv' and replace line 33 with '--i-demultiplexed-seqs artifacts/demuxed-paired-end.qza'.
        * Assign values for the dada2 denoising step line 18-21.
        * Make sure edit and check the file name of the reference database line 72.
        * Finally, run the 'sbatch part2.slurm'
    - Part 3 before running 'part3.slurm' check the following: 
        * Edit the path in line 8, 9, and 15.
        * Look at the Interactive Sample Detail for the 'table-viz.qzv' in the artifacts directory in order to assign sampling depth value.
        * Once a sampling depth value was chosen add it to line 29.
        * Make sure that there is no directory called 'core-metrics-results'.
        * Finally, run the 'sbatch part3.slurm'
    - Normalization using SRS (scaling with ranked subsampling) method:
        * First, download the amplicon sequence variant (ASV) or the operational taxonomic unit (OTU) found in the artifacts directory 'table.qza'. 
        * Second, upload the 'table.qza' to the SRS Shiny app (https://vitorheidrich.shinyapps.io/srsshinyapp/) in order to choose a sampling depth (Cmin) or the normalization cut-off value.
        * It is best to choose a Cmin which doesn’t result in eliminating so many samples.
        * Once a Cmin value was chosen add it to line 7 in the 'normalized_srs.sh' script.
        * Finally, run the 'bash normalized_srs.sh' from the 'qiime2' directory.

4. Create relative abundance plots (heatmap and barplot)- files can be found in the [R folder](https://github.com/clayton-lab/BugSeq-er/tree/main/R)
    - First, install R version 4.1.2 and create a directory called 'qiime2_output'.
        * Note * At this time, HCC does not support the R packages needed for this step
    - Second downlowd the 'Heatmap-barplot.R', 'metadata.tsv', 'table.qza', 'taxonomy.qza' to the 'qiime2_output' directory.
    - Edit the path in line 3 from the 'Heatmap-barplot.R' script.
    - Install both the 'tidyverse' package and the 'qiime2R' package.
    - Then run the rest of the code in the script.

5. Run sub-analysis: LEfSe, and PICRUSt2
    - LEfSe analysis steps- files can be found in the [LEfSe folder](https://github.com/clayton-lab/BugSeq-er/tree/main/LEfSe)
        * First, install LEfSe version 1.0.
        * Make a sub-directory to the 'qiime2' called 'lefse'.
        * Go to the lefse directory 'cd lefse' and make sure both 'format_rel_level.sh' and 'rel_format.py' are available in the directory.
        * Before running the 'format_rel_level.sh' script make sure to the edit the title for the plots that will be created (line 28, 33, 38, 43, 48, and 53).
        * Finally, run the 'format_rel_level.sh'
    - PICRUSt2 analysis steps- files can be found in the [PICRUSt2 folder](https://github.com/clayton-lab/BugSeq-er/tree/main/PICRUSt2)
        * First, install PICRUSt2 version 2.4.
        * Make a sub-directory to the 'qiime2' called 'picrust'.
        * Go to the picrust directory 'cd picrust' and make sure 'picrust2.slurm'is available in the directory.
        * Before running the 'picrust2.slurm' script make sure to the edit the path in line 6, 9, 13, 16, and 19.
        * Once the scripted finish create a directory called 'vis-lefse', 'cd vis-lefse' and make sure both 'format_pathway_abun.sh', and 'pathway_format.py' are available in the directory.
        * The 'format_pathway_abun.sh' is used to create a visualization for PICRUSt abundance pathway.
        * Before running the 'format_pathway_abun.sh' script make sure to the edit the path in line 6 and line 20 which contain the title for the plot.
        * Edit all paths and ensure the correct line for class, subclass, and subject are selected
        * Finally, run the 'format_pathway_abun.sh'.
        
6. Running correlation and statistical analysis: alpha and beta group significant, and differential abundance (ANCOM)
    - Alpha and beta group significant- files can be found in the [Stat folder](https://github.com/clayton-lab/BugSeq-er/tree/main/Stat)
        * Make a sub-directory to the 'qiime2' called 'stat' and make sure it included 'stat.slurm' and a sub-dirctury called 'script_output'.
        * Before running the 'stat.slurm' edit the path in line 8, 9, and 15.
        * Change the '--m-metadata-column' for the beta-group-significance with your metadata column (line 44, 50, 56, 62, 68, 74, 81, and 87).
        * Finally, run the 'sbatch stat.slurm'
    - Differential abundance (ANCOM)- files can be found in the [ANCOM folder](https://github.com/clayton-lab/BugSeq-er/tree/main/ANCOM)
        * Make a sub-directory to the 'qiime2' called 'ancom' and make sure it included 'ancom.sh'.
        * Before running the 'ancom.sh' script edit the path in line 5.
        * Change the 'qiime composition ancom' functions with your metadata column (line 21, 39, 57, 74, 91, and 108).
        * Finally, run the 'bash ancom.sh'.
