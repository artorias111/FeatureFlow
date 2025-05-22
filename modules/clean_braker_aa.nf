#!/usr/bin/env nextflow

process cleanBrakerAA {
    input:
    path braker_aa

    output:
    path 'braker.aa.cleaned.fa'

    script:
    """
    cat ${braker_aa} | tr -d "*" > braker.aa.cleaned.fa
    """

}
