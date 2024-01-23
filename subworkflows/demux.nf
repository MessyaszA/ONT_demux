#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

////////////////////////////////////////////////////
/* --              Parameter setup             -- */
////////////////////////////////////////////////////

////////////////////////////////////////////////////
/* --           Load Modules                  -- */
////////////////////////////////////////////////////

include {POD5_CONVERT} from '../tools/pod5'
include {DORADO_BASECALL} from '../tools/dorado'
include {SAMTOOLS_SORT} from '../tools/samtools'
include {GUPPY_DEMUX} from '../tools/guppy'
include {PYCO_QC} from '../tools/pycoqc'
include {CHOPPER_FILT} from '../tools/chopper'
include {FASTP_QC_HTML} from '../tools/fastp_html'
include {FASTP_QC_HTML as FASTP_QC_HTML_TRIMMED} from '../tools/fastp_html'
include {FASTP_QC_JSON_TRIMMED} from '../tools/fastp_json'
include {MULTIQC} from '../tools/multiqc'
include {NANOPLOT} from '../tools/nanoplot'
include {NANOPLOT as NANOPLOT_TRIMMED} from '../tools/nanoplot'

////////////////////////////////////////////////////
/* --           RUN MAIN WORKFLOW              -- */
////////////////////////////////////////////////////


workflow Demux {
  take:
    ch_input_dir
    ont_metadata

  main:
    POD5_CONVERT(
      ch_input_dir
    )

    DORADO_BASECALL(
      POD5_CONVERT.out.pod5
    )

    SAMTOOLS_SORT(
      DORADO_BASECALL.out.bam
    )

    GUPPY_DEMUX(
      SAMTOOLS_SORT.out.bam
    )

    PYCO_QC(
      DORADO_BASECALL.out.tsv,
      GUPPY_DEMUX.out.sequencing_summary
    )

    ch_ont_fastq = Channel.empty()
    ch_ont_fastq = GUPPY_DEMUX.out.fastq
      .flatten()
      .map{ it -> tuple(it.baseName, it) } //bc, bc_dir

    ch_demuxed = ont_metadata.join(ch_ont_fastq, by: [0])//bc, id with bc, bc_dir become bc, id, bc_dir
    ch_demuxed_filtered = ch_demuxed
       .map{ it -> tuple(it[1], it[2]) } //And end as id, bc_dir
       //.subscribe { println it }
    
    FASTP_QC_HTML(
      ch_demuxed_filtered,
      'guppy_qc'
    )

    NANOPLOT(
      ch_demuxed_filtered,
      'guppy_qc'
    )
    
    CHOPPER_FILT(
      ch_demuxed_filtered
    )

    NANOPLOT_TRIMMED(
      CHOPPER_FILT.out.fastq,
      'chopper'
    )

    FASTP_QC_HTML_TRIMMED(
      CHOPPER_FILT.out.fastq,
      'chopper'
    )

    FASTP_QC_JSON_TRIMMED(
      CHOPPER_FILT.out.fastq
    )

    MULTIQC(
      FASTP_QC_JSON_TRIMMED.out.json.collect()
    )

    filt_fastq = Channel.empty()
    filt_fastq=CHOPPER_FILT.out.fastq
  
  emit:
    reads=filt_fastq
}
