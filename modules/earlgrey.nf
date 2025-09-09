process annotate_TEs { 
    publishDir 'results', mode: 'copy'
    
    conda '/data2/work/local/miniconda/envs/earlgrey'

    input:
    path genome_asm
    val species_name

    output:
    path 'EarlGrey'

    script:
    """
    earlGrey -g ${genome_asm} \
    -s ${species_name} \
    -o EarlGrey \
    -d yes \
    -r eukarya \
    -t {params.nthreads}
    """
}
