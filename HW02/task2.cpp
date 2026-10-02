#include <iostream>
#include <random>
#include <chrono>
#include "convolution.h"

int main(int argc, char* argv[]) {

    std::size_t n = std::stoi(argv[1]);
    std::size_t m = std::stoi(argv[2]);

    // timing stuff
    std::chrono::high_resolution_clock::time_point start;
    std::chrono::high_resolution_clock::time_point end;
    std::chrono::duration<double, std::milli> duration_sec;

    const auto now = std::chrono::high_resolution_clock::now()
                     .time_since_epoch()
                     .count();

    std::mt19937 gen(static_cast<std::mt19937::result_type>(now));

    // std::random_device rd;
    // std::mt19937 gen(rd());
    std::uniform_real_distribution<float> dis(-10.0f, 10.0f);
    std::uniform_real_distribution<float> dis2(-1.0f, 1.0f);

    // Allocate mem for io arrays
    float *input = new float[(2+n)*(2+n)];  // allocate extra space for padding
    float *mask = new float[m*m];
    float *output = new float[n*n];

    // Initialize input array
    for (std::size_t i = 0; i < n+2; i++) {
        for (std::size_t j = 0; j < n+2; j++) {
            if ((i == 0 && j == 0) || ((i == 0) && (j == (n+1))) || ((i == (n + 1)) && (j == 0)) || ((i == (n + 1)) && (j == (n + 1)))){   //corners get zero
                input[i * (n+2) + j] = 0;
            }
            else if ((i == 0) || (i == (n + 1)) || (j == 0) || (j == (n + 1))){   //edges get one
                input[i * (n+2) + j] = 1;
            }
            else{
                input[i * (n+2) + j] = dis(gen);
            }
        }
    }
    // Initialize mask array
    for (std::size_t i = 0; i < m*m; i++) {
        mask[i] = dis2(gen);
    }

    for(int i = 0; i < (n*n); i++){
        output[i] = 0;
    }

    /*  For debug/testing
    {   
        input[7] = 1; input[8] = 3; input[9] = 4; input[10] = 8;
        input[13] = 6; input[14] = 5; input[15] = 2; input[16] = 4;
        input[19] = 3; input[20] = 4; input[21] = 6; input[22] = 8;
        input[25] = 1; input[26] = 4; input[27] = 5; input[28] = 2;

        mask[0] = 0; mask[1] = 0; mask[2] = 1;
        mask[3] = 0; mask[4] = 1; mask[5] = 0;
        mask[6] = 1; mask[7] = 0; mask[8] = 0;
    }
    */
    
    // timing
    start = std::chrono::high_resolution_clock::now();

    // run convolve
    convolve(input, output, n, mask, m);

    // timing
    end = std::chrono::high_resolution_clock::now();

    duration_sec = std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start);

    std::cout << duration_sec.count() << std::endl;
    std::cout << output[0] << std::endl;
    std::cout << output[n*n - 1] << std::endl;

    // Free memory
    delete[] (input);
    delete[] (output);

    return 0;
}
