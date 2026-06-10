process runBrakerBusco {
    publishDir 'results/Braker3', mode: 'symlink'

    conda '/data2/work/local/miniconda/envs/busco583'

    input:
    path braker_aa

    output:
    path 'busco_output', emit: busco_output

    script:
    """
    busco -i ${braker_aa} -o busco_output \
    -m prot \
    -l ${params.busco_lineage} \
    --download_path ${params.busco_download_path} \
    -c ${params.nthreads} --offline
    """
}
