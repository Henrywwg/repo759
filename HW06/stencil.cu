#include "stencil.cuh"

// Claude (Opus 5.5) pointed out the signed loop-bound bug during code review and wrote
// the halo loading and global write-back in stencil_kernel; see the HW06 AI disclosure.

// Computes the convolution of image and mask, storing the result in output.
// Each thread should compute _one_ element of the output matrix.
// Shared memory should be allocated _dynamically_ only.
//
// image is an array of length n.
// mask is an array of length (2 * R + 1).
// output is an array of length n.
// All of them are in device memory
//
// Assumptions:
// - 1D configuration
// - blockDim.x >= 2 * R + 1
//
// The following should be stored/computed in shared memory:
// - The entire mask
// - The elements of image that are needed to compute the elements of output corresponding to the threads in the given block
// - The output image elements corresponding to the given block before it is written back to global memory
__global__ void stencil_kernel(const float *image, const float *mask, float *output, unsigned int n, unsigned int R)
{
    // Signed copies of R and the thread index. Mixing int and unsigned int in a
    // comparison converts the int to unsigned, so a loop like
    // "for (int j = -R; j <= R; ++j)" with unsigned R never runs (-R wraps to ~4e9).
    const int r = static_cast<int>(R);
    const int t = static_cast<int>(threadIdx.x);
    const int block_threads = static_cast<int>(blockDim.x);

    // The block needs its own blockDim.x image elements plus R neighbors (halo) on each side
    const int tile_len = block_threads + 2 * r;

    // Dynamic shared memory, split into three regions:
    //   [ mask: 2R+1 | image tile: blockDim.x + 2R | output: blockDim.x ]
    extern __shared__ float shared_mem[];
    float *shared_mask = shared_mem;
    float *shared_image = shared_mask + (2 * r + 1);
    float *shared_output = shared_image + tile_len;

    // Global index of the first output element this block computes.
    // long long so the halo index below can go negative for block 0.
    const long long block_start = static_cast<long long>(blockIdx.x) * block_threads;

    // Load the entire mask. Strided so it works even if the mask is longer than the block.
    for (int i = t; i < 2 * r + 1; i += block_threads) {
        shared_mask[i] = mask[i];
    }

    // Load the image tile, including the left and right halos.
    // shared_image[i] holds image[block_start - R + i]; anything outside [0, n) is 1.
    for (int i = t; i < tile_len; i += block_threads) {
        const long long global_idx = block_start - r + i;
        if (global_idx >= 0 && global_idx < static_cast<long long>(n)) {
            shared_image[i] = image[global_idx];
        }
        else {
            shared_image[i] = 1.0f; // OOB is 1
        }
    }

    // All loads must finish before any thread reads shared memory.
    // No thread returns early above, so every thread reaches this barrier.
    __syncthreads();

    // Each thread computes one output element. Thread t's own image element sits at
    // shared_image[t + R], so its neighbor image[i + j] is shared_image[t + R + j].
    // The halo guarantees every index read here is inside the tile.
    float sum = 0.0f;
    for (int j = -r; j <= r; ++j) {
        sum += shared_image[t + r + j] * shared_mask[j + r];
    }

    // Stage the result in shared memory (required by the header comment)
    shared_output[t] = sum;

    // Each thread reads back only its own slot, so this barrier is not strictly
    // required; kept so the shared output is complete before the write-back.
    __syncthreads();

    // Write the result back to global memory. Threads past the end of the array
    // only helped with the loads, so they skip the write.
    const long long global_idx = block_start + t;
    if (global_idx < static_cast<long long>(n)) {
        output[global_idx] = shared_output[t];
    }
}

// Makes one call to stencil_kernel with threads_per_block threads per block.
// You can consider following the kernel call with cudaDeviceSynchronize (but if you use
// cudaEventSynchronize to time it, that call serves the same purpose as cudaDeviceSynchronize).
//
// Assumptions:
// - threads_per_block >= 2 * R + 1
__host__ void stencil(const float *image, const float *mask, float *output, unsigned int n, unsigned int R, unsigned int threads_per_block)
{
    // Dynamic shared memory size, matching the three regions in stencil_kernel:
    //   mask (2R + 1) + image tile (threads_per_block + 2R) + output (threads_per_block)
    //   = 2 * threads_per_block + 4R + 1 floats
    size_t shared_mem_size = (2 * threads_per_block + 4 * R + 1) * sizeof(float);

    // One thread per output element; round the block count up so all n elements are covered
    unsigned int num_blocks = (n + threads_per_block - 1) / threads_per_block;
    stencil_kernel<<<num_blocks, threads_per_block, shared_mem_size>>>(image, mask, output, n, R);
}
