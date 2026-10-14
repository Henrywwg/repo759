#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J HW03_task2

#SBATCH -o HW03_task2.out -e HW03_task2.err

#SBATCH -c 20

g++ task2.cpp convolution.cpp -Wall -O3 -std=c++17 -o task2 -fopenmp

: > task2_results.txt

for i in {1..20}
do
    output=$(./task2 1024 "$i") || exit 1
    printf '%s\n' "$output" | awk '
        NR == 1 { first = $0 }
        NR == 2 { second = $0 }
        NR == 3 { printf "%s, %s, %s\n", first, second, $0 }
    ' >> task2_results.txt
done