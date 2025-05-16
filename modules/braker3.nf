process runBraker3 {
    publishDir 'results/Braker3', mode: 'copy'
    container "${params.braker_docker_image}"
    containerOptions "--bind /data2/work/local/braker3/config:/augustus_config"
    
    input:
    path masked_assembly
    path rna_reads
    path protein_ref
    val ID_list
    
    output:
    path 'braker/*'
    path 'braker/braker.gff3', emit :braker_annots
    
    script:
    """
    mkdir -p augustus_config_dir/species
    cp -rv /opt/Augustus/config/* augustus_config_dir/
    export AUGUSTUS_CONFIG_PATH=\${PWD}/augustus_config_dir


    braker.pl --genome=${masked_assembly} \
    --prot_seq=${protein_ref} \
    --rnaseq_sets_ids=${ID_list} \
    --rnaseq_sets_dirs=${rna_reads} \
    --gff3 --threads=${params.nthreads} \
    --softmasking \
    --AUGUSTUS_CONFIG_PATH=${PWD}/augustus_config_dir
    """
}


process getRnaIDs {

    input:
    path rna_reads
    
    output:
    stdout emit: ID_list
    
    script:
    """
    ls ${rna_reads} | grep "_1" | sed 's/_1.*//' | paste -sd, - | tr -d '\n'
    """
}

