#!/usr/bin/env nextflow

// Specify DSL2
nextflow.enable.dsl = 2

// Process definition
process PYCO_QC {
    tag "${sequencing_summary}"
    label 'process_medium'

    publishDir "${params.outdir}/pycoqc/",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }

    container "quay.io/biocontainers/pycoqc:2.5.0.23--py_0"

    input:
        path(tsv)
        path(barcode_summary)
        
    output:
        path '*.html', emit: report

    script:    
        """
        pycoQC --summary_file $tsv --barcode_file $barcode_summary --html_outfile pycoqc_report.html
        """
}
