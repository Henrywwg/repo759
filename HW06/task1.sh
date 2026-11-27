#!/usr/bin/env bash

#SBATCH -p instruction
#SBATCH -t 0-00:30:00
#SBATCH -J hw06-task1
#SBATCH -o task1.out
#SBATCH -e task1.err
#SBATCH --ntasks=1
#SBATCH -c 1
#SBATCH --mem=12G
#SBATCH --gpus-per-task=1

# HW06 task 1 scaling study (naive GPU matmul).
# Runs n = 2^5 ... 2^14 for two threads-per-block values and writes one CSV row
# per run to task1_results.csv: threads_per_block,n,last_element,time_ms

# Load CUDA, the only module the assignment allows. Done before "set -u"
# because Lmod's module function can fail on unset variables.
module load nvidia/cuda

set -euo pipefail

# Compile command from the assignment
nvcc task1.cu matmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o task1

results="task1_results.csv"
echo "threads_per_block,n,last_element,time_ms" > "$results"

# 1024 threads per block is required; 256 is the second value of our choice
for tpb in 1024 256; do
    for exp in $(seq 5 14); do
        n=$((1 << exp))

        # task1 prints two lines: last element of C, then time in ms
        output=$(./task1 "$n" "$tpb")
        last=$(sed -n '1p' <<< "$output")
        time_ms=$(sed -n '2p' <<< "$output")

        echo "${tpb},${n},${last},${time_ms}" >> "$results"
        echo "tpb=${tpb} n=${n} time=${time_ms} ms"
    done
done

echo "Wrote ${results}"
