#include <iostream>
#include <random>
#include <string>
#include <chrono>
#include "vscale.cuh"


int main(int argc, char **argv){
    const int numThreads = 512;

    if (argc != 2){
        std::cerr << "Usage: " << argv[0] << " <N>" << std::endl;
        return 1;
    }

    int N = std::stoi(argv[1]);

    int numBlocks = (N + numThreads - 1) / numThreads;

    // Get the current time for RNG
    const auto now = std::chrono::high_resolution_clock::now()
                    .time_since_epoch()
                    .count();

    //random number generator 
    std::mt19937 gen(static_cast<std::mt19937::result_type>(now));

    std::uniform_real_distribution<float> dis1(-10.0f, 10.0f);
    std::uniform_real_distribution<float> dis2(0.0f, 1.0f);

    //allocate mem on device and host
    float *da, *db, *b;
    cudaMalloc((void**)&da, N * sizeof(float));
    cudaMalloc((void**)&db, N * sizeof(float));
    b = new float[N];

    // a gets a random float 
    for(int i = 0; i < N; i++)
        da[i] = static_cast<float>(dis1(gen));

    for(int i = 0; i < N; i++)
        db[i] = static_cast<float>(dis2(gen));


    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);


    //call the kernel; 2 blocks 8 threads
    vscale<<<numBlocks, numThreads>>>(da, db, N);
    
    cudaDeviceSynchronize();
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    //copy the data back to host
    cudaMemcpy(b, db, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Get the elapsed time in milliseconds
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    std::cout << ms << std::endl;       //kernel runtime
    std::cout << b[0] << std::endl;     //first element
    std::cout << b[N-1] << std::endl;   //last element
    
    return 0;
}