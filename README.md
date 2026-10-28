# CUDA lab for CS302 HPC

Starting code for the CUDA lab of the course CS302 High performance computing in the [ISC bachelor degree](https://isc.hevs.ch/) programme in Sion.

Some parts are inspired from the book by Wen-mei W. Hwu, David B. Kirk, Izzat El Hajj, "__Programming Massively Parallel Processors A Hands-on Approach__", Fourth Edition, 2022.

## How to compile

Either manually

```bash
nvcc example.cu -o example && ./example
```

or using a `VSCode` task, which is bound to `Ctrl+Shift+B` (or `> Run Build Task`)
