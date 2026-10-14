#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J HW03_task3

#SBATCH -o HW03_task3.out -e HW03_task3.err

#SBATCH -c 20

g++ task1.cpp matmul.cpp -Wall -O3 -std=c++17 -o task1 -fopenmp

: > task1_results.txt

for i in {1..20}
do
    output=$(./task1 1024 "$i") || exit 1
    printf '%s\n' "$output" | awk '
        NR == 1 { first = $0 }
        NR == 2 { second = $0 }
        NR == 3 { printf "%s, %s, %s\n", first, second, $0 }
    ' >> task1_results.txt
done