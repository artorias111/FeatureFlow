#!/usr/bin/env nextflow

process run_braker3 {
    
    container ${params.braker_docker_image}

    input:
    path masked_assembly
    path rna_reads
    path protein_ref

    output:
    path 'augustus.hints.gtf'

    script:
    """
    braker.pl  
    """

}
