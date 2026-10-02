#!/usr/bin/env bash

#SBATCH -p instruction
#SBATCH -t 0-00:10:00
#SBATCH -J task2-run
#SBATCH -o task2.out
#SBATCH -e task2.err
#SBATCH -c 1
#SBATCH --mem=1G


g++ convolution.cpp task2.cpp -Wall -O3 -std=c++17 -o task2
./task2 2048 3
