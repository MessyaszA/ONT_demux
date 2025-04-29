# ONT_demux
Demultiplex, quality filter, and estimate taxonomic abundance workflow for ONT 16S sequences

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A520.11.0--edge-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with slurm](https://img.shields.io/badge/run%20with-slurm-ff4d4d.svg?labelColor=000000)](https://slurm.schedmd.com/)

## Description
This workflow is built to provide a comprehensive workflow for basecalling and demultiplexing ONT sequence data, including quality filtering, multiple quality checks, contaminant detection, taxonimic classification, and taxonomy abundance estimation.

## Execution Tutorial
A tutorial on executing ONT_demux can be [found here](https://github.com/MessyaszA/ONT_demux/blob/main/docs/execution_tutorial.md).

## Summary Features:
* Basecalling with [dorado](https://github.com/nanoporetech/dorado)
* Demultiplexing (barcoding) with [guppy](https://community.nanoporetech.com/protocols/Guppy-protocol/v/gpb_2003_v1_revt_14dec2018)
* Sample and trimming QC with [pycoQC](https://adrienleger.com/pycoQC/), [fastp](https://github.com/OpenGene/fastp), [NanoPlot](https://github.com/wdecoster/NanoPlot), and [Chopper](https://github.com/wdecoster/chopper).
* Predictive QC and contaminant detection with [Kraken2](https://ccb.jhu.edu/software/kraken2/)
* Taxonomic classfication and abundance estimation with [Bracken] (https://ccb.jhu.edu/software/bracken/index.shtml?t=manual)
* Taxonomy abudance prep for secondary analysis with [Taxpasta] (https://taxpasta.readthedocs.io/en/latest/#about)
