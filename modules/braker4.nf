process runBraker4 {
    conda params.snakemake_env
    publishDir 'results/Braker4', mode: 'symlink'

    cpus {
        if(params.nthreads < 48) {
            return params.nthreads
        } else {
            return 48
        }
    }

    input:
    path genome_assembly
    path masked_assembly
    path rna_reads
    path protein_ref

    output:
    path "output/${params.species_id}"
    path "output/${params.species_id}/braker.gff3", emit: braker_annots
    path "output/${params.species_id}/braker.aa", emit: aa_seqs

    script:
    def r1_string = rna_reads.findAll { it.name.contains('_R1') || it.name.contains('_1.') || it.name.contains('_1.fq') }.sort { it.name }.join(':')
    def r2_string = rna_reads.findAll { it.name.contains('_R2') || it.name.contains('_2.') || it.name.contains('_2.fq') }.sort { it.name }.join(':')
    
    """
    cp ${projectDir}/assets/braker4/config.ini .

    touch samples.csv
    echo "sample_name,genome,genome_masked,protein_fasta,bam_files,fastq_r1,fastq_r2,sra_ids,varus_genus,varus_species,isoseq_bam,isoseq_fastq,busco_lineage,reference_gtf" > samples.csv

    echo "${params.species_id},${genome_assembly}",${masked_assembly},${protein_ref},,${r1_string},${r2_string},,,,,,${params.busco_lineage}, >> samples.csv

    snakemake \\
        --snakefile ${params.braker4_snakefile} \\
        --cores ${task.cpus} \\
        --use-singularity \\
        --singularity-prefix ${params.braker4_singularity} \\
        --singularity-args '${params.braker4_singularity_args}' \\
        --latency-wait 120 \\
        --restart-times 3
    """
}
