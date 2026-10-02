#!/usr/bin/env bash

#SBATCH -p instruction
#SBATCH -t 0-00:10:00
#SBATCH -J task3-run
#SBATCH -o task3.out
#SBATCH -e task3.err
#SBATCH -c 1
#SBATCH --mem=1G


g++ task3.cpp matmul.cpp -Wall -O3 -std=c++17 -o task3
./task3
