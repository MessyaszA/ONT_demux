#!/usr/bin/env nextflow
// Specify DSL2
nextflow.enable.dsl = 2

// Process definition
process GUPPY_DEMUX {
    label 'process_overkill'

    input:
        path reads

    output:
        path("fastq/*.fastq"), emit: fastq
        path("*.txt"), emit: sequencing_summary

    script:
        barcode_kit=params.barcode_kit ? "--barcode_kits '$params.barcode_kit'": ""
        """
        guppy_barcoder --help
        guppy_barcoder --print_kits
        guppy_barcoder --input_path $reads \\
            -r \\
            --save_path . \\
            --records_per_fastq 0 \\
            $barcode_kit \\
            $gpu_opts
            
        # have to combine fastqs
        mkdir fastq
        if [ "\$(find . -type d -name "barcode*" )" != "" ]
        then
            for dir in barcode*/
            do
                dir=\${dir%*/}
                cat \$dir/*.fastq > fastq/\$dir.fastq
            done 
        else
            cat *.fastq > fastq/output.fastq
        fi
        """
}
