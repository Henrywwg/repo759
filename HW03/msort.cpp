#include "msort.h"
#include <algorithm>

void msort(int* arr, const std::size_t n, const std::size_t threshold){
    if(n <= threshold){
        std::sort(arr, arr + n);
    } else {
        std::size_t mid = n / 2;
        
        #pragma omp task shared(arr)
        
        msort(arr, mid, threshold);
        
        #pragma omp task shared(arr)
        
        msort(arr + mid, n - mid, threshold);
        
        #pragma omp taskwait
        std::inplace_merge(arr, arr + mid, arr + n);
    }

}