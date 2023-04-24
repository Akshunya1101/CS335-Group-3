#!/bin/bash
make clean
make
./milestone4 --input tests/test_1.java
gcc -c x86_code.s -o x86_code.o
gcc x86_code.o -o x86_code
./x86_code
