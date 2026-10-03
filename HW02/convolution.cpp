#include "convolution.h"

/**
 * Written by Claude (Opus 5.5) during a review of my HW02 code. My original
 * version assumed a pre-padded (n+2)x(n+2) image and only worked for m = 3;
 * Claude pointed that out and suggested this version, which handles the
 * padding inside the function for any odd m.
 * Prompt: "ok need you to check my work for HW02. Let me know if you spot any issues"
 * (assignment PDF and my HW02 files provided as context)
 */
void convolve(const float *image, float *output, std::size_t n, const float *mask, std::size_t m){
    const std::ptrdiff_t N = n;
    const std::ptrdiff_t M = m;
    const std::ptrdiff_t half = (M - 1) / 2;

    for (std::ptrdiff_t x = 0; x < N; ++x){
        for (std::ptrdiff_t y = 0; y < N; ++y) {
            float sum = 0.0f;
            for (std::ptrdiff_t i = 0; i < M; ++i) {
                const std::ptrdiff_t r = x + i - half;
                const bool row_in = (r >= 0 && r < N);
                for (std::ptrdiff_t j = 0; j < M; ++j) {
                    const std::ptrdiff_t c = y + j - half;
                    const bool col_in = (c >= 0 && c < N);
                    float f = (row_in && col_in) ? image[r * N + c]
                            : (row_in || col_in) ? 1.0f : 0.0f;  // edge : corner
                    sum += mask[i * M + j] * f;
                }
            }
            output[x * N + y] = sum;
        }
    }
}