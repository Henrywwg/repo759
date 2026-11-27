#!/usr/bin/env bash

#SBATCH -p instruction
#SBATCH -t 0-00:30:00
#SBATCH -J hw06-task2
#SBATCH -o task2.out
#SBATCH -e task2.err
#SBATCH --ntasks=1
#SBATCH -c 1
#SBATCH --mem=12G
#SBATCH --gpus-per-task=1

# HW06 task 2 scaling study (1D stencil with shared memory).
# Runs n = 2^10 ... 2^29 with R = 128 for two threads-per-block values and writes
# one CSV row per run to task2_results.csv: threads_per_block,n,R,last_element,time_ms
# Memory: at n = 2^29 the host image and output arrays take 2 GB each.

# Load CUDA, the only module the assignment allows. Done before "set -u"
# because Lmod's module function can fail on unset variables.
module load nvidia/cuda

set -euo pipefail

# Compile command from the assignment
nvcc task2.cu stencil.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o task2

R=128
results="task2_results.csv"
echo "threads_per_block,n,R,last_element,time_ms" > "$results"

# 1024 threads per block is required. The second value must be >= 2R + 1 = 257
# (stencil.cuh assumption), so 512 rather than something like 256.
for tpb in 1024 512; do
    for exp in $(seq 10 29); do
        n=$((1 << exp))

        # task2 prints two lines: last element of output, then time in ms
        output=$(./task2 "$n" "$R" "$tpb")
        last=$(sed -n '1p' <<< "$output")
        time_ms=$(sed -n '2p' <<< "$output")

        echo "${tpb},${n},${R},${last},${time_ms}" >> "$results"
        echo "tpb=${tpb} n=${n} time=${time_ms} ms"
    done
done

echo "Wrote ${results}"
