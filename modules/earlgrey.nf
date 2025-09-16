process annotate_TEs { 
    publishDir 'results', mode: 'symlink'
    
    conda '/data2/work/local/miniconda/envs/earlgrey'

    input:
    path genome_asm
    val species_name

    output:
    path 'EarlGrey'
    path "EarlGrey/${species_name}EarlGrey/${species_name}_summaryFiles/${species_name}.softmasked.fasta", emit: masked_genome

    script:
    """
    earlGrey -g ${genome_asm} \
    -s ${species_name} \
    -o EarlGrey \
    -d yes \
    -t {params.nthreads}
    """
}
