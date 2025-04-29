// Specify DSL2
nextflow.enable.dsl = 2

// Process definition

process BRACKEN {
    tag "${meta}"
    label 'process_high'

    publishDir "${params.outdir}/bracken/",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }

    container "alemenze/kraken2-docker"

    input:
        tuple val(meta), path(reads)
        path(db)

    output:
        tuple val(meta), path("*.brackreport"), emit: brack_report
        path("*_bracken.tsv"), emit: tsv

    script:
        """
        bracken -d $db -r $params.read_len -i $reads -l $params.kraken_tax_level -o ${meta}_bracken.tsv -w ${meta}.brackreport
        """
}

process Krona_bracken {

    container "alemenze/kraken2-docker"
    label 'process_medium'

    publishDir "${params.outdir}/bracken_krona/${meta}",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }
    
    input:
        tuple val(meta), path(reads)
    
    output:
        path("*_bracken_krona.html")

    script:
        """
        ktImportTaxonomy -t 5 -m 3 -o ${meta}_bracken_krona.html $reads
        """
}