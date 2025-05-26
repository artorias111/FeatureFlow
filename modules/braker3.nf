#!/usr/bin/env nextflow


process runBraker3 {
    publishDir 'results/Braker3', mode: 'copy'
    container "${params.braker_docker_image}"
    containerOptions "--bind /data2/work/local/braker3/config:/augustus_config"

    cpus {
        // Make sure nthreads does not exceed 48, GeneMark doesn't like it

        if(params.nthreads < 48) {
            return params.nthreads
        } else {
            return 48
        }
    }

    input:
    path masked_assembly
    path rna_reads
    path protein_ref
    val ID_list
    
    output:
    path 'braker/*'
    path 'braker/braker.gff3', emit :braker_annots
    path 'braker/braker.aa', emit: aa_seqs
    
    script:
    """
    mkdir -p augustus_config_dir/species
    cp -rv /opt/Augustus/config/* augustus_config_dir/
    export AUGUSTUS_CONFIG_PATH=\${PWD}/augustus_config_dir


    braker.pl --genome=${masked_assembly} \
    --prot_seq=${protein_ref} \
    --rnaseq_sets_ids=${ID_list} \
    --rnaseq_sets_dirs=${rna_reads} \
    --gff3 --threads=${task.cpus} \
    --softmasking \
    --AUGUSTUS_ab_initio \
    --AUGUSTUS_CONFIG_PATH=${PWD}/augustus_config_dir \
    --busco_lineage=actinopterygii
    """
}


process getRnaIDs {

    input:
    path rna_reads
    
    output:
    stdout emit: ID_list
    
    script:
    """
    ls -1 ${rna_reads} | grep "_1" | sed 's/_1.*//' | sort | uniq | paste -sd, - | tr -d '\n'
    """
}
