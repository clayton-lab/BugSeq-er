# Set working directory to the place which have:
# 'metadata.tsv', 'table.qza', 'taxonomy.qza'
setwd("~/Downloads/qiime2_output")


# Try loading the packge 
# if it shows Error in library(...) : there is no package called ‘...’
# Then install and load it
# install.packages("tidyverse")
# if (!requireNamespace("devtools", quietly = TRUE)){install.packages("devtools")}
# devtools::install_github("jbisanz/qiime2R", force = TRUE)
library(tidyverse)
library(qiime2R)

# Read the necessary files: 'metadata.tsv', 'table.qza', 'taxonomy.qza'
metadata <- read_q2metadata("metadata.tsv")
features_table <- read_qza("table.qza")$data
taxonomy_table <- read_qza("taxonomy.qza")$data %>% parse_taxonomy()


# Sumarize tax for each level (2-7)
taxasums_p <- summarize_taxa(features_table, taxonomy_table)$Phylum
taxasums_c <- summarize_taxa(features_table, taxonomy_table)$Class
taxasums_o <- summarize_taxa(features_table, taxonomy_table)$Order
taxasums_f <- summarize_taxa(features_table, taxonomy_table)$Family
taxasums_g <- summarize_taxa(features_table, taxonomy_table)$Genus
taxasums_s <- summarize_taxa(features_table, taxonomy_table)$Species

# Plotting Heatmaps for each level (2-7)
# Phylum
heatmap_p <- taxa_heatmap(taxasums_p, metadata, "type")
ggsave("heatmap_p.pdf", height=4, width=8, device="pdf")
# Class
heatmap_c <- taxa_heatmap(taxasums_c, metadata, "type")
ggsave("heatmap_c.pdf", height=4, width=8, device="pdf")
# Order
heatmap_o <- taxa_heatmap(taxasums_o, metadata, "type")
ggsave("heatmap_o.pdf", height=4, width=8, device="pdf")
# Family
heatmap_f <- taxa_heatmap(taxasums_f, metadata, "type")
ggsave("heatmap_f.pdf", height=4, width=8, device="pdf")
# Genus
heatmap_g <- taxa_heatmap(taxasums_g, metadata, "type")
ggsave("heatmap_g.pdf", height=4, width=8, device="pdf")
# Species
heatmap_s <- taxa_heatmap(taxasums_s, metadata, "type")
ggsave("heatmap_s.pdf", height=4, width=8, device="pdf")


# Plotting Barplot for each level (2-7)
# Phylum
barplot_p <- taxa_barplot(taxasums_p, metadata, "type")
ggsave("barplot_p.pdf", height=4, width=8, device="pdf")
# Class
barplot_c <- taxa_barplot(taxasums_c, metadata, "type")
ggsave("barplot_c.pdf", height=4, width=8, device="pdf")
# Order
barplot_o <- taxa_barplot(taxasums_o, metadata, "type")
ggsave("barplot_o.pdf", height=4, width=8, device="pdf")
# Family
barplot_f <- taxa_barplot(taxasums_f, metadata, "type")
ggsave("barplot_f.pdf", height=4, width=8, device="pdf")
# Genus
barplot_g <- taxa_barplot(taxasums_g, metadata, "type")
ggsave("barplot_g.pdf", height=4, width=8, device="pdf")
# Species
barplot_s <- taxa_barplot(taxasums_s, metadata, "type")
ggsave("barplot_s.pdf", height=4, width=8, device="pdf")
