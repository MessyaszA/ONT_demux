#!/usr/bin/env nextflow
// Specify DSL2
nextflow.enable.dsl = 2

process CHOPPER_FILT {
    tag "${meta}"
    label 'process_high'

    publishDir "${params.outdir}/chopper/",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }

    container "quay.io/biocontainers/chopper:0.6.0--hdcf5f25_0"

    input:
        tuple val(meta), path(reads)

    output:
        tuple val(meta), path ("*.fastq.gz"), emit: fastq

    script:
    """
    chopper --help
    cat $reads | chopper -q $params.min_q -l $params.min_length --headcrop $params.head_crop --maxlength $params.max_length | gzip > ${meta}.trim.fastq.gz
    """
}
