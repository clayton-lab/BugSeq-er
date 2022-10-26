# A pipeline for reproducible human 16S rRNA microbiome analysis

## The main goal of this project is to establish feasibility of creating a reproducible pipeline from existing 16S rRNA microbiome sequencing data in humans by providing a full documented pipeline. 
- The first aim of this project is to identify challenges and gaps in 16S rRNA microbiome analysis by conducting a literature review. 
- The second aim of the project is to implement a full documented pipeline to reproduce 16S rRNA microbiome sequencing data analysis in humans. 
- The third aim of the project is to validate the reproducibility of the pipeline by running a public human dataset through it BioProject ID: PRJNA743150, and SRA Study: SRP326567.


## General overview of the pipeline.
![pipeline-overview](https://github.com/zalsafwani/thesis/blob/621d1302af242417919a21142b0ac8aa846ecc04/Microbiome%20Analysis%20Pipeline.png)
The first step is pre-processing the data with FastQC, MultiQC, then run QIIME2 to import the data, demux, and remove adapter (cutadapt). Running QIIME2 involv running DADA2, diversity analysis, phylogenetic analysis, and taxonomic analysis. The sub-analysis includes running two tools LEfSe and PICRUSt. The statistical analysis includes diversity alpha and beta group significant, and differential abundance (ANCOM). * (part1.slurm), ** (part2.slurm), and ***(part3.slurm).

## Tools installation and packages available in the [tools file](https://github.com/clayton-lab/BugSeq-er/blob/main/Tools.md).



## Detailed steps in how to run the pipeline is available in the [steps file](https://github.com/zalsafwani/thesis/blob/f38aa88de88427e96d1d5a0974de9e8e4ffc7dbe/steps.md).
Note that the full analysis could be run in Crane HOLLAND COMPUTING CENTER (HHC) (https://hcc.unl.edu/) without the need to install anything except for the step that create relative abundance plots (heatmap and barplot) which uses R and specific packages that are not available.

## License
This repo uses the GNU General Public License v 3.0.
