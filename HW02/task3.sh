#!/usr/bin/env bash

#SBATCH -p instruction
#SBATCH -t 0-00:10:00
#SBATCH -J task3-run
#SBATCH -o task3-%j.out
#SBATCH -e task3-%j.err
#SBATCH -c 1
#SBATCH --mem=1G

set -euo pipefail

cd "$(dirname "$0")"

g++ task3.cpp matmul.cpp -Wall -O3 -std=c++17 -o task3
./task3
