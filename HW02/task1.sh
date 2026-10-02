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

python3 - "$results" "$plot" <<'PY'
import sys

import matplotlib.pyplot as plt

results_path, plot_path = sys.argv[1:3]
n_values = []
time_values = []

with open(results_path, encoding="utf-8") as results:
    for line in results:
        n, milliseconds = line.split()
        n_values.append(int(n))
        time_values.append(float(milliseconds))

plt.plot(n_values, time_values, marker="o")
plt.xlabel("n")
plt.ylabel("Time (milliseconds)")
plt.title("Task 1 scan time")
plt.grid(True)
plt.tight_layout()
plt.savefig(plot_path)
PY
