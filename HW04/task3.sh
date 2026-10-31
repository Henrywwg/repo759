#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH -t 0-00:30:00
#SBATCH -J HW04_task3
#SBATCH -o HW04_task3.out
#SBATCH -e HW04_task3.err
#SBATCH -c 8

set -e

g++ task3.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

results_file="task3_results.csv"
printf 'num_threads,time_ms\n' > "$results_file"

for num_threads in {1..8}
do
    output=$(./task3 1000 100 "$num_threads" 2>&1)
    time_ms=$(printf '%s\n' "$output" | awk '$1 == "time:" { sub(/ms$/, "", $2); print $2; exit }')

    if [[ -z "$time_ms" ]]
    then
        printf '%s\n' "$output" >&2
        printf 'Unable to parse execution time for %s threads\n' "$num_threads" >&2
        exit 1
    fi

    printf '%s,%s\n' "$num_threads" "$time_ms" >> "$results_file"
done
