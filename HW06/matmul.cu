#include "matmul.cuh"

// Computes the matrix product of A and B, storing the result in C.
// Each thread should compute _one_ element of output.
// Does not use shared memory for this problem.
//
// A, B, and C are row major representations of nxn matrices in device memory.
//
// Assumptions:
// - 1D kernel configuration
__global__ void matmul_kernel(const float* A, const float* B, float* C, size_t n){

    unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx >= n * n) return;

    unsigned int row = idx / n;
    unsigned int col = idx % n;

    float sum = 0.0f;
    for (unsigned int k = 0; k < n; ++k) {
        sum += A[row * n + k] * B[k * n + col];
    }
    C[idx] = sum;

}

// Makes one call to matmul_kernel with threads_per_block threads per block.
// You can consider following the kernel call with cudaDeviceSynchronize (but if you use 
// cudaEventSynchronize to time it, that call serves the same purpose as cudaDeviceSynchronize).
void matmul(const float* A, const float* B, float* C, size_t n, unsigned int threads_per_block){
    matmul_kernel<<<(n * n + threads_per_block - 1) / threads_per_block, threads_per_block>>>(A, B, C, n);
}