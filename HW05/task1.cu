#include <stdio.h>
#include <cuda.h>

__global__ void task1(){
    //get thread id
    int tid = blockIdx.x * blockDim.x + threadIdx.x + 1;
    
    int temp = 1;

    //Naive implementation of factorial 
    for(int i = tid; i > 1; i--){
        temp *= i;
    }

    printf("%d!=%d\n", tid, temp);

}

int main(){
    const int numThreads = 8;

    //call the kernel; 1 block 8 threads
    task1<<<1, numThreads>>>();
    cudaDeviceSynchronize();


    return 0;
}