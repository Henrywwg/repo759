#include <iostream>
#include <random>
#include <string>
#include <chrono>


//omg it's an AXPY 
__global__ void iaxpy(int *dA, int a){
    //get thread id
    int x = threadIdx.x;
    int y = blockIdx.x;
    dA[y * blockDim.x + x] = a * x + y;
}

int main(){
    const int numThreads = 8;
    const int numBlocks = 2;
    const int numElements = numBlocks * numThreads;


    // Get the current time for RNG
    const auto now = std::chrono::high_resolution_clock::now()
                    .time_since_epoch()
                    .count();

    //random number generator 
    std::mt19937 gen(static_cast<std::mt19937::result_type>(now));

    std::uniform_int_distribution<int> dis(0, 10);

    //allocate mem on device and host
    int *dA, hA[numElements];
    cudaMalloc((void**)&dA, numElements * sizeof(int));

    int a = dis(gen);
    iaxpy<<<numBlocks, numThreads>>>(dA, a);
    cudaDeviceSynchronize();

    //copy the data back to host
    cudaMemcpy(hA, dA, numBlocks * numThreads * sizeof(int), cudaMemcpyDeviceToHost);

    for(auto i : hA)
        printf("%d ", i);
    
    printf("\n");

    return 0;
}