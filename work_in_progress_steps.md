1. Get raw reads sequnces (fastq): reference files can be found in the [Raw Reads folder](https://github.com/clayton-lab/BugSeq-er/tree/main/Raw%20Reads)
    - Create a directory for this analysis with a project-specific title (e.g., 'PhilZoo_date'). 
    - Copy get_fastq.sh to the project directory to retrieve sequnces from NCBI Sequence Read Archive (SRA)
        * Before running the script, go to the SRA Run Selector (https://www.ncbi.nlm.nih.gov/Traces/study/)
        * Insert the Sequence Read Archive (SRA) BioProject ID as an accession
        * Select the samples you want then downlowd the accession list and metadata for the selected samples
    - Check the accession list file and name it 'SRR_Acc_List.txt'. Each line should have one accession number.
    - Run 'bash get_fastq.sh' in the project directory

2. Pre-process the data using FastQC and MultiQC: reference files can be found in the [Pre-process folder](https://github.com/clayton-lab/BugSeq-er/tree/main/Pre-process)
    - Create project subdirectory 'qc' within the project directory, then create a subdirectory of 'qc' named 'script_output'
    - Copy get_sample_name_dic.sh and qc.slurm to the project directory
    - Run 'bash get_sample_name_dic.sh > sample_dic.txt' in the project directory to retrieve the sample list where each accession number is space-delimited
    - Copy the contents of sample_dic.txt to qc.slurm for the 'sample_name' variable 
    - Edit the paths in lines 8 & 9 (.../qc/script_output), 20 (.../raw_reads), and 28 & 29 (.../qc), then run 'sbatch qc.slurm'

3. Run Qiime2: reference files can be found in the [qiime2 folder](https://github.com/clayton-lab/BugSeq-er/tree/main/qiime2)
    - Copy 'manifest_builder.py' to the project directory 
    - Bulid the manifest file by running 'python manifest_builder.py -i (acc list filename) -p (path to the raw reads)
    - Create project subdirectory 'qiime2' within the project directory, then create a subdirectory of 'qc' named 'script_output'
    - Install QIIME2 version 2021.4 by running 'module load qiime2/[(most recent package)](https://hcc.unl.edu/docs/applications/modules/available_software_for_crane/)'
        * All HCC module names and versions can be found [in the HCC documentation](https://hcc.unl.edu/docs/applications/modules/available_software_for_crane/)
    - Download the latest release for the reference SILVA database to your local computer [here](https://docs.qiime2.org/2020.6/data-resources/#taxonomy-classifiers-for-use-with-q2-feature-classifier)
        * To download, select the "Silva 138 99% OTUs full-length sequences" under the "Naive Bayes classifiers trained on:" section 
    - Upload the reference SILVA database file to the qiime2 subdirectory
    - Copy metadata.tsv and the manifest file to the qiime2 subdirectory
        * Ensure metadata.tsv in the right format [(example provided here)](https://github.com/clayton-lab/BugSeq-er/blob/main/sample_metadata.tsv): specifically, the second row should read "#q2:types", then "categorical" for all other columns
    - Copy 'part1.slurm' to the project directory 
        * Edit the path in lines 8 & 9 (.../qiime2/script_output) and 20 (.../qiime2)
        * //I don't understand this, or how to find/know if you have an adapter//If your data contain adapter sequnces, remove them using cutadapt line 35-44 (make sure to change line 37, and 38 with your adapter sequnces)
        * If your data doesn't contain adapter sequnces, comment out lines 35-44
    - Run 'sbatch part1.slurm'
    - Copy 'part2.slurm' to the project directory
        * Edit the path in lines 8 & 9 (.../qiime2/script_output) and 28 (.../qiime2)
        * Visualize 'demux.qzv' (for projects with no adapter sequences) or 'paired-end-demux-trimmed.qzv' (for projects with adapter sequences), located in the 'qiime2' 'artifacts' subdirectory, by downloading to your computer and uploading the file to [Qiime2 View](https://view.qiime2.org/) 
           - Access the 'Interactive Quality Plot' tab
           - Assign trimming values for forward (line 18, p_trim_left_f) and reverse (line 19, p_trim_left_r) reads by estimating the lowest sequence base (x axis) with quality data in the relevant graph 
           - Assign truncating values for forward (line 20, p_trunc_len_f) and reverse (line 21, p_trunc_len_r) reads by estimating the highest sequence base (x axis) with quality data in the relevant graph
        * If no adapter sequnces were removed, replace part2.slurm line 33 with '--i-demultiplexed-seqs artifacts/demuxed-paired-end.qza'
        * Edit line 72 (--i-classifier) to match the name of the reference SILVA database file
    - Run 'sbatch part2.slurm' in the project directory
    - Copy 'part3.slurm' to the project directory
        * Edit the path in lines 8 & 9 (.../qiime2/script_output) and 15 (.../qiime2)
        * Visualize 'table-viz.qzv', located in the 'qiime2' 'artifacts' subdirectory, by downloading to your computer and uploading the file to [Qiime2 View](https://view.qiime2.org/) 
            - Access the 'Interactive Sample Detail' tab
            - Assign sampling depth value (line 29, p_sampling_depth) as the smallest 'Feature Count' value
        * Ensure that there is not a subdirectory names 'core-metrics-results' (if you have previous runs)
    - Run 'sbatch part3.slurm'
    - Copy 'normalized_srs.sh' to the qiime2 subdirectory to perform normalization using SRS (scaling with ranked subsampling)
        * Visualize 'table.qza', located in the 'qiime2/artifacts' subdirectory, by downloading to your computer and uploading the file to the [SRS Shiny app](https://vitorheidrich.shinyapps.io/srsshinyapp/)
        * Select a sampling depth (Cmin) at the lowest value which doesn’t result in eliminating samples
        * Assign Cmin value (line 7, --p-c-min)
    - Run 'bash normalized_srs.sh' in the 'qiime2' subdirectory

4. Create relative abundance plots (heatmap and barplot): relevant files can be found in the [R folder](https://github.com/clayton-lab/BugSeq-er/tree/main/R)
    - NOTE: This code for this section alone is currently run locally in R or RStudio
    - Download 'Heatmap-barplot.R', 'metadata.tsv', 'table.qza', and 'taxonomy.qza' to your R working directory
        * Edit the path in 'Heatmap-barplot.R' line 3 to match your R working directory
    - Run 'Heatmap-barplot.R' in RStudio
    - Create project subdirectory 'qiime2_output' within the project directory
    - Upload 'Heatmap-barplot.R', 'metadata.tsv', 'table.qza', and 'taxonomy.qza', and all result files to the 'qiime2_output' subdirectory

5. Run sub-analyses (LEfSe and PICRUSt2)
    - Create two subdirectories of 'qiime2' named 'lefse' and 'picrust', then create a subdirectory of 'picrust' named 'vis_lefse'
    - LEfSe analysis: reference files can be found in the [LEfSe folder](https://github.com/clayton-lab/BugSeq-er/tree/main/LEfSe)
        * Install LEfSe version 1.0 by running 'module load lefse/[(most recent package)](https://hcc.unl.edu/docs/applications/modules/available_software_for_crane/)'
        * Copy 'format_rel_level.sh' and 'rel_format.py' to the 'lefse' subdirectory
            * Edit titles for resulting plots according to the sample metadata (line 28, 33, 38, 43, 48, and 53)
        * Run 'bash format_rel_level.sh' in the 'lefse' subdirectory
    - PICRUSt2 analysis: reference files can be found in the [PICRUSt2 folder](https://github.com/clayton-lab/BugSeq-er/tree/main/PICRUSt2)
        * Install PICRUSt2 version 2.4 by running 'module load lefse/[(most recent package)](https://hcc.unl.edu/docs/applications/modules/available_software_for_crane/)'
        * Copy 'picrust2.slurm' to the 'picrust' subdirectory
        * Edit the path in lines 8 & 9 (to qiime2/script_output), 13 (to picrust), and 18 (-s .../qiime2/exports/rep-seqs/dna-sequences.fasta -i .../qiime2/exports/table/feature-table-w-taxa.biom
        * Copy 'format_pathway_abun.sh', and 'pathway_format.py' to the 'vis-lefse' directory
            * Edit the path in lines 6 (.../vis-lefse), 9 (.../qiime2/picrust/results/pathways_out/path_abun_unstrat.tsv.gz, .../vis-lefse), 11 (-i .../qiime2/metadata.tsv), 15 (-r .../vis-lefse/path_abun_unstrat.tsv)
            * Edit the title for the resulting plot (line 20)
            * Edit line 11 (-f) to numerically reflect the 'metadata.tsv' columns named 'sample-id', 'type', and 'sub-type'
        * Run 'bash format_pathway_abun.sh' in the 'vis-lefse' subdirectory
        
6. Running correlation and statistical analysis (alpha and beta group significance, differential abundance (ANCOM))
    - Create two subdirectories of 'qiime2' named 'stat' and 'ancom', then create a subdirectory of 'stat' named 'script_output'
    - Alpha and beta group analysis: relevant files can be found in the [Stat folder](https://github.com/clayton-lab/BugSeq-er/tree/main/Stat)
        * Copy 'stat.slurm' to the 'stat' subdirectory
            * Edit the path in lined 8 & 9 (.../stat/script_output) and 15 (.../qiime2)
        * Ensure '--m-metadata-column' matches the name of relevant metadata columns (lines 44, 50, 56, 62, 68, 74, 81, and 87)
        * Run 'sbatch stat.slurm' in the 'stat' subdirectory
    - Differential abundance (ANCOM) analysis: relevant files can be found in the [ANCOM folder](https://github.com/clayton-lab/BugSeq-er/tree/main/ANCOM)
        * Copy 'ancom.sh' to the 'ancom' subdirectory
            * Edit the path in line 5 (.../qiime2/ancom)
        * Ensure '--m-metadata-column' matches the name of relevant metadata columns (lines 21, 39, 57, 74, 91, and 108)
        * Run 'bash ancom.sh' from the 'ancom' subdirectory
