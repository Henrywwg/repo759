#include "matmul.cuh"
#include <iostream>
#include <chrono>
#include <random>
#include <string>

// arff arff

int main(int argc, char **argv) {
  // Check command line arguments
  if (argc != 3) {
    std::cout << "./task1 <n> <threads per block>" << std::endl;
    return 1;
  }

  // Parse inputs
  int n = std::stoi(argv[1]);
  int threads_per_block = std::stoi(argv[2]);

  // Get the current time for RNG
  const auto now = std::chrono::high_resolution_clock::now()
                  .time_since_epoch()
                  .count();

  //RNGesus
  std::mt19937 gen(static_cast<std::mt19937::result_type>(now));
  std::uniform_real_distribution<float> dis1(-1.0f, 1.0f);

  //allocate mem on device and host
  float *da, *db, *dc, *ha, *hb, *hc;
  cudaMalloc((void**)&da, n * n * sizeof(float));
  cudaMalloc((void**)&db, n * n * sizeof(float));
  cudaMalloc((void**)&dc, n * n * sizeof(float));

  ha = new float[n * n];
  hb = new float[n * n];
  hc = new float[n * n];

  for (int i = 0; i < n * n; ++i) {
    ha[i] = dis1(gen);
    hb[i] = dis1(gen);
  }

  // Copy to device
  cudaMemcpy(da, ha, n * n * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(db, hb, n * n * sizeof(float), cudaMemcpyHostToDevice);  

  // Timer for kernel
  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);

  matmul(da, db, dc, n, threads_per_block);

  cudaDeviceSynchronize();
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  
  // Copy back to host
  cudaMemcpy(hc, dc, n * n * sizeof(float), cudaMemcpyDeviceToHost);

  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);
  
  // print the last element of the result and the time taken
  std::cout << hc[n*n - 1] << std::endl << milliseconds << std::endl;


  // Free memory and clean up :3 
  cudaEventDestroy(start);
  cudaEventDestroy(stop);
  cudaFree(da);
  cudaFree(db);
  cudaFree(dc);
  delete[] ha;
  delete[] hb;
  delete[] hc;


  return 0;
}