#!/usr/bin/env nextflow

// include modules

include { ModelRepeats } from './modules/RepeatModeler.nf'
include { createCuratedRepeats } from './modules/RepeatMasker.nf'
include { MaskRepeats } from './modules/RepeatMasker.nf'



// define default parameters

params {
    nthreads = 32

    // fixed file paths
    genome_assembly = '' // path to the genome assembly you want annotated
    dfam_ref = ''  // dfam annotated repeats
    rna_reads = '' // rna reads from sra

    // executable paths 
    repeatmasker = '' // repeatmasker filepath (don't include the executable)
    repeatmodeler = '' // repeatmodeler filepath 
}


workflow {
    genome_ch = Channel.fromPath(params.genome_assembly)

    // call your repeatmasking processes
    ModelRepeats(genome_ch)
    createCuratedRepeats(ModelRepeats.out)
    MaskRepeats(genome_ch, createCuratedRepeats.out)

}
