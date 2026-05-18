process annotate_TEs { 
    publishDir 'results', mode: 'symlink'
    
    conda params.earlGrey_env

    input:
    path genome_asm

    output:
    path "EarlGrey/*_EarlGrey", emit: 'earlgrey_dir'
    path "EarlGrey/*_EarlGrey/*_summaryFiles/*.softmasked.fasta", emit: 'masked_asm'

    script:
    """
    earlGrey -g ${genome_asm} \
    -s ${params.species_id} \
    -o EarlGrey \
    -t ${params.nthreads} \
    -d yes
    """
}
