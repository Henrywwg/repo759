#include <iostream>
#include <random>
#include <chrono>
#include "matmul.h"

int main(int argc, char* argv[]) {


    std::size_t n = 1000;

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
    double *a = new double[n*n];  // allocate extra space for padding
    double *b = new double[n*n];
    double *c = new double[n*n];
    std::vector<double> A(n * n);
    std::vector<double> B(n * n);

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

    
    // timing
    {    
        start = std::chrono::high_resolution_clock::now();

        mmul1(a, b, c, n);
        // timing
        end = std::chrono::high_resolution_clock::now();

        duration_sec = std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start);

        std::cout << duration_sec.count() << std::endl;
        std::cout << c[0] << std::endl;
        std::cout << c[n*n - 1] << std::endl;
    }

    // Clear c for next multiplication
    std::fill(c, c + n * n, 0.0);

    // timing
    {    
        start = std::chrono::high_resolution_clock::now();

        mmul2(a, b, c, n);
        // timing
        end = std::chrono::high_resolution_clock::now();

        duration_sec = std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start);

        std::cout << duration_sec.count() << std::endl;
        std::cout << c[0] << std::endl;
        std::cout << c[n*n - 1] << std::endl;
    }

    // Clear c for next multiplication
    std::fill(c, c + n * n, 0.0);

        // timing
    {    
        start = std::chrono::high_resolution_clock::now();

        mmul3(a, b, c, n);
        // timing
        end = std::chrono::high_resolution_clock::now();

        duration_sec = std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start);

        std::cout << duration_sec.count() << std::endl;
        std::cout << c[0] << std::endl;
        std::cout << c[n*n - 1] << std::endl;
    }

    // Clear c for next multiplication
    std::fill(c, c + n * n, 0.0);

    // timing
    {    
        start = std::chrono::high_resolution_clock::now();

        mmul4(A, B, c, n);
        // timing
        end = std::chrono::high_resolution_clock::now();

        duration_sec = std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start);

        std::cout << duration_sec.count() << std::endl;
        std::cout << c[0] << std::endl;
        std::cout << c[n*n - 1] << std::endl;
    }


    // Free memory
    delete[] (a);
    delete[] (b);
    delete[] (c);

    return 0;
}
