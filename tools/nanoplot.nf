#!/usr/bin/env nextflow

// Specify DSL2
nextflow.enable.dsl=2

// Process definition
process NANOPLOT {
    label 'process_medium'

    publishDir "${params.outdir}/nanoplot/${type}/${meta}",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }
    
    container "staphb/nanoplot:1.42.0"

    input:
        tuple val(meta), path(reads)
        val(type)
    
    output:
        path ("*.{png, html, txt, log}"), emit: report
    
    script:
        """
        NanoPlot --fastq $reads
        """
 
}