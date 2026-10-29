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
   int x = blockIdx.x * blockDim.x + threadIdx.x;
   int y = blockIdx.y * blockDim.y + threadIdx.y;

   int p = y * width + x;
   int i = p * channels;

   if (x < width && y < height){
      unsigned char r = rgbImage[i];
      unsigned char g = rgbImage[i + 1];
      unsigned char b = rgbImage[i + 2];

      grayImage[i] = (unsigned char)(0.21 * r + 0.71 * g + 0.07 * b);
      grayImage[i + 1] = (unsigned char)(0.21 * r + 0.71 * g + 0.07 * b);
      grayImage[i + 2] = (unsigned char)(0.21 * r + 0.71 * g + 0.07 * b);
   }
}

int main(int argc, char *argv[])
{
   int imageChannels;
   int imageWidth;
   int imageHeight;

   char *inputImageFile = argv[1];
   printf("Color2Gray conversion, HPC 302.1\n");

   printf("- Reading image %s\n", inputImageFile);
   PPMImage *image = readPPM(inputImageFile);

   imageChannels = 3;
   imageWidth = image->x;
   imageHeight = image->y;

   printf("- Image has %d channels, %d width, %d height\n", imageChannels, imageWidth, imageHeight);
   
   size_t size = imageWidth * imageHeight * imageChannels * sizeof(char);
   uint8_t * h_colorimg = (uint8_t*)image->data;

   // Allocate global memory on the device for A, B and C
   uint8_t * d_grayimg;
   uint8_t * d_colorimg;
   CHECK_ERROR(cudaMalloc((void **)&d_colorimg, size));
   CHECK_ERROR(cudaMalloc((void **)&d_grayimg, size));

   // Copy values to CUDA GPU
   CHECK_ERROR(cudaMemcpy(d_colorimg, h_colorimg, size, cudaMemcpyHostToDevice));

   // Launch computation
   const int N_BLOCKS_X = ceil((double)imageWidth / (double)TILE_WIDTH);
   const int N_BLOCKS_Y = ceil((double)imageHeight / (double)TILE_WIDTH);
   dim3 N_THREADS(TILE_WIDTH, TILE_WIDTH); // define a 2d block of TILE_WIDTH x TILE_WIDTH threads
   dim3 N_BLOCKS(N_BLOCKS_X, N_BLOCKS_Y); // define a 2D grid of N_BLOCKS_X x N_BLOCKS_Y blocks

   rgb2gray<<<N_BLOCKS, N_THREADS>>>(d_grayimg, d_colorimg, imageChannels, imageWidth, imageHeight);

   // Copy result back
   CHECK_ERROR(cudaMemcpy(image->data, d_grayimg, size, cudaMemcpyDeviceToHost));
   
   // Free device resources
   CHECK_ERROR(cudaFree(d_colorimg));
   CHECK_ERROR(cudaFree(d_grayimg));
   
   // Write image
   writePPM("output.ppm", image);

   // Free host resources
   freeImage(image);

   return 0;
}
