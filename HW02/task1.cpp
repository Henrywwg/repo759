#include <iostream>
#include <random>
#include <chrono>
#include "scan.h"

int main(int argc, char* argv[]) {

    std::size_t n = std::stoi(argv[1]);

    // timing stuff
    std::chrono::high_resolution_clock::time_point start;
    std::chrono::high_resolution_clock::time_point end;
    std::chrono::duration<double, std::milli> duration_sec;
    
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<float> dis(-1.0f, 1.0f);

    // Allocate mem for io arrays
    float *input = new float[n];
    float *output = new float[n];

    // Initialize input array
    for (std::size_t i = 0; i < n; i++) {
        input[i] = dis(gen);
    }

    // timing
    start = std::chrono::high_resolution_clock::now();

    // run scan
    scan(input, output, n);

    // timing
    end = std::chrono::high_resolution_clock::now();

    duration_sec = std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start);

    std::cout << duration_sec.count() << std::endl;
    std::cout << output[0] << std::endl;
    std::cout << output[n - 1] << std::endl;

    // Free memory
    delete[] (input);
    delete[] (output);

    return 0;
}
