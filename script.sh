#!/bin/bash

# create the output folder if it does not exist
if [ ! -d "./test_output" ]; then
  mkdir "./test_output"
fi

# loop through all files in the test folder and run the command
for file in ./tests/*
do
  # run the command on the current file and save the output to a file in the test_output folder
  $(./myASTGenerator --input "$file" --output ./test_output/$(basename "$file").dot)
  $(dot -Tpng ./test_output/$(basename "$file").dot -o ./test_output/$(basename "$file").png)
  # open ./test_output/$(basename "$file").png
done
