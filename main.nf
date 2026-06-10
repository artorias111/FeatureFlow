#!/usr/bin/env nextflow

def helpMessage() {
    log.info"""
    ================================================================
    FeatureFlow Pipeline: Genome Annotation
    ================================================================
    Usage:
    nextflow run main.nf -params-file params.yaml [options]

    Workflow Triggers based on params.yaml:

    1. Full Pipeline: Provide 'genome_assembly', 'protein_ref', and 'rna_reads'.
    2. Skip Masking: Provide 'masked_genome' alongside 'genome_assembly'.
    3. Protein-Only: Omit 'rna_reads'.
    4. Skip to Functional Annotation: Provide 'gene_annotation_gff' and 'transcript_aa_fasta'.
    ================================================================
    """
}

if (params.help) {
    helpMessage()
    exit 0
}

// ---------------------------------------------------------------
// Modules
// ---------------------------------------------------------------
include { annotate_TEs } from './modules/earlgrey.nf'
include { runBraker4 } from './modules/braker4.nf'
include { cleanBrakerAA } from './modules/clean_braker_aa.nf'
include { runInterPro } from './modules/interpro.nf'
include { combine_interpro_braker } from './modules/agat.nf'
include { runBrakerBusco } from './modules/Busco.nf'

// ---------------------------------------------------------------
// Main Dynamic Workflow
// ---------------------------------------------------------------
workflow {
    log.info "========================================================"
    log.info "FeatureFlow Initializing..."
    log.info "========================================================"

    if (!params.genome_assembly) {
        error "ERROR: 'genome_assembly' is required in your config."
    }

    // 1. TE Masking
    def masked_asm_ch
    if (params.masked_genome) {
        log.info "Mode: Skipping TE annotation. Using provided masked genome."
        masked_asm_ch = Channel.fromPath(params.masked_genome)
    } else {
        log.info "Mode: Full pipeline. Masking genome with Earlgrey."
        annotate_TEs(Channel.fromPath(params.genome_assembly))
        masked_asm_ch = annotate_TEs.out.masked_asm
    }

    // 2. Structural Annotation
    def braker_annots_ch
    def braker_aa_ch
    if (params.gene_annotation_gff && params.transcript_aa_fasta) {
        log.info "Mode: Skipping BRAKER4. Using provided GFF and AA FASTA."
        braker_annots_ch = Channel.fromPath(params.gene_annotation_gff)
        braker_aa_ch     = Channel.fromPath(params.transcript_aa_fasta)
    } else {
        def rna_ch
        if (params.bam) {
            log.info "Mode: Braker4 with BAM and Protein evidence."
            rna_ch = Channel.fromPath(params.bam).collect()
        } else if (params.rna_reads) {
            log.info "Mode: Braker4 with RNA-seq and Protein evidence."
            rna_ch = Channel.fromPath("${params.rna_reads}/*{_R1,_R2,_1,_2}*.fastq*").collect()
        } else {
            log.info "Mode: Braker4 Protein-only evidence."
            rna_ch = Channel.of( [file("/dev/null")] )
        }
        runBraker4(Channel.fromPath(params.genome_assembly), masked_asm_ch, rna_ch, params.protein_ref)
        braker_annots_ch = runBraker4.out.braker_annots
        braker_aa_ch     = runBraker4.out.aa_seqs
    }

    // 3. Functional Annotation (always runs)
    log.info "Functional annotation processes:"
    cleanBrakerAA(braker_aa_ch)
    runInterPro(cleanBrakerAA.out)
    combine_interpro_braker(braker_annots_ch, runInterPro.out.interpro_tsv)
    runBrakerBusco(cleanBrakerAA.out)
}
