#!/usr/bin/env nextflow

process getCdna {
    conda '/data2/work/local/miniconda/envs/orthofinder'

    publishDir 'results/gffreadCdna', mode: 'copy'

    input:
    path masked_assembly
    path gene_annotations // From braker

    output:
    path "${file(params.genome_assembly).simpleName}.cds.fa"

    script:
    """
    gffread -g ${masked_assembly} \
    -y ${file(params.genome_assembly).simpleName}.cds.fa \
    ${params.genome_assembly}.cds.fa \
    ${gene_annotations}     

    """
}
