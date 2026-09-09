#!/usr/bin/env python3

import argparse
import sys


def clean_name(text):
    for ch in ",;=&":
        text = text.replace(ch, " ")
    return " ".join(text.split())


def parse_attributes(field):
    attrs = {}
    for part in field.rstrip(";").split(";"):
        if not part:
            continue
        key, _, value = part.partition("=")
        attrs[key] = value
    return attrs


def load_interpro_names(path):
    names = {}
    with open(path) as handle:
        for line in handle:
            if line.startswith("#"):
                continue
            fields = line.rstrip("\n").split("\t")
            if len(fields) < 13:
                continue
            description = fields[12].strip()
            if not description or description == "-":
                continue
            names.setdefault(fields[0], set()).add(clean_name(description))
    return names


def map_genes_to_names(path, protein_names):
    gene_names = {}
    matched = set()
    with open(path) as handle:
        for line in handle:
            if line.startswith("#"):
                continue
            fields = line.rstrip("\n").split("\t")
            if len(fields) < 9 or fields[2] not in ("mRNA", "transcript"):
                continue
            attrs = parse_attributes(fields[8])
            transcript = attrs.get("ID")
            parent = attrs.get("Parent")
            if transcript not in protein_names or not parent:
                continue
            matched.add(transcript)
            for gene in parent.split(","):
                gene_names.setdefault(gene, set()).update(protein_names[transcript])
    return gene_names, matched


def add_name(field, value):
    parts = [p for p in field.rstrip(";").split(";") if p]
    replaced = False
    for i, part in enumerate(parts):
        if part.startswith("Name="):
            parts[i] = "Name=" + value
            replaced = True
    if not replaced:
        parts.append("Name=" + value)
    return ";".join(parts)


def write_gff(path, gene_names, out):
    named = 0
    with open(path) as handle:
        for line in handle:
            if line.startswith("#"):
                out.write(line)
                continue
            fields = line.rstrip("\n").split("\t")
            if len(fields) < 9 or fields[2] != "gene":
                out.write(line)
                continue
            attrs = parse_attributes(fields[8])
            names = gene_names.get(attrs.get("ID"))
            if not names:
                out.write(line)
                continue
            fields[8] = add_name(fields[8], ",".join(sorted(names)))
            out.write("\t".join(fields) + "\n")
            named += 1
    return named


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("interpro_tsv")
    parser.add_argument("gff")
    parser.add_argument("-o", "--output")
    args = parser.parse_args()

    protein_names = load_interpro_names(args.interpro_tsv)
    gene_names, matched = map_genes_to_names(args.gff, protein_names)

    out = open(args.output, "w") if args.output else sys.stdout
    named = write_gff(args.gff, gene_names, out)
    if args.output:
        out.close()

    sys.stderr.write("proteins with interpro names: %d\n" % len(protein_names))
    sys.stderr.write("matched to gff transcripts: %d\n" % len(matched))
    sys.stderr.write("unmatched: %d\n" % (len(protein_names) - len(matched)))
    sys.stderr.write("genes named: %d\n" % named)
    if protein_names and not matched:
        sys.stderr.write("warning: no interpro accession matched any mRNA ID\n")


if __name__ == "__main__":
    main()
