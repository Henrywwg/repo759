#include "convolution.h"

void convolve(const float *image, float *output, std::size_t n, const float *mask, std::size_t m){

    for(int i = 1; i < n + 1; i++){         // traverse row
        for(int j = 1; j < n + 1; j++){     // traverse column
            for(int k = 0; k < m; k++){
                for(int l = 0; l < m; l++){
                    output[(i-1) * n + (j-1)] += image[(i + k - 1) * (n+2) + (j + l - 1)] * mask[k * m + l];
                }
            }
        }
    }
}