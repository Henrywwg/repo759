#!/usr/bin/env bash

#SBATCH -p instruction
#SBATCH -t 0-00:30:00
#SBATCH -J task3-scaling
#SBATCH -o task3.out
#SBATCH -e task3.err
#SBATCH --ntasks=1
#SBATCH -c 1
#SBATCH --mem=12G
#SBATCH --gpus-per-task=1

set -euo pipefail

nvcc task3.cu vscale.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task3

for i in {10..29}
do
    n=$((1 << i))
    ./task3 "$n"
done