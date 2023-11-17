#!/usr/bin/env nextflow
// Specify DSL2
nextflow.enable.dsl = 2

process POD5_CONVERT {
    label 'process_high'

    container "ctomlins/pod5_tools"

    input:
        path(reads)

    output:
        path ("pod5_results/"), emit: pod5

    script:
    """
    pod5 convert fast5 --help
    mkdir pod5_results
    pod5 convert fast5 $reads pod5_results
    """
}
