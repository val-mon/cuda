#include "../common_includes.c"
#include <cmath>
#include <iostream>

using namespace std;

int main(void)
{
   // size in bytes to allocate
   const size_t GB = pow(1024, 3);
   size_t allocSize = 20L * GB;

   byte *values;

   MEASURE_TIME_MS(values = (byte *)malloc(allocSize);
                   // fill with zeros
                   memset(values, 0, allocSize);)

   // free resources
   free(values);

   return 0;
}
