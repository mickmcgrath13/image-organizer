#!/bin/bash

target_file="$1"
dest_dir="$2"
dest_dir_sub=""


if [ ! -f "$target_file" ]; then
  echo "    is not file: $target_file"
  exit 0
fi

if [ -z "$(which exif)" ]; then
  if [ -z "$SILENT" ]; then
    echo "exif not present"
  fi
  if [ -z "$(which exiftool)" ]; then
    if [ -z "$SILENT" ]; then
      echo "exiftool not present"
    fi
    exit 0
  else
    if [ -z "$SILENT" ]; then
      echo "exiftool present"
    fi
  fi
fi


# get yyyy/M location
parent_dir="$(./get-parent-dir.sh "$target_file")"
grandparent_dir="$(./get-grandparent-dir.sh "$target_file")"
current_location_dir_sub="$grandparent_dir/$parent_dir"


if [ -n "$(which exif)" ]; then
  exif_date="$(exif "$target_file" -t "DateTimeOriginal" -m)"
  exif_date="${exif_date%% *}"
  exif_date="$(echo "$exif_date" | tr : -)"

else
  # exiftool
  exif_date="$(exiftool -DateTimeOriginal "$target_file")"
  exif_date="$(echo "$exif_date" | sed -r 's/.*: +(.*) .*/\1/')"
  exif_date="$(echo "$exif_date" | tr : -)"
fi

modified_year=$(date -d "${exif_date}" "+%Y")
modified_month=$(date -d "${exif_date}" "+%B")
dest_dir_sub="$modified_year/$modified_month"

if [ "$current_location_dir_sub" = "$dest_dir_sub" ]; then
  exit 0
fi

if [ -z "$dest_dir_sub" ]; then
  echo "Processing file:"
  echo "    $target_file"
  echo "    no dest_dir_sub set.  skipping"
  exit 0
fi

# check for corresponding json file
json_file_test="${target_file}.json"
json_file=""
if [ -f "$json_file_test" ]; then
  # echo "    corresponding .json file: $(./last-path-part.sh "$json_file_test")"
  json_file="$json_file_test"
fi

./move-file.sh "$target_file" "$dest_dir" "$dest_dir_sub" "$json_file"

