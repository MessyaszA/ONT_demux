#!/usr/bin/env nextflow
// Specify DSL2
nextflow.enable.dsl = 2

process SAMTOOLS_SORT {
    label 'process_high'

    container "staphb/samtools:latest"

    input:
        path(reads)

    output:
        path 'samtools_result/', emit: bam

    """
    mkdir samtools_result
    samtools sort $reads -o samtools_result/dorado_calls_sorted.bam
    """
}