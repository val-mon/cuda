# Conversions from PNG to PPM and vice-versa

Some information on image processing with ImageMagick convert

```bash
convert mario.png mario.ppm # Converts PNG to PPM
convert output.ppm output.png # Converts PPM to PNG
convert -resize 960x540 mario.png mario.ppm
```

Complete command for getting the output

```bash
nvcc px2Gray.cu -o px2gray && ./px2gray mario.ppm && convert output.ppm output.png 
```

