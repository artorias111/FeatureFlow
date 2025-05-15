#!/usr/bin/env nextflow

// include modules

include { ModelRepeats } from './modules/RepeatModeler.nf'
include { createCuratedRepeats } from './modules/RepeatMasker.nf'
include { MaskRepeats } from './modules/RepeatMasker.nf'





workflow {
    genome_ch = Channel.fromPath(params.genome_assembly)

    // call your repeatmasking processes
    ModelRepeats(genome_ch)
    createCuratedRepeats(ModelRepeats.out)
    MaskRepeats(genome_ch, createCuratedRepeats.out)

}
