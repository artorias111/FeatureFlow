#!/usr/bin/env nextflow

process alignRnaReads {

    conda '/data2/work/local/miniconda/envs/HISAT2/'

    input:
    path rna_reads
    path "${genome_assembly}.masked"

    output:
    path rna.aligned.sorted.bam

    script:
    """
    ${params.hisat_path}/hisat2-build \
    -p ${params.nthreads} \
    "${genome_assembly}.masked" \
    """
}
