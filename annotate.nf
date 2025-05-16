#!/usr/bin/env nextflow

// include modules

include { ModelRepeats } from './modules/RepeatModeler.nf'
include { createCuratedRepeats } from './modules/RepeatMasker.nf'
include { MaskRepeats } from './modules/RepeatMasker.nf'
include { runBraker3 } from './modules/braker3.nf'
include { createKimuraDivergencePlots } from './modules/RepeatMasker.nf'
include { getRnaIDs } from './modules/braker3.nf'
include { getCdna } from './modules/gffread.nf'
include { runInterPro } from './modules/interpro.nf'




workflow {
    genome_ch = Channel.fromPath(params.genome_assembly)

    // call your repeatmasking processes
    ModelRepeats(genome_ch)
    createCuratedRepeats(ModelRepeats.out)
    MaskRepeats(genome_ch, createCuratedRepeats.out)

    // Kimura divergence
    createKimuraDivergencePlots(MaskRepeats.out.rm_cat_file, MaskRepeats.out.rm_tbl_file)


    // helper function for braker, followed by braker
    getRnaIDs(params.rna_reads)
    runBraker3(MaskRepeats.out.masked_file, params.rna_reads, params.protein_ref, getRnaIDs.out.ID_list)

    // Functional annotation
    getCdna(MaskRepeats.out.masked_file, runBraker3.out.braker_annots)
    runInterPro(getCdna.out)
}
