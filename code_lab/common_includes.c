/**
 * CUDA related includes
 * Course 302 HPC on the GPU
 * P.-A. Mudry 2024-2026
 */
#include <stdio.h>

#define CHECK_ERROR(call)                                                              \
   {                                                                                   \
      cudaError_t err = call;                                                          \
      if (err != cudaSuccess)                                                          \
      {                                                                                \
         printf("%s in %s at line %d\n", cudaGetErrorString(err), __FILE__, __LINE__); \
         exit(err);                                                                    \
      }                                                                                \
   }

/**
 * Performance monitoring
 */
#include <sys/time.h>
long long timeInMilliseconds(void)
{
   struct timeval tv;

   gettimeofday(&tv, NULL);
   return (((long long)tv.tv_sec) * 1000) + (tv.tv_usec / 1000);
}

long long timeInMicroseconds(void)
{
   struct timeval tv;

   gettimeofday(&tv, NULL);
   return (((long long)tv.tv_sec) * 1000000) + tv.tv_usec;
}

// Macros to measure and print the time taken by a call, in milliseconds or microseconds
#define MEASURE_TIME_MS(call)                         \
   {                                                  \
      long long start = timeInMilliseconds();         \
      call;                                           \
      long long end = timeInMilliseconds();           \
      long long time_taken = end - start;             \
      printf("time taken %lld [msec]\n", time_taken); \
   }

#define MEASURE_TIME_US(call)                         \
   {                                                  \
      long long start = timeInMicroseconds();         \
      call;                                           \
      long long end = timeInMicroseconds();           \
      long long time_taken = end - start;             \
      printf("time taken %lld [usec]\n", time_taken); \
   }

/**
 * Debug helpers
 */
void printBeginAndEnd(int nValues, float *values, int totalSize)
{
   for (int i = 0; i < nValues; i++)
      printf("idx[%i] -> %f\n", i, values[i]);

   printf("...\n");

   for (int i = 0; i < nValues; i++)
   {
      int idx = totalSize - nValues + i;
      printf("idx[%i] -> %f\n", idx, values[idx]);
   }
}
