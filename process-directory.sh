#!/bin/bash

target_dir="$1"
dest_dir="$2"

echo "Processing directory: $target_dir"
for i in $target_dir/*
do
  echo "iterating: $target_dir"
  echo "i: $i"
  ./process-item.sh $i $dest_dir
done
