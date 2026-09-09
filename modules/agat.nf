#!/usr/bin/env nextflow

process combine_interpro_braker {
    publishDir 'results/agat', mode: 'symlink'
    conda '/data2/work/local/miniconda/envs/agat'

    input:
    path braker_gff //braker's gff3
    path interpro_tsv // interpro_output

    output:
    path "agat_out/*.gff3", emit: 'agat_out' // glob to remove hardcoded braker dependency
    path "agat_out/report.txt"

    script:
    """
    agat_sp_manage_functional_annotation.pl -f ${braker_gff} \
    -i ${interpro_tsv} \
    --output agat_out
    """
}


process merge_interpro_agat {
    publishDir 'results/merged_gene_annotations', mode: 'copy'

    input:
    path interpro_tsv
    path agat_gff

    output:
    path "ip_braker_merged.gff3", emit: 'named_gff'

    script:
    """
    merge_braker_interpro.py -o ip_braker_merged.gff3 ${interpro_tsv} ${agat_gff}
    """
}
