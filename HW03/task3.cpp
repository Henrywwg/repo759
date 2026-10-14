#include "msort.h"
#include <iostream>
#include <random>
#include <chrono>
#include <string>

int main(int argc, char* argv[]) {

    std::size_t n = std::stoi(argv[1]);
    if(n < 1){
        return 1;
    }
    std::size_t t = std::stoi(argv[2]);
    if((t < 1) || (t > 20)){
        return 1;
    }
    std::size_t ts = std::stoi(argv[3]);
    if(ts < 1){
        return 1;
    }

    omp_set_num_threads(t);

    // timing stuff
    std::chrono::high_resolution_clock::time_point start;
    std::chrono::high_resolution_clock::time_point end;
    std::chrono::duration<double, std::milli> duration_sec;

    const auto now = std::chrono::high_resolution_clock::now()
                     .time_since_epoch()
                     .count();

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> distrib(-1000, 1000);

    // Allocate mem for io arrays
    int *input = new int[n];  // allocate extra space for padding

    // Initialize input array
    for (std::size_t i = 0; i < n; i++) 
        input[i] = distrib(gen);
    

    // start timer
    start = std::chrono::high_resolution_clock::now();

    // merge sort
    msort(input, n, ts);

    // end timer
    end = std::chrono::high_resolution_clock::now();

        duration_sec = std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start);


    std::cout << input[0] << std::endl;
    std::cout << input[n - 1] << std::endl;
    std::cout << duration_sec.count() << std::endl;

    return 0;

}