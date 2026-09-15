#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J FirstSlurm

#SBATCH -o task6.out -e task6.err

#SBATCH -c 2

g++ task6.cpp -Wall -O3 -std=c++17 -o task6

./task6 6