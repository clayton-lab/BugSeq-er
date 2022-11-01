#!/bin/bash

module load qiime2/2021.4

qiime srs SRS   \
    --i-table artifacts/table.qza   \
    --p-c-min 4269   \
    --o-normalized-table artifacts/norm-table.qza   \
    --verbose
    
qiime feature-table summarize \
    --i-table artifacts/norm-table.qza \
    --o-visualization artifacts/norm-table.qzv
