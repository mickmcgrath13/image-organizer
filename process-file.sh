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

echo "Ensure dest dir exists:"
echo "dest root:      $dest_dir"
echo "dest sub:       $dest_dir_sub"
echo "dest_dir_full:  $dest_dir_full"
mkdir -p "$dest_dir_full"

echo "Check if file exists"
dest_file="$(./last-path-part.sh "$target_file")"
dest_file_full="$dest_dir_full/$dest_file"
while [ -f "$dest_file_full" ]; do
  dest_file="0_${dest_file}"
  dest_file_full="$dest_dir_full/$dest_file"
  echo "File already exists ($dest_file_full).  Renaming: $dest_file"
done

if [ -n "$IMAGE_ORGANIZER_MOVE" ]; then
  echo "MOVING:  $target_file -> $dest_file_full"
  mv "$target_file" "$dest_file_full"
else
  echo "COPYING:  $target_file -> $dest_file_full"
  cp "$target_file" "$dest_file_full"
fi
