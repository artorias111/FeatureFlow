# ChengLab Feature Flow Pipeline

A Nextflow pipeline for genome annotation including repeat masking, gene prediction, and functional annotation.

## Prerequisites

- Nextflow (21.10.0 or later)
- Conda or Singularity (for tool dependencies)
- Access to reference data (Dfam, protein references)

## Quick Start

```bash
# Run with default parameters
nextflow run annotate.nf

# Run with custom genome assembly and threads
nextflow run annotate.nf --genome_assembly /path/to/my_genome.fa --nthreads 16

# Resume a previous run after fixing errors
nextflow run annotate.nf --genome_assembly /path/to/my_genome.fa -resume

# Show help message
nextflow run annotate.nf --help
```

## Common Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--genome_assembly` | Path to genome assembly FASTA file | Set in nextflow.config |
| `--nthreads` | Number of CPU threads to use | 32 |
| `--rna_reads` | Path to RNA-seq reads directory | Set in nextflow.config |
| `--protein_ref` | Path to reference proteins FASTA file | Set in nextflow.config |

## Output

The pipeline generates annotated genome files in the `results` directory, including:

- Repeat-masked genome sequences
- Gene predictions
- Functional annotations
- Protein and transcript sequences

## Advanced Usage

For advanced configuration options, see the help message:

```bash
nextflow run annotate.nf --help
```
