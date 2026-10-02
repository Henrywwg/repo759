#include <algorithm>
#include "matmul.h"

void mmul1(const double *A, const double *B, double *C, const unsigned int n){
    for(int i = 0; i < n; i++){                             //Iterate rows      
        for(int j = 0; j < n; j++){                         //Iterate columns   
            for(int k = 0; k < n; k++){
                C[i*n + j] += A[i*n + k] * B[k*n + j];      // C[i][j] += A[i][k] * B[k][j]
            }
        }
    }
}

void mmul2(const double *A, const double *B, double *C, const unsigned int n){
    for(int i = 0; i < n; i++){                             //Iterate rows      
        for(int k = 0; k < n; k++){                         //Iterate summation index   
            for(int j = 0; j < n; j++){                     //Iterate columns
                C[i*n + j] += A[i*n + k] * B[k*n + j];      // C[i][j] += A[i][k] * B[k][j]
            }
        }
    }
}

void mmul3(const double *A, const double *B, double *C, const unsigned int n){
    for(int j = 0; j < n; j++){                             //Iterate columns
        for(int k = 0; k < n; k++){                         //Iterate summation index
            for(int i = 0; i < n; i++){                     //Iterate rows
                C[i*n + j] += A[i*n + k] * B[k*n + j];      // C[i][j] += A[i][k] * B[k][j]
            }
        }
    }
}

void mmul4(const std::vector<double> &A, const std::vector<double> &B, double *C, const unsigned int n){
    for(int i = 0; i < n; i++){                             //Iterate rows      
        for(int j = 0; j < n; j++){                         //Iterate columns   
            for(int k = 0; k < n; k++){
                C[i*n + j] += A[i*n + k] * B[k*n + j];      // C[i][j] = A[i][k] * B[k][j]
            }
        }
    }
}
