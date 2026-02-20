# Lab 2
## Compile
**print_results.c:**              gcc -c print.c -o print.o
**lab2.s:**                       as lab2.s -o lab2.o
**Linking Command: **             gcc lab2.o print.o -o lab2 -nostartfiles -no-pie
## Run
**lab2:**       ./lab2
