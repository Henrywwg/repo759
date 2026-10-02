#!/usr/bin/env bash

#SBATCH -p instruction
#SBATCH -t 0-00:30:00
#SBATCH -J task1-timing
#SBATCH -o task1.out
#SBATCH -e task1.err
#SBATCH -c 1
#SBATCH --mem=12G

set -euo pipefail

g++ scan.cpp task1.cpp -Wall -O3 -std=c++17 -o task1

results="task1-results-${SLURM_JOB_ID:-local}.dat"
plot="task1.pdf"
trap 'rm -f "$results" task1' EXIT

: > "$results"

for exponent in $(seq 10 30); do
    n=$((2 ** exponent))
    time_ms=$(./task1 "$n" | sed -n '1p')
    printf '%s %s\n' "$n" "$time_ms" >> "$results"
done

gnuplot <<GNUPLOT
set terminal pdf
set output "$plot"
set xlabel "n"
set ylabel "Time (milliseconds)"
set title "Task 1 scan time"
set grid
plot "$results" using 1:2 with linespoints title "scan"
GNUPLOT
