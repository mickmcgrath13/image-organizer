#!/bin/bash

target_file="$1"
dest_dir="$2"



if [ ! -f "$target_file" ]; then
  echo "    is not file: $target_file"
  exit 0
fi

echo "Processing file: $target_file"

# get modified date of the file
if [ -n "$(uname | grep Darwin)" ]; then
  modified_year=$(stat -f "%Sm" -t "%Y" "$target_file")
  modified_month=$(stat -f "%Sm" -t "%B" "$target_file")
else
  stat_response=$(stat -c '%y' "$target_file")
  modified_year=$(date -d "$stat_response" "+%Y")
  modified_month=$(date -d "$stat_response" "+%B")
fi



dest_dir_sub="$modified_year/$modified_month"

echo "Modified date (yyyy/mm): $dest_dir_sub"
echo ""


dest_dir_full="$dest_dir/$dest_dir_sub"

echo "Ensure dest exists:"
echo "dest root:      $dest_dir"
echo "dest sub:       $dest_dir_sub"
echo "dest_dir_full:  $dest_dir_full"
mkdir -p $dest_dir_full

if [ -n "$IMAGE_ORGANIZER_MOVE" ]; then
  echo "MOVING:  $target_file -> $dest_dir_full"
  mv $target_file $dest_dir_full
else
  echo "COPYING:  $target_file -> $dest_dir_full"
  cp $target_file $dest_dir_full
fi
