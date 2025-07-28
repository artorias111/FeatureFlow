#!/usr/bin/env python3

import argparse
import os
import re
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('--rna_dir', type=str, required=True)
args = parser.parse_args()

rna_path = Path(args.rna_dir).resolve()
files_list = os.listdir(rna_path)

ID_list = []

for f in files_list:
    if '.fastq.gz' in f:
        curr_file = f
        original_file = rna_path / f 
 
        # Handle SRA-style files: SRR123456_1.fastq.gz, SRR123456_2.fastq.gz
        if '_1.fastq.gz' in curr_file:
            # Create symlink with the base name + _1.fastq.gz
            base_name = curr_file.replace('_1.fastq.gz', '')
            symlink_name = f"{base_name}_1.fastq.gz"
            # Remove existing symlink if it exists
            if Path(symlink_name).exists():
                Path(symlink_name).unlink()
            Path(symlink_name).symlink_to(original_file)
            curr_file = symlink_name

        elif '_2.fastq.gz' in curr_file:
            # Create symlink with the base name + _2.fastq.gz
            base_name = curr_file.replace('_2.fastq.gz', '')
            symlink_name = f"{base_name}_2.fastq.gz"
            # Remove existing symlink if it exists
            if Path(symlink_name).exists():
                Path(symlink_name).unlink()
            Path(symlink_name).symlink_to(original_file)
            curr_file = symlink_name
       
        # Handle Illumina-style files: sample_R1_001.fastq.gz, sample_R2_001.fastq.gz
        elif '_R1_' in curr_file:
            # Create symlink with simplified name: sample_1.fastq.gz
            simplified_name = re.sub(r'_R1_\d+\.fastq\.gz', '_1.fastq.gz', curr_file)
            # Remove existing symlink if it exists
            if Path(simplified_name).exists():
                Path(simplified_name).unlink()
            Path(simplified_name).symlink_to(original_file)
            curr_file = simplified_name
            
        elif '_R2_' in curr_file:
            # Create symlink with simplified name: sample_2.fastq.gz
            simplified_name = re.sub(r'_R2_\d+\.fastq\.gz', '_2.fastq.gz', curr_file)
            # Remove existing symlink if it exists
            if Path(simplified_name).exists():
                Path(simplified_name).unlink()
            Path(simplified_name).symlink_to(original_file)
            curr_file = simplified_name

        # If no pattern matches, just use the original filename
        else:
            # Remove existing symlink if it exists
            if Path(curr_file).exists():
                Path(curr_file).unlink()
            Path(curr_file).symlink_to(original_file)

    else:
        continue # ignore non-fastq.gz files

    # Extract base name by removing _1.fastq.gz or _2.fastq.gz suffixes
    if curr_file.endswith('_1.fastq.gz'):
        base_id = curr_file.replace('_1.fastq.gz', '')
    elif curr_file.endswith('_2.fastq.gz'):
        base_id = curr_file.replace('_2.fastq.gz', '')
    else:
        # For files that don't match the expected patterns, use the name as is
        base_id = curr_file
    
    ID_list.append(base_id)

# Remove duplicates and print
ID_list = list(set(ID_list))
print(",".join(map(str, ID_list)))
