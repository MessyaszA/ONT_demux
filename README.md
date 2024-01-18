# ONT_demux
Demultiplex and quality filter workflow for ONT sequences

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A520.11.0--edge-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with slurm](https://img.shields.io/badge/run%20with-slurm-ff4d4d.svg?labelColor=000000)](https://slurm.schedmd.com/)

## Description
This workflow is built to provide a comprehensive workflow for basecalling and demultiplexing ONT sequence data, including quality filtering and multiple quality checks and contaminant detection.

## Metadata
Setting up this pipeline for execution involves establishing an appropriate metadata file. This is a csv file that enables parsing the files correctly together and labelling samples appropriately.

Follow traditional naming restrictions- IE dont use special characters, spaces etc.

## Summary Features:
* Basecalling with [dorado](https://github.com/nanoporetech/dorado)
* Demultiplexing (barcoding) with [guppy](https://community.nanoporetech.com/protocols/Guppy-protocol/v/gpb_2003_v1_revt_14dec2018)
* Sample and trimming QC with [pycoQC](https://adrienleger.com/pycoQC/), [fastp](https://github.com/OpenGene/fastp), [NanoPlot](https://github.com/wdecoster/NanoPlot), and [Chopper](https://github.com/wdecoster/chopper).
* Predictive QC and contaminant detection with [Kraken2](https://ccb.jhu.edu/software/kraken2/)
