process runBraker4 {
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
    // first, craete a samples.csv
    // save the ini file
    """

    """
}
