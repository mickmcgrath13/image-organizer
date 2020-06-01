#!/bin/bash

target_file="$1"
date_out=""

if [ ! -f "$target_file" ]; then
  echo ""
  exit 0
fi

# check if file has exif data
if [ -n "$(which exiftool)" ]; then
  # exiftool
  exif_date="$(exiftool -DateTimeOriginal "$target_file")"
  exif_date="$(echo "$exif_date" | sed -r 's/.*: +(.*) .*/\1/')"
  exif_date="$(echo "$exif_date" | tr : -)"
  date_out=$(date -d "${exif_date}")
fi

echo "$date_out"