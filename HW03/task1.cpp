#include <iostream>
#include <random>
#include <chrono>
#include "matmul.h"
#include <algorithm>

int main(int argc, char* argv[]) {


    std::size_t n = std::stoi(argv[1]);
    if(n < 1){
        return 1;
    }
    std::size_t t = std::stoi(argv[2]);
    if((t < 1) || (t > 20)){
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

    std::mt19937 gen(static_cast<std::mt19937::result_type>(now));

    // std::random_device rd;
    // std::mt19937 gen(rd());
    std::uniform_real_distribution<float> dis(-10.0f, 10.0f);
    std::uniform_real_distribution<float> dis2(-1.0f, 1.0f);

    // Allocate mem for io arrays
    float *a = new float[n*n];  // allocate extra space for padding
    float *b = new float[n*n];
    float *c = new float[n*n];
    std::vector<float> A(n * n);
    std::vector<float> B(n * n);

    // Initialize input arrays
    for (std::size_t i = 0; i < n; i++) {
        for (std::size_t j = 0; j < n; j++) {
            double a_val = dis(gen);
            double b_val = dis2(gen);

            A.at(i * n + j) = a_val;
            a[i * n + j] = a_val;

            B.at(i * n + j) = b_val;
            b[i * n + j] = b_val;

            c[i * n + j] = 0;
        }
    }

 
    start = std::chrono::high_resolution_clock::now();

    mmul(a, b, c, n);
    // timing
    end = std::chrono::high_resolution_clock::now();

    duration_sec = std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start);

    std::cout << c[0] << std::endl;
    std::cout << c[n*n - 1] << std::endl;
    std::cout << duration_sec.count() << std::endl;
    


    // Free memory
    delete[] (a);
    delete[] (b);
    delete[] (c);

    return 0;
}
