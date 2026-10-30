#include <cuda.h>
#include <curand_kernel.h>

#include <iostream>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "../common_includes.c"

#define N 1e9
const int N_THREADS = 1024;
const int N_BLOCKS = ceil((double)(N) / N_THREADS);

using namespace std;

__global__ void compute_distance(int *m)
{
   int i = blockIdx.x * blockDim.x + threadIdx.x;
   if (i < N)
   {
      curandState state;
      curand_init(1234ULL, i, 0ULL, &state);
      float u = curand_uniform(&state);
      float v = curand_uniform(&state);

      float x = 2.0f * u - 1.0f;
      float y = 2.0f * v - 1.0f;
      bool inside = (x * x + y * y) <= 1.0f;
      if (inside)
      {
         atomicAdd(m, 1);
      }
   }
}

int main()
{
   int m = 0;
   int *h_m = &m;

   int *d_m;
   size_t size = sizeof(int);
   CHECK_ERROR(cudaMalloc((void **)&d_m, size));
   CHECK_ERROR(cudaMemcpy(d_m, h_m, size, cudaMemcpyHostToDevice);)

   MEASURE_TIME_MS(
      (compute_distance<<<N_BLOCKS, N_THREADS>>>(d_m));
      CHECK_ERROR(cudaGetLastError());
      CHECK_ERROR(cudaMemcpy(h_m, d_m, size, cudaMemcpyDeviceToHost));
   );

   CHECK_ERROR(cudaFree(d_m));

   float pi = 4.0f * m / N;
   cout << pi << endl;
   return 0;
}
