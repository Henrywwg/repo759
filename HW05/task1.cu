#include <stdio.h>
#include <cuda.h>

__global__ void task1(int *data){
    //get thread id
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    
    int temp = 1;

    //Naive implementation of factorial 
    for(int i = tid - 1; i > 0; i--){
        temp *= i;
    }

    data[tid] = temp;

    printf("%d!=%d\n", tid, data[tid]);

}

int main(){
    const int numThreads = 8;
    int data_host[numThreads], *data_device;


    //allocate mem... 
    cudaMalloc((void**)&data_device, numThreads * sizeof(int));
    cudaMemset(data_device, 0, numThreads * sizeof(int));


    //call the kernel; 1 block 8 threads
    task1<<<1, numThreads>>>(data_device);


    //copy the data back to host
    cudaMemcpy(data_host, data_device, numThreads * sizeof(int), cudaMemcpyDeviceToHost);


    return 0;
}