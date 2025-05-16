#!/usr/bin/env nextflow


def helpMessage() {
    log.info"""
    ===============================
    ChengLab Feature Flow Pipeline
    ===============================
    
    Usage:
    nextflow run annotate.nf [options]
    
    Core Options:
      --genome_assembly     Path to genome assembly FASTA file (default: ${params.genome_assembly})
      --nthreads            Number of CPU threads to use (default: ${params.nthreads})
      --rna_reads           Path to RNA-seq reads directory (default: ${params.rna_reads})
      --protein_ref         Path to reference proteins FASTA file (default: ${params.protein_ref})
      
    Advanced Options:
      --dfam_ref            Path to Dfam reference
      --repeatmasker        Path to RepeatMasker installation
      --repeatmodeler       Path to RepeatModeler installation
      --braker_docker_image Path to Braker3 Singularity image
      --augustus_config     Path to Augustus config directory
      --interproscan        Path to InterProScan installation
      
    Execution Options:
      --help                Display this help message
      -resume               Resume previous run
    """
}


// Log pipeline info
log.info ""
log.info "ChengLab Feature Flow Pipeline"
log.info "==============================="
log.info "Genome assembly: ${params.genome_assembly}"
log.info "RNA-seq reads  : ${params.rna_reads}"
log.info "Protein ref    : ${params.protein_ref}"
log.info "Threads        : ${params.nthreads}"
log.info ""

// check if help message is requested

if (params.help) {
    helpMessage()
    exit 0
}


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
