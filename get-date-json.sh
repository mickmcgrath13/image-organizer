#!/bin/bash

target_file="$1"
date_out=""

if [ ! -f "$target_file" ]; then
  echo ""
  exit 0
fi

# check for corresponding json file
json_file="${target_file}.json"
if [ -f "$json_file" ]; then
  json_data="$(cat "$json_file")"
  photoTakenTimeTimestamp="$(echo "$json_data" | ./bin/jq-linux64 -r  ".photoTakenTime.timestamp")"

  # "1279663094" || null
  if [ -n "$photoTakenTimeTimestamp" ]; then
    date_out=$(date -d "@${photoTakenTimeTimestamp}")
  fi
fi

echo "$date_out"
