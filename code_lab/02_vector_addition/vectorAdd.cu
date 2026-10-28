/**
 * Vector addition in CUDA
 * Pierre-André Mudry, ISC HPC 302.1 course, 2024
 */

#include <iostream>
#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "../common_includes.c"

#define N 100e6L
const int N_THREADS = 512;
const int N_BLOCKS = ceil((double)(N)/N_THREADS);

using namespace std;

// Compute kernel for vector sum C = A+B
__global__ void vecAddKernel(float *A, float *B, float *C, int n)
{
   // int i = threadIdx.x;
   int i = blockIdx.x * blockDim.x + threadIdx.x;
   if (i < n)
      C[i] = A[i] + B[i];
}

// Prepare and run the computation of the h_C = h_A + h_B
void vecAdd(float *h_A, float *h_B, float *h_Res, unsigned long n)
{
   // What this function must do
   /**
           for (int i = 0; i < n; i++)
                   h_Res[i] = h_A[i] + h_B[i];
   */

   size_t size = n * sizeof(float);
   float *d_A, *d_B, *d_Res;

   // Allocate global memory on the device for A, B and C
   CHECK_ERROR(cudaMalloc((void **)&d_A, size));
   CHECK_ERROR(cudaMalloc((void **)&d_B, size));
   CHECK_ERROR(cudaMalloc((void **)&d_Res, size));

   // Copy values to CUDA GPU
   cout << "\nCopy: ";
   MEASURE_TIME_US(CHECK_ERROR(cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice));
   CHECK_ERROR(cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice)););
   
   // Launch computation
   cout << "Computation : ";
   // MEASURE_TIME_MS((vecAddKernel<<<1, N>>>(d_A, d_B, d_Res, n)););
   MEASURE_TIME_US((vecAddKernel<<<N_BLOCKS, N_THREADS>>>(d_A, d_B, d_Res, n)););
   cudaDeviceSynchronize();

   // Copy result back
   CHECK_ERROR(cudaMemcpy(h_Res, d_Res, size, cudaMemcpyDeviceToHost));

   // Free the memory
   CHECK_ERROR(cudaFree(d_A));
   CHECK_ERROR(cudaFree(d_B));
   CHECK_ERROR(cudaFree(d_Res));
}

int main(void)
{
   // Create some host vectors
   float *h_A, *h_B, *h_C;

   // allocate memory for host vectors
   h_A = (float *)malloc(sizeof(float) * N);
   h_B = (float *)malloc(sizeof(float) * N);
   h_C = (float *)malloc(sizeof(float) * N);

   // Filling A and B with stuff
   for (unsigned long i = 0; i < N; i++)
   {
      h_A[i] = (float)i;
      h_B[i] = (float)7;
   }

   // Calling our vector compute function
   vecAdd(h_A, h_B, h_C, N);

   printf("\nPrinting some results:\n");
   printBeginAndEnd(3, h_C, N);

   // check the result
   bool valid = true;
   for (unsigned long i = 0; i < N; i++)
   {
      if (h_A[i] + h_B[i] != h_C[i])
      {
         valid = false;
         break;
      }
   }

   if (!valid)
      printf("The result is not correct!\n");
   else
      printf("Successfully computed the sum!\n");

   // Free host memory
   free(h_A);
   free(h_B);
   free(h_C);

   return 0;
}
