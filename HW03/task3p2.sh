#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J HW03_task3p2

#SBATCH -o HW03_task3p2.out -e HW03_task3p2.err

#SBATCH -c 20

g++ task3.cpp msort.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

: > task3p2_results.txt

for i in {1..20}
do
    output=$(./task3 1000000 "$i" "extract value from task3p1") || exit 1
    printf '%s\n' "$output" | awk '
        NR == 1 { first = $0 }
        NR == 2 { second = $0 }
        NR == 3 { printf "%s, %s, %s\n", first, second, $0 }
    ' >> task3p2_results.txt
done