#!/usr/bin/env nextflow


process createCuratedRepeats {
    publishDir 'results/CuratedRepeatsForRepeatMasker', mode: 'copy'

    input:
    path 'asm.db-families.fa'

    output:
    path 'curated_repeats.fa'

    script:
    """
    cat asm.db-families.fa $params.dfam_ref > curated_repeats.fa
    """

}

process MaskRepeats {
    conda '/data2/work/local/miniconda/envs/RepeatMask'

    publishDir 'results/RepeatMasker', mode: 'copy'

    input:
    path genome_assembly
    path "curated_repeats.fa"

    output:
    path "${genome_assembly}.masked", emit :masked_file
    path "${genome_assembly}.tbl", emit: rm_tbl_file
    path "${genome_assembly}.cat.gz", emit: rm_cat_file

    script:
    """
    ${params.repeatmasker}/RepeatMasker -a \
    -lib curated_repeats.fa ${genome_assembly} \
    -poly \
    -gff \
    -pa ${params.nthreads} \
    -xsmall 
    """
}

process createKimuraDivergencePlots {
    conda '/data2/work/local/miniconda/envs/RepeatMask'

    publishDir 'results/KimuraDivergence', mode: 'copy'
    
    input:
    path rm_cat_file
    path rm_tbl_file // Find the genome size from this file

    output:
    path 'KimuraDivergence.html'

    script:
    """
    # Find the genome size from tbl file
    genome_size=\$(grep "^total length" ${rm_tbl_file} | awk '{print \$3}')
    genome_ID=\$(basename ${params.genome_assembly})
    
    # calcDivergence from Align file
    ${params.repeatmasker}/calcDivergenceFromAlign.pl \
    -s \${genome_ID}.divsum \
    ${rm_cat_file}
    
    ${params.repeatmasker}/createRepeatLandscape.pl \
    -div \${genome_ID}.divsum \
    -g \${genome_size} > KimuraDivergence.html
    """
}
