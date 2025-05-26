#!/usr/bin/env nextflow

process getRnaIDs {

    input: 
    path rna_reads

    output: 
    path renamed_reads, emit :renamed_reads_path 
    stdout emit: ID_list

    script:

    """
    python ${projectDir}/bin/getRnaIDs.py --rna_dir ${rna_reads} > rna_ids.tsv

    mkdir renamed_reads
    mv *.fastq.gz renamed_reads
    cat rna_ids.tsv | tr -d "\n"
    """
}
