#!/usr/bin/env nextflow
// Specify DSL2
nextflow.enable.dsl = 2

process TAXPASTA {
    label 'process_medium'

    container "quay.io/biocontainers/taxpasta:0.7.0--pyhdfd78af_0"

    publishDir "${params.outdir}/bracken_merged_tables/",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }

    input:
        path reads
        path(tax_db)

    output:
        path("*.biom"), emit: biom
        path("*.tsv"), emit: tsv

    script:
    """
    taxpasta merge $reads -p bracken --output-format BIOM -o biom_merge.biom --taxonomy $tax_db --add-lineage
    taxpasta merge $reads -p bracken --output-format TSV -o tsv_merge.tsv --taxonomy $tax_db --add-lineage
    """
}