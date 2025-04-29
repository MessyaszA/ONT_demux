#!/usr/bin/env nextflow
// Specify DSL2
nextflow.enable.dsl = 2

process DORADO_BASECALL {
    container "genomicpariscentre/dorado:0.9.1"

    input:
        path(reads)

    output:
        path '*.bam', emit: bam
        path '*.tsv', emit: tsv

    script:
        if (params.gpu_active){
            gpu_opts = "--gpu_runners_per_device $params.gpus -x cuda:all:100% --chunk_size 1000 --chunks_per_runner 256"
        } else {
            gpu_opts = ""
        }
    """
    dorado download --model ${params.model}
    dorado basecaller ${params.model} ${reads} > dorado_calls.bam  
    dorado summary dorado_calls.bam > dorado_summary.tsv
    """
}