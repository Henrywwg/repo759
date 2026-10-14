#include <algorithm>
#include "matmul.h"


void mmul(const float *A, const float *B, float *C, const unsigned long long n){
    std::fill(C, C + n * n, 0.0);
    #pragma omp parallel for
        for(int i = 0; i < n; i++){                                   
            for(int k = 0; k < n; k++){                            
                for(int j = 0; j < n; j++){                     
                    C[i*n + j] += A[i*n + k] * B[k*n + j];      
                }
            }
        }
}