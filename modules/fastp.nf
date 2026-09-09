process trimPairedReads {
    conda params.fastp_env

    input:
    tuple  val(id), path(reads1), path(reads2)

    output:
    tuple path("${id}.R1.trimmed.fastq.gz"), path("${id}.R2.trimmed.fastq.gz"), emit: trimmed_read_pair

    script:
    """
    fastp -i $reads1 -I $reads2 -o ${id}.R1.trimmed.fastq.gz -O ${id}.R2.trimmed.fastq.gz
    """
}
