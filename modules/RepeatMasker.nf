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
    path "${genome_assembly}.masked"

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
