#!/usr/bin/env nextflow

process ModelRepeats {
    conda '/data2/work/local/miniconda/envs/RepeatMask'

    publishDir 'results/RepeatModeler', mode: 'copy'

    input:
    path genome_assembly

    output:
    path 'asm.db-families.fa' // placeholder, I need to figure out the actual name

    script:
    """
    ${params.repeatmodeler}/BuildDatabase -name asm.db \
    -engine ncbi ${genome_assembly} 

    ${params.repeatmodeler}/RepeatModeler \
    -database asm.db \
    -engine ncbi \
    -threads ${params.nthreads} \
    -LTRStruct
    """
    
}
