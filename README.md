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
git clone https://github.com/artorias111/FeatureFlow.git
cd FeatureFlow
# Run FeatureFlow
nextflow run annotate.nf --runMode full --genome_assembly /path/to/my_genome.fa --rna-reads /path/to/rna/reads --nthreads 64

# Run FeatureFlow in interpro mode
nextflow run annotate.nf --runMode interPro --braker_aa /path/to/braker.aa 

# Show help message
nextflow run annotate.nf --help
```

## Run Modes
FeatureFlow can be run in different modes, depending on the use case. A list of available Run Modes and use cases: 

| Run mode | Flag | Description |
|----------|------|-------------|
| full     | `--runMode full` | entire pipeline, requires `-g` and `-r` |
| braker | `--runMode braker` | only braker, expects you to provide a masked genome assembly via `-g`. Also requires `-r` |
|interPro | `--runMode interPro` | only interPro, expects you to provide an amino acid sequence file via `-a` |



## Common Parameters

| Parameter | Description |
|-----------|-------------|
| `--genome_assembly` or `-g` | Path to genome assembly FASTA file |
| `--nthreads` or `-n` | Number of CPU threads to use (default: `32`) |
| `--rna_reads` or `-r` | Path to RNA-seq reads directory | 
| `--protein_ref` or `-p` | Path to reference proteins FASTA file | 
|`--braker_aa` or `-a` |Path to a `braker.aa` (or any) amino acid fasta file |

## Output

When run in `full` mode, the pipeline generates annotated genome files in the `results` directory, including:
- Repeat-masked genome sequences
- Gene predictions
- Functional annotations
- Protein and transcript sequences

When run in any of the other modes, the outputs are all in the `results` directory, with subdirectories named accordingly. 

Another set of outputs includes the standard `work` directory produced by Nextflow pipelines. The directories are named according to the executor name of the process, and contain all the output files, and command logs (as `.command.*`) for each process. 


## Advanced Usage

For advanced configuration, you can edit the parameters directly in the `nextflow.config` file. However, this is not a recommended option, and is primarily targeted for development use only. For more information, see the help message:

```bash
nextflow run annotate.nf --help
```


