#!/usr/bin/env nextflow

// Specify DSL2
nextflow.enable.dsl=2

// Process definition
process FASTP_QC_JSON_TRIMMED {
    tag "${meta}"
    label 'process_medium'

    container "quay.io/biocontainers/fastp:0.24.0--heae3180_1"

    input:
        tuple val(meta), path(reads)
    
    output:
        path ("*.json"), emit: json

    script:
        """
        fastp -i $reads -j ${meta}_fastp.json -A -L -Q 
        """

}