#!/usr/bin/env bash

#SBATCH -p instruction
#SBATCH -t 0-00:30:00
#SBATCH -J task1-timing
#SBATCH -o task1.out
#SBATCH -e task1.err
#SBATCH -c 1
#SBATCH --mem=12G
#SBATCH --gpus-per-task=1

set -euo pipefail

nvcc task1.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task1

./task1