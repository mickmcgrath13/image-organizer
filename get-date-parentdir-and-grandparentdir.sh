#!/bin/bash

target_file="$1"
date_out=""

if [ ! -f "$target_file" ]; then
  echo ""
  exit 0
fi

# check if file's directory starts with format yyyy-mm-dd
parent_dir="$(./get-parent-dir.sh "$target_file")"
parent_dir="$(./convert-monthname-to-monthindex.sh "$parent_dir")"
grandparent_dir="$(./get-grandparent-dir.sh "$target_file")"
parent_dir_date_str="$(./extract-date-from-dirname.sh "${grandparent_dir}-${parent_dir}-01")"

if [ -n "$parent_dir_date_str" ]; then
  date_out=$(date -d "${parent_dir_date_str}")
fi

echo "$date_out"
