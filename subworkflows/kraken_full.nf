#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

////////////////////////////////////////////////////
/* --              Parameter setup             -- */
////////////////////////////////////////////////////

////////////////////////////////////////////////////
/* --           Load Modules                  -- */
////////////////////////////////////////////////////

include { Kraken2_db_build } from '../tools/kraken'
include { Kraken2 } from '../tools/kraken'
include { Krona } from '../tools/kraken'
include { BRACKEN } from '../tools/bracken'
include { Krona_bracken } from '../tools/bracken'
include { TAXPASTA } from '../tools/taxpasta' 

////////////////////////////////////////////////////
/* --           RUN MAIN WORKFLOW              -- */
////////////////////////////////////////////////////

workflow Kraken {
    take:
        reads
        kraken_name
    
    main:
        Kraken2_db_build(
            params.kraken_db,
            kraken_name
        )

        Kraken2(
            reads,
            Kraken2_db_build.out.kraken2_ch
        )

        Krona(
            Kraken2.out.kraken2krona
        )

        BRACKEN(
            Kraken2.out.report,
            params.bracken_db
        )


        Krona_bracken(
            BRACKEN.out.brack_report
        )

        TAXPASTA(
            BRACKEN.out.tsv.collect()
        )
}
