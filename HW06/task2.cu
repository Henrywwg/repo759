#include "stencil.cuh"
#include <iostream>
#include <chrono>
#include <random>
#include <string>

int main (int argc, char **argv) {
    // Check command line arguments
    if (argc != 4) {
        std::cout << "./task2 <n> <R> <threads per block>" << std::endl;
        return 1;
    }

    // Parse inputs
    int n = std::stoi(argv[1]);
    int R = std::stoi(argv[2]);
    int threads_per_block = std::stoi(argv[3]);

    // Mask length; parenthesized wherever it is multiplied by sizeof(float)
    const int mask_len = 2 * R + 1;

    // Get the current time for RNG
    const auto now = std::chrono::high_resolution_clock::now()
                    .time_since_epoch()
                    .count();

    //RNGesus
    std::mt19937 gen(static_cast<std::mt19937::result_type>(now));
    std::uniform_real_distribution<float> dis1(-1.0f, 1.0f);

    //allocate mem on device and host
    float *din, *dout, *dsten, *hin, *hout, *hsten;
    cudaMalloc((void**)&din, n * sizeof(float));
    cudaMalloc((void**)&dout, n * sizeof(float));
    cudaMalloc((void**)&dsten, mask_len * sizeof(float));

    hin = new float[n];
    hout = new float[n];
    hsten = new float[mask_len];

    // Fill image and mask with random values in [-1, 1]
    for (int i = 0; i < n; ++i) {
        hin[i] = dis1(gen);
    }
    for (int i = 0; i < mask_len; ++i) {
        hsten[i] = dis1(gen);
    }

    //copy to device
    cudaMemcpy(din, hin, n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dsten, hsten, mask_len * sizeof(float), cudaMemcpyHostToDevice);

    // Timer for kernel
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    //Call kernel and time it
    cudaEventRecord(start);

    stencil(din, dsten, dout, n, R, threads_per_block);

    // Record stop right after the launch, then wait for it. cudaEventSynchronize
    // replaces cudaDeviceSynchronize here (see stencil.cuh) and keeps host-side
    // wait time out of the measurement.
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    //copy back to host
    cudaMemcpy(hout, dout, n * sizeof(float), cudaMemcpyDeviceToHost);

    // Calculate elapsed time
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    // Print output and time taken
    std::cout << hout[n - 1] << std::endl << milliseconds << std::endl;

    // Clean up
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    cudaFree(din);
    cudaFree(dout);
    cudaFree(dsten);
    delete[] hin;
    delete[] hout;
    delete[] hsten;

    // Done :3
    return 0;
}
