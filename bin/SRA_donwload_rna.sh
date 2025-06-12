SRR_LIST="SRR6794060 SRR6794061 SRR6794062 SRR6794063 SRR6794064 SRR6794065 SRR6794066 SRR6794067 SRR6794068 SRR6794069 SRR6794070 SRR6794071"

for srr in $SRR_LIST; do
    echo "Downloading and splitting $srr..."
    fasterq-dump --split-files $srr &
done

echo "All downloads started in background. Waiting for them to complete..."
wait

echo "All background downloads complete."


# Step 2: Compress the generated .fastq files using pigz
# This finds all .fastq files and compresses them in parallel.
find . -maxdepth 1 -name "*.fastq" -print0 | xargs -0 pigz

echo "Compression complete."
