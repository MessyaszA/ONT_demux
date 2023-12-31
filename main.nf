#!/usr/bin/env nextflow
/*
                              (╯°□°)╯︵ ┻━┻

========================================================================================
                Workflow for basecalling and demultiplexing ont sequences
========================================================================================
*/ 

nextflow.enable.dsl = 2

def helpMessage(){
    log.info"""

    Usage:
    
        nextflow run main.nf \
        --samplesheet ./metadata.csv
        -profile singularity

    Mandatory for full workflow:
        --samplesheet               CSV file with information on the samples (see example)
        -profile                    Currently available for docker (local), singularity (HPC local), slurm (HPC multi node) and GCP (requires credentials)
    
    POD5 conversion parameters:
        --one-to-one                Convert each fast5 to its relative converted output. The output files are written into the output directory at paths relatve to the path given to the --one-to-one argument. Note: This path must be a relative parent to all input paths.
    
    Dorado parameters:
        --model                     Specify basecalling model - choose based on flowcell and kit. Defaults to 'dna_r9.4.1_e8_hac@v3.3'
        --modified-bases            Call basecalling modifications. Refer to the models https://github.com/nanoporetech/dorado#modified-base-models
    
    Guppy parameters:
        --barcode_kit               Barcode kit used for multiplexing with ONT. 
        --gpu_active                Default: false. Activates use of GPUs
        --gpus                      Number of GPUs to use. Requires GPUs to use. Defaults to 0
        --cpus                      Number of CPUs to use. Defaults to 2
        --threads                   Number of threads per CPU to use. Defaults to 20

    Kraken QC:
        --kraken_db                 Default: Standard DB k2_standard_20230605.tar.gz. More up to date db can be found https://benlangmead.github.io/aws-indexes/k2

    Chopper filtering parameters:
        --min_length                Minimum length of reads for filtlong. Defaults to 1000.
        --max_length                Sets a maximum read length. Defaults to 1690.
        --min_q                     Minimum quality score for bases for filtlong. Defaults to 10.
        --head_crop                 Trim N nucleotides from the start of a read. Defaults to 50.
        --contam                    Fasta file with reference to check potential contaminants against. Defaults to None. 

    Optional:
        --outdir                    Directory for output directories/files. Defaults to 'projectDir/results' 

    Slurm Controller:
        --node_partition            Specify the node partition in use for slurm executor. Defaults to 'p_lemenzad_1' 
        --gpu_node_partition        Specify the node for GPU access. Defaults to 'p_lemenzad_1'
        --gpu_clusterOptions        Specify GPU node options. Defaults to "--gres=gpu:1" for dev cluster constraints. 
    """

}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

////////////////////////////////////////////////////
/* --   Diff Parameter setup for samplesheet   -- */
////////////////////////////////////////////////////
if (params.samplesheet) {file(params.samplesheet, checkIfExists: true)} else { exit 1, 'Samplesheet file not specified!'}

//Full Workflow Params
{
    Channel
        .fromPath(params.samplesheet)
        .splitCsv(header:true)
        .map{ row -> tuple(row.fast5_dir)}
        .unique()
        .set { guppy_dirs }

    Channel
        .fromPath(params.samplesheet)
        .splitCsv(header:true)
        .map{ row -> tuple(row.ont_barcode, row.sample_id)}
        .set { ont_metadata }
}

////////////////////////////////////////////////////
/* --              IMPORT MODULES              -- */
////////////////////////////////////////////////////
include { Demux_Full } from './main_workflows/demux_full'
include { Kraken } from './subworkflows/kraken_full'

////////////////////////////////////////////////////
/* --           RUN MAIN WORKFLOW              -- */
////////////////////////////////////////////////////

workflow {
    //Full Workflow
    {
        Demux_Full(
            guppy_dirs,
            ont_metadata
        )

        Kraken(
            Demux_Full.out,
            'Kraken'
        )
        }
        
    }
