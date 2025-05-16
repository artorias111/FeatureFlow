# FeatureFlow
A pipeline for genome annotation including repeat masking, gene prediction, and functional annotation.

## Prerequisites

- Nextflow: `conda activate /data2/work/local/miniconda/envs/nextflow`
- Access to reference data (protein references, RNA-seq reads for genome annotation)
- RNA-seq reads for annotation must all be in one directory, which is passed to the script with the `--rna-reads` flag

## Quick Start

```bash
# Load nextflow onto your environment
conda activate /data2/work/local/miniconda/envs/nextflow

# clone this repo
git clone
cd FeatureFlow
# Run FeatureFlow
nextflow run annotate.nf --genome_assembly /path/to/my_genome.fa --rna-reads /path/to/rna/reads --nthreads 64

# Show help message
nextflow run annotate.nf --help
```

## Common Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--genome_assembly` | Path to genome assembly FASTA file | Set in `nextflow.config` |
| `--nthreads` | Number of CPU threads to use | 32 |
| `--rna_reads` | Path to RNA-seq reads directory | Set in `nextflow.config` |
| `--protein_ref` | Path to reference proteins FASTA file | Set in `nextflow.config` |

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

## Pipeline overview
<img width="726" alt="image" src="https://github.com/user-attachments/assets/fe559abc-fcb9-4d01-9c89-90c56a6fc957" />


