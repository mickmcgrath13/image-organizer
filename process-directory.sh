#!/bin/bash

target_dir="$1"
dest_dir="$2"

echo "Processing directory: $target_dir"
for i in $target_dir/*
do
  echo "iterating: $target_dir"
  echo "i: $i"
  if [ "$(./last-path-part.sh "$i")" = '@eaDir' ]; then
    echo 'is @eaDir: skipping'
  else
    ./process-item.sh "$i" "$dest_dir"
  fi
done
