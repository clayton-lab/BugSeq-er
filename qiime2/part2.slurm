#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=64000
#SBATCH --time=24:00:00
#SBATCH --job-name=analysis_part2
#SBATCH --partition=batch,guest
#SBATCH --error=/work/biocore/zalsafwani/CRC_data/raw_reads/qiime2/second_analysis/script_output/part2/err.out
#SBATCH --output=/work/biocore/zalsafwani/CRC_data/raw_reads/qiime2/second_analysis/script_output/part2/std.out
#SBATCH --open-mode=append


############################################
# Declare important local variables
############################################

# For dada2 denoise
p_trim_left_f=5
p_trim_left_r=5
p_trunc_len_f=264
p_trunc_len_r=207

# The number of threads (or CPUs) to use and it must match --ntasks-per-node in header
n_threads=16

module load qiime2/2021.4

cd /work/biocore/zalsafwani/CRC_data/raw_reads/qiime2/second_analysis

echo "Starting dada2: `date`"

qiime dada2 denoise-paired \
	--i-demultiplexed-seqs artifacts/paired-end-demux-trimmed.qza \
	--p-trunc-len-f $p_trunc_len_f \
	--p-trunc-len-r $p_trunc_len_r \
	--p-n-threads $n_threads \
	--o-table artifacts/table.qza \
	--o-representative-sequences artifacts/rep-seqs.qza \
	--o-denoising-stats artifacts/denoising-stats.qza

echo "dada2 complete: `date`"

qiime metadata tabulate \
       --m-input-file artifacts/denoising-stats.qza \
        --o-visualization artifacts/denoising-stats-viz.qzv

qiime feature-table filter-samples \
    --i-table artifacts/table.qza \
    --m-metadata-file metadata.tsv \
    --o-filtered-table artifacts/table.qza

qiime feature-table summarize \
        --i-table artifacts/table.qza \
        --o-visualization artifacts/table-viz.qzv \
        --m-sample-metadata-file metadata.tsv

qiime feature-table tabulate-seqs \
        --i-data artifacts/rep-seqs.qza \
        --o-visualization artifacts/rep-seqs.qzv
        
        
echo "`date` - Starting mafft fasttree and diversity operations"

qiime phylogeny align-to-tree-mafft-fasttree \
        --i-sequences artifacts/rep-seqs.qza \
        --o-alignment artifacts/aligned-rep-seqs.qza \
        --o-masked-alignment artifacts/masked-aligned-rep-seqs.qza \
        --o-tree artifacts/unrooted-tree.qza \
        --o-rooted-tree artifacts/rooted-tree.qza

qiime feature-classifier classify-sklearn \
        --i-classifier silva-138-99-nb-classifier.qza \
        --i-reads artifacts/rep-seqs.qza \
        --o-classification artifacts/taxonomy.qza

qiime metadata tabulate \
        --m-input-file artifacts/taxonomy.qza \
        --o-visualization artifacts/taxonomy.qzv

# filter out eukarya and archaea
qiime taxa filter-table \
    --i-table artifacts/table.qza \
    --i-taxonomy artifacts/taxonomy.qza \
    --p-exclude eukarya,archaea \
    --o-filtered-table artifacts/table.qza

qiime taxa barplot \
    --i-table artifacts/table.qza \
    --i-taxonomy artifacts/taxonomy.qza \
    --m-metadata-file metadata.tsv \
    --o-visualization artifacts/taxa-bar-plots.qzv
