#!/usr/bin/env nextflow

process runInterPro {
    publishDir 'results/InterPro', mode: 'copy'

    input:
    path cds_fasta

    output:
    path "*.gff3"
    path "*.tsv"

    script:
    """
    ${params.interproscan}/interproscan.sh \
    -cpu ${params.nthreads} \
    -i ${cds_fasta} \
    -verbose \
    -f tsv,gff3
    """
}
