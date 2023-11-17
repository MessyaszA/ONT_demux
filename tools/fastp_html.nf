#!/usr/bin/env nextflow

// Specify DSL2
nextflow.enable.dsl=2

// Process definition
process FASTP_QC_HTML {
    tag "${meta}"
    label 'process_medium'

    publishDir "${params.outdir}/fastp_html/${type}",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }

    container "biocontainers/fastp:v0.20.1_cv1"

    input:
        tuple val(meta), path(reads)
        val(type)
    
    output:
        path("*.html"), emit: html

    script:
        """
        fastp -i $reads -h ${meta}_${type}_fastp.html -A -L -Q 
        """

}