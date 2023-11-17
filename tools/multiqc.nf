#!/usr/bin/env nextflow
// Specify DSL2
nextflow.enable.dsl = 2

process MULTIQC {
    label 'process_medium'

    container "quay.io/biocontainers/multiqc:1.16--pyhdfd78af_0"

    publishDir "${params.outdir}/multiqc/",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }

    input:
        path(trimmed_json)

    output:
        path '*.html', emit: html

    script:
    """
    multiqc --help
    multiqc $trimmed_json -m fastp -n multiqc.html
    """
}