#!/bin/bash

target_dir="$1"
dest_dir="$2"

if [ -z "$SILENT" ]; then
  echo "Processing directory:"
  echo "    $target_dir"
fi

for i in "$target_dir"/*
do
  
  if [ -z "$SILENT" ]; then
    echo ""
    echo "iterating: $target_dir"
    echo "    i: $(./last-path-part.sh "$i")"
  fi

  if [ "$(./last-path-part.sh "$i")" = '@eaDir' ]; then
    echo '    is @eaDir: skipping'
  elif [ "$(./get-file-extension.sh "$i")" = 'json' ]; then
  	echo '    is .json file: skipping'
  else
    ./process-item.sh "$i" "$dest_dir"
  fi
done
