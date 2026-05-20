# FeatureFlow

A pipeline to annotate genome assemblies automatically using Earlgrey and Braker4, complete with functional annotation (Interpro)

## Usage

This pipeline is designed to be run on the Polar2020 cluster. The parameters you need to fill in are managed via a custom YAML config file. The pipeline automatically routes the workflow based on the files you provide, so you don't need to pass any complicated mode flags.

Note: do not modify or edit `nextflow.config` unless you know what you're doing. These contain the hardcoded dependency paths (Dfam, Interpro, Singularity caches, etc.) specific to Polar2020.

1. Copy the template: copy `params_template.yaml` to `params.yaml`.
2. Fill in the paths to your genome assembly, masked assembly (optional), and path to a directory with all rna-seq reads (optional). If you are skipping a file (e.g., you don't have RNA reads), leave it as `null`.
3. Run with Nextflow, passing your config file with `-params-file`.

```bash
nextflow run artorias111/FeatureFlow -params-file params.yaml
# you can name params.yaml to whatever you'd like, this is an example
```

#### Run Modes (Auto-Routed)

FeatureFlow dynamically builds the pipeline based on what you put in `params.yaml`.

* **Full Pipeline**: Provide `genome_assembly`, `protein_ref`, and `rna_reads`. The pipeline will mask the genome with Earlgrey, run Braker4 with both RNA and protein evidence, and finish with functional annotation.
* **Skip Masking**: Provide a `masked_genome` alongside your `genome_assembly`. The pipeline will skip Earlgrey and feed your provided masked genome directly into Braker4.
* **Protein-Only Mode**: Leave `rna_reads` as `null` or empty. Braker4 will automatically fall back to protein-only evidence for structural annotation. 

#### Results

Results are executed in the `work` directory, but you have access to clean symlinks of the actual files organized in the `results` directory, so you're not lost in the sea of hex-coded directories in `work`.

#### Tools used in the pipeline

* Earlgrey (https://github.com/TobyBaril/EarlGrey)
* Braker4 (https://github.com/Gaius-Augustus/BRAKER4)
* InterProScan (https://github.com/ebi-pf-team/interproscan)
* AGAT (https://github.com/NBISweden/AGAT)
* BUSCO (https://gitlab.com/ezlab/busco)
