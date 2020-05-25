#!/bin/bash

target_dir="$1"
dest_dir="$2"

echo "Processing directory:"
echo "    $target_dir"
for i in "$target_dir"/*
do
  echo ""
  echo "iterating: $target_dir"
  echo "    i: $(./last-path-part.sh "$i")"
  if [ "$(./last-path-part.sh "$i")" = '@eaDir' ]; then
    echo '    is @eaDir: skipping'
  elif [ "$(./get-file-extension.sh "$i")" = 'json' ]; then
  	echo '    is .json file: skipping'
  else
    ./process-item.sh "$i" "$dest_dir"
  fi
done
