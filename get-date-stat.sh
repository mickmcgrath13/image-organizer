#!/bin/bash

target_file="$1"

date_out=""

if [ ! -f "$target_file" ]; then
  echo ""
  exit 0
fi

# get data from `stat` command
stat_response=$(stat -c '%y' "$target_file")
date_out=$(date -d "$stat_response")

echo "$date_out"