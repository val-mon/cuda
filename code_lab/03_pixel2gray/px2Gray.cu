/**
 * Converting RGB images to gray, in CUDA
 *
 * Pierre-André Mudry, ISC HPC 302.1 course, 2024
 */
#include <cuda.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "../common_includes.c"
#include "ppm.c"

#define TILE_WIDTH 32

using namespace std;

__global__ void rgb2gray(uint8_t *grayImage, uint8_t *rgbImage, int channels, int width, int height)
{
   // TODO: implement the kernel
}

int main(int argc, char *argv[])
{
   int imageChannels;
   int imageWidth;
   int imageHeight;

   char *inputImageFile = argv[1];
   printf("Color2Gray conversion, HPC 302.1\n");

   printf("- Reading image %s\n", inputImageFile);
   PPMImage *h_colorimg = readPPM(inputImageFile);
   PPMImage *h_grayimg;

   imageChannels = 3;
   imageWidth = h_colorimg->x;
   imageHeight = h_colorimg->y;

   printf("- Image has %d channels, %d width, %d height\n", imageChannels, imageWidth, imageHeight);

   // TODO: something is missing here

   // Write image on disk
   writePPM("output.ppm", h_colorimg);

   // Free host memory
   freeImage(h_colorimg);

   return 0;
}
