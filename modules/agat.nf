#!/usr/bin/env nextflow

process combine_interpro_braker {
    publishDir 'results/agat', mode: 'copy'

    conda '/data2/work/local/miniconda/envs/agat'

    input:
    path braker_gff //braker's gff3
    path interpro_tsv // interpro_output

    output:
    path "agat_out/braker.gff3"
    path "agat_out/report.txt"

    script:
    """
    agat_sp_manage_functional_annotation.pl -f ${braker_gff} \
    -i ${interpro_tsv} \
    --output agat_out
    """
}
