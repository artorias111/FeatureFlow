#!/usr/bin/env nextflow

process run_busco {
    conda '/data2/work/local/miniconda/envs/busco/'

    publishDir 'results/braker_benchmark', mode: 'copy'

    input:
    path aa_fa

    output:
    path braker_busco

    script:
    """
    busco -o braker_busco \
    -i ${aa_fa} \
    -m proteins \
    -l actinopterygii \
    -c ${params.nthreads}
    """
}

process run_hisat_multiqc {
    conda '/data2/work/local/miniconda/envs/multiqc/'

    input: 
    path braker_out

    output:
    path 'multiqc_report.html'

    script:
    """
    """
}
