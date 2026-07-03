# FeatureFlow

Automated genome annotation pipeline: repeat masking → structural annotation → functional annotation. Runs on the Polar2020 cluster.

---

## Quick Start

**1. Copy the params template**
```bash
cp params_template.yaml params.yaml
```

**2. Fill in your params.yaml**
```yaml
species_id: "MySpecies1"              # a short label for your species
genome_assembly: "/path/to/genome.fasta"  # not needed if using gene_annotation_gff + transcript_aa_fasta

# Optional — leave as null if you don't have these
masked_genome: null        # skip repeat masking if you already have a masked genome
rna_reads: null            # directory containing R1/R2 fastq files
bam: null                  # pre-aligned RNA-seq BAM (use instead of rna_reads)
gene_annotation_gff: null  # skip straight to functional annotation if you already have a GFF
transcript_aa_fasta: null  # required alongside gene_annotation_gff above

busco_lineage: "eukaryota_odb12"
nthreads: 16
```

**3. Run**
```bash
nextflow run artorias111/FeatureFlow -params-file params.yaml
```

Results will appear in the `results/` directory.

---

## Run Modes

The pipeline figures out what to run based on what you provide. You don't need to set any mode flags.

| What you provide | What the pipeline does |
|---|---|
| `genome_assembly` | Full pipeline: mask genome → structural annotation (protein-only) → functional annotation |
| + `rna_reads` or `bam` | Same as above but uses RNA evidence in structural annotation |
| + `masked_genome` | Skips repeat masking, uses your masked genome directly |
| `gene_annotation_gff` + `transcript_aa_fasta` (no genome needed) | Skips everything, runs functional annotation only |

---

## Output

Results are in `results/`, organized by tool:

- `results/EarlGrey/` — repeat-masked genome and TE annotations
- `results/Braker4/` — structural annotation (GFF3 + protein sequences)
- `results/InterPro/` — functional domain annotations
- `results/BUSCO/` — annotation completeness assessment

The `work/` directory contains Nextflow's intermediate files — you can ignore it.

---

## Notes

- Do not edit `nextflow.config`. It contains hardcoded paths to Polar2020's shared dependencies (Dfam, InterProScan, Singularity caches, etc.).
- BAM files must be coordinate-sorted. If you have multiple BAMs, you can use a glob: `bam: "/path/to/rnaseq/*.bam"`.
- If you leave both `rna_reads` and `bam` as null, BRAKER4 will run in protein-only mode.

---

## Tools

- [EarlGrey](https://github.com/TobyBaril/EarlGrey) — transposable element annotation and masking
- [BRAKER4](https://github.com/Gaius-Augustus/BRAKER4) — structural gene annotation
- [InterProScan](https://github.com/ebi-pf-team/interproscan) — functional domain annotation
- [AGAT](https://github.com/NBISweden/AGAT) — GFF parsing and merging
- [BUSCO](https://gitlab.com/ezlab/busco) — annotation completeness
