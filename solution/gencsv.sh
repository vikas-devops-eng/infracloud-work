#!/bin/bash
start=$1
end=$2

> inputFile  # Clear the contents of the file or create it if it doesn't exist

for ((i=start; i<=end; i++)); do
    rand_num=$((RANDOM % 1000))  # Generate a random number between 0 and 999
    echo "$i, $rand_num" >> inputFile
done
