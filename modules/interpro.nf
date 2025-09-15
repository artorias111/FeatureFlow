#!/usr/bin/env nextflow

process runInterPro {
    publishDir 'results/InterPro', mode: 'symlink'

    input:
    path cds_fasta

    output:
    path "*.gff3", emit :interpro_gff3
    path "*.tsv", emit :interpro_tsv 

    script:
    """
    ${params.interproscan}/interproscan.sh \
    -cpu ${params.nthreads} \
    -i ${cds_fasta} \
    -verbose \
    -f tsv,gff3
    """
}
