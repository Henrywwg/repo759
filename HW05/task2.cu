#include <stdio.h>
#include <cuda.h>
#include <random>


//omg it's an AXPY 
__global__ void iaxpy(int *dA, int *a){
    //get thread id
    int x = threadIdx.x;
    int y = blockIdx.x;
    dA[y * blockDim.x + x] = *a * x + y;
}

int main(){
    const int numThreads = 8;
    const int numBlocks = 2;
    const int numElements = numBlocks * numThreads;


	std::random_device entropy_source;
    std::mt19937 generator(entropy_source());

    //allocate mem on device and host
    int *dA, *a, hA[numElements];
    cudaMalloc((void**)&dA, numBlocks * numThreads * sizeof(int));
    cudaMalloc((void**)&a, sizeof(int));

    // a gets a random int 
    *a = generator();
    
    //call the kernel; 2 blocks 8 threads
    iaxpy<<<numBlocks, numThreads>>>(dA, a);
    cudaDeviceSynchronize();

    //copy the data back to host
    cudaMemcpy(hA, dA, numBlocks * numThreads * sizeof(int), cudaMemcpyDeviceToHost);

    for(auto i : hA)
        printf("%d ", i);
    
    printf("\n");

    return 0;
}