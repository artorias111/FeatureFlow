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
 
        if '_1.fastq' in curr_file:  # Check if they're SRA files first
            Path(curr_file).symlink_to(original_file)
            curr_file = curr_file.replace('_1.fastq.gz', '') # this line is screwed up

        elif '_2.fastq' in curr_file: 
            Path(curr_file).symlink_to(original_file)
            curr_file = curr_file.replace('_2.fastq.gz', '') # this line is screwed up
       
        elif 'R1' in f:
            Path(curr_file).symlink_to(original_file)
            curr_file = re.sub(r'R1.*?\.fastq\.gz', '1.fastq.gz', f)

        elif 'R2' in f:
            Path(curr_file).symlink_to(original_file)
            curr_file = re.sub(r'R2.*?\.fastq\.gz', '2.fastq.gz', f)

    else:
        continue # ignore non-fastq.gz files

    ID_list.append(curr_file)
    # print(curr_file) # dbg - there's a problem here!


ID_list = set(ID_list)

print(",".join(map(str, ID_list)))
