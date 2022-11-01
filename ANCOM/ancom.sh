#!/bin/bash

module load qiime2/2022.2

cd /work/biocore/zalsafwani/CRC_data/raw_reads/qiime2/second_analysis/ancom


qiime taxa collapse \
    --i-table ../artifacts/table.qza \
    --i-taxonomy ../artifacts/taxonomy.qza \
    --p-level 2  \
    --o-collapsed-table level_2_table.qza

qiime composition add-pseudocount \
    --i-table level_2_table.qza \
    --o-composition-table comp_level_2_table.qza
    
qiime composition ancom \
    --i-table comp_level_2_table.qza \
    --m-metadata-file ../metadata.tsv \
    --m-metadata-column type \
    --o-visualization ancom_level_2_type.qzv
    


qiime taxa collapse \
    --i-table ../artifacts/table.qza \
    --i-taxonomy ../artifacts/taxonomy.qza \
    --p-level 3  \
    --o-collapsed-table level_3_table.qza

qiime composition add-pseudocount \
    --i-table level_3_table.qza \
    --o-composition-table comp_level_3_table.qza
    
qiime composition ancom \
    --i-table comp_level_3_table.qza \
    --m-metadata-file ../metadata.tsv \
    --m-metadata-column type \
    --o-visualization ancom_level_3_type.qzv



qiime taxa collapse \
    --i-table ../artifacts/table.qza \
    --i-taxonomy ../artifacts/taxonomy.qza \
    --p-level 4  \
    --o-collapsed-table level_4_table.qza

qiime composition add-pseudocount \
    --i-table level_4_table.qza \
    --o-composition-table comp_level_4_table.qza
    
qiime composition ancom \
    --i-table comp_level_4_table.qza \
    --m-metadata-file ../metadata.tsv \
    --m-metadata-column type \
    --o-visualization ancom_level_4_type.qzv


qiime taxa collapse \
    --i-table ../artifacts/table.qza \
    --i-taxonomy ../artifacts/taxonomy.qza \
    --p-level 5  \
    --o-collapsed-table level_5_table.qza

qiime composition add-pseudocount \
    --i-table level_5_table.qza \
    --o-composition-table comp_level_5_table.qza
    
qiime composition ancom \
    --i-table comp_level_5_table.qza \
    --m-metadata-file ../metadata.tsv \
    --m-metadata-column type \
    --o-visualization ancom_level_5_type.qzv


qiime taxa collapse \
    --i-table ../artifacts/table.qza \
    --i-taxonomy ../artifacts/taxonomy.qza \
    --p-level 6  \
    --o-collapsed-table level_6_table.qza

qiime composition add-pseudocount \
    --i-table level_6_table.qza \
    --o-composition-table comp_level_6_table.qza
    
qiime composition ancom \
    --i-table comp_level_6_table.qza \
    --m-metadata-file ../metadata.tsv \
    --m-metadata-column type \
    --o-visualization ancom_level_6_type.qzv


qiime taxa collapse \
    --i-table ../artifacts/table.qza \
    --i-taxonomy ../artifacts/taxonomy.qza \
    --p-level 7  \
    --o-collapsed-table level_7_table.qza

qiime composition add-pseudocount \
    --i-table level_7_table.qza \
    --o-composition-table comp_level_7_table.qza
    
qiime composition ancom \
    --i-table comp_level_7_table.qza \
    --m-metadata-file ../metadata.tsv \
    --m-metadata-column type \
    --o-visualization ancom_level_7_type.qzv


    

