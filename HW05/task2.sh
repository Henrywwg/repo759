#!/usr/bin/env bash

#SBATCH -p instruction
#SBATCH -t 0-00:30:00
#SBATCH -J task2
#SBATCH -o task2.out
#SBATCH -e task2.err
#SBATCH --ntasks=1
#SBATCH -c 1
#SBATCH --mem=12G
#SBATCH --gpus-per-task=1

set -euo pipefail

nvcc task2.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task2

./task2
