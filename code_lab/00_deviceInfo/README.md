Compile and run with : 

```bash
nvcc getInfo.cu -o getInfo && ./getInfo
```

And voilà !

## Lab answers
- How many SM are there in the provided GPU ?
    - 10
- How many threads can you run per SM at most ?
    - 1024
- How many threads can run at the same time on the GPU ?
    - 1024 * 10
