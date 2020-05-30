#!/bin/bash

target_file="$1"
dest_dir="$2"
dest_dir_sub=""


if [ ! -f "$target_file" ]; then
  echo "    is not file: $target_file"
  exit 0
fi

if [ -z "$SILENT" ]; then
  echo "Processing file:"
  echo "    $target_file"
fi


# check for corresponding json file
json_file_test="${target_file}.json"
json_file=""
if [ -f "$json_file_test" ]; then
  if [ -z "$SILENT" ]; then
    echo "    corresponding .json file: $(./last-path-part.sh "$json_file_test")"
  fi

  json_file="$json_file_test"

  json_data="$(cat "$json_file")"
  photoTakenTimeTimestamp="$(echo "$json_data" | ./bin/jq-linux64 -r  ".photoTakenTime.timestamp")"

  # "1279663094" || null
  if [ -n "$photoTakenTimeTimestamp" ]; then
    modified_year=$(date -d "@${photoTakenTimeTimestamp}" "+%Y")
    modified_month=$(date -d "@${photoTakenTimeTimestamp}" "+%B")
    dest_dir_sub="$modified_year/$modified_month"

    if [ -z "$SILENT" ]; then
      echo "    Setting date from corresponding json file '.photoTakenTime.timestamp': $dest_dir_sub"
    fi
  else
    if [ -z "$SILENT" ]; then
      echo "    corresponding json file does not contain key: .photoTakenTime.timestamp"
    fi
  fi

else
  if [ -z "$SILENT" ]; then
    echo "    corresponding json file does not exist"
  fi
fi


# if no date set, check if file's directory starts with format yyyy-mm-dd
if [ -z "$dest_dir_sub" ]; then
  parent_dir="$(./get-parent-dir.sh "$target_file")"
  parent_dir_date_str="$(./extract-date-from-dirname.sh "$parent_dir")"

  if [ -n "$parent_dir_date_str" ]; then
    modified_year=$(date -d "${parent_dir_date_str}" "+%Y")
    modified_month=$(date -d "${parent_dir_date_str}" "+%B")
    dest_dir_sub="$modified_year/$modified_month"
    if [ -z "$SILENT" ]; then
      echo "    Parent dir had format (yyyy-mm-dd): $dest_dir_sub"
    fi
  else
    if [ -z "$SILENT" ]; then
      echo "    Parent dir did not have format (yyyy-mm-dd): $parent_dir"
    fi
  fi
fi


# if no date set, check if file has exif data
if [ -z "$dest_dir_sub" ]; then
  if [ -n "$(which exif)" ]; then
    exif_date="$(exif "$target_file" -t "DateTimeOriginal" -m)"
    exif_date="${exif_date%% *}"
    exif_date="$(echo "$exif_date" | tr : -)"
    modified_year=$(date -d "${exif_date}" "+%Y")
    modified_month=$(date -d "${exif_date}" "+%B")
    dest_dir_sub="$modified_year/$modified_month"
    if [ -z "$SILENT" ]; then
      echo "    Date set from exif data: $dest_dir_sub"
    fi
  else
    if [ -z "$SILENT" ]; then
      echo "    exif command not available try exiftool"
    fi

    if [ -n "$(which exiftool)" ]; then
      # exiftool
      exif_date="$(exiftool -DateTimeOriginal "$target_file")"
      exif_date="$(echo "$exif_date" | sed -r 's/.*: +(.*) .*/\1/')"
      exif_date="$(echo "$exif_date" | tr : -)"
      modified_year=$(date -d "${exif_date}" "+%Y")
      modified_month=$(date -d "${exif_date}" "+%B")
      dest_dir_sub="$modified_year/$modified_month"
    else
      if [ -z "$SILENT" ]; then
        echo "    exiftool command not available"
      fi
    fi
  fi
fi


# If no date set, get data from `stat` command

# get modified date of the file
if [ -z "$dest_dir_sub" ]; then

  if [ -n "$(uname | grep Darwin)" ]; then
    modified_year=$(stat -f "%Sm" -t "%Y" "$target_file")
    modified_month=$(stat -f "%Sm" -t "%B" "$target_file")
  else
    stat_response=$(stat -c '%y' "$target_file")
    modified_year=$(date -d "$stat_response" "+%Y")
    modified_month=$(date -d "$stat_response" "+%B")
  fi
  dest_dir_sub="$modified_year/$modified_month"

  if [ -z "$SILENT" ]; then
    echo "    Setting date from 'stat' command: $dest_dir_sub"
  fi
fi

if [ -z "$dest_dir_sub" ]; then
  if [ -z "$SILENT" ]; then
    echo "no dest_dir_sub set.  skipping"
  fi
  exit 0
fi


./move-file.sh "$target_file" "$dest_dir" "$dest_dir_sub" "$json_file"