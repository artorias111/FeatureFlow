process trimPairedReads {
    tag "$id"
    conda params.fastp_env

    cpus {
        def n = (params.nthreads as int).intdiv(4)
        if( n < 1 ) {
            return 1
        } else if( n > 16 ) {
            return 16
        } else {
            return n
        }
    }

    input:
    tuple val(id), path(reads1), path(reads2)

    output:
    tuple path("${id}_R1.trimmed.fastq.gz"), path("${id}_R2.trimmed.fastq.gz"), emit: trimmed_read_pair

    script:
    """
    fastp -w ${task.cpus} -i $reads1 -I $reads2 -o ${id}_R1.trimmed.fastq.gz -O ${id}_R2.trimmed.fastq.gz
    """
}
