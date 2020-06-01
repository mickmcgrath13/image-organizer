#!/bin/bash

target_file="$1"
date_out=""

if [ ! -f "$target_file" ]; then
  echo ""
  exit 0
fi

get_exif(){
	exif_date="$(exif "$target_file" -t "DateTimeOriginal" -m 2>&1)"
	if [[ "$exif_date" == *"Corrupt"* ]]; then
		echo ""
	else
		echo "$exif_date"
	fi
}

# check if file has exif data
if [ -n "$(which exif)" ]; then
  exif_date="$(get_exif)"
  if [ -z "$exif_date" ]; then
	exif_date="${exif_date%% *}"
	exif_date="$(echo "$exif_date" | tr : -)"
	date_out=$(date -d "${exif_date}")
  fi
fi

echo "$date_out"