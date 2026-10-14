#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J HW03_task3p1

#SBATCH -o HW03_task3p1.out -e HW03_task3p1.err

#SBATCH -c 20

g++ task3.cpp msort.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

: > task3p1_results.txt

for i in {1..10}
do
    split_threshold=$((1 << i))
    output=$(./task3 1000000 8 "$split_threshold") || exit 1
    printf '%s\n' "$output" | awk '
        NR == 1 { first = $0 }
        NR == 2 { second = $0 }
        NR == 3 { printf "%s, %s, %s\n", first, second, $0 }
    ' >> task3p1_results.txt
done