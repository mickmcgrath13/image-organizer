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
target_file_date_json="$(./get-date-json.sh "$target_file")"

# notify logic
json_file_test="${target_file}.json"
if [ -n "$target_file_date_json" ] && [ -z "$SILENT" ]; then
  echo "    Setting date from corresponding json file '.photoTakenTime.timestamp': $target_file_date_json"
else
  if [ -f "$json_file_test" ] && [ -z "$SILENT" ]; then
    echo "    corresponding json file does not contain key: .photoTakenTime.timestamp"
  elif [ -z "$SILENT" ]; then
    echo "    corresponding json file does not exist"
  fi
fi





# check if file's directory starts with format yyyy-mm-dd
target_file_date_parentdir="$(./get-date-parentdir.sh "$target_file")"

# notify logic
if [ -n "$target_file_date_parentdir" ] && [ -z "$SILENT" ]; then
  echo "    Parent dir had format (yyyy-mm-dd): $target_file_date_parentdir"
elif [ -z "$SILENT" ]; then
  echo "    Parent dir did not have format (yyyy-mm-dd)"
fi


# check if file has exif data
target_file_date_exif="$(./get-date-exif.sh "$target_file")"

# notify logic
if [ -n "$target_file_date_exif" ] && [ -z "$SILENT" ]; then
  echo "    Date set from exif: $target_file_date_exif"
fi


# check if file has exiftool data
target_file_date_exiftool="$(./get-date-exiftool.sh "$target_file")"

# notify logic
if [ -n "$target_file_date_exiftool" ] && [ -z "$SILENT" ]; then
  echo "    Date set from exif: $target_file_date_exiftool"
fi


# get data from `stat` command
target_file_date_stat="$(./get-date-stat.sh "$target_file")"

if [ -n "$target_file_date_stat" ] && [ -z "$SILENT" ]; then
  echo "    Setting date from 'stat' command: $target_file_date_stat"
fi


target_file_date=$(./get-min-date.sh \
  "$target_file_date_json" \
  "$target_file_date_parentdir" \
  "$target_file_date_exif" \
  "$target_file_date_exiftool" \
  "$target_file_date_stat"
)

dest_dir_sub="$(./format-date-folder.sh "$target_file_date")"

# echo ""
# echo "$target_file"
# echo "json:             $target_file_date_json"
# echo "parentdir:        $target_file_date_parentdir"
# echo "exif:             $target_file_date_exif"
# echo "exiftool:         $target_file_date_exif"
# echo "stat:             $target_file_date_stat"
# echo "target_file_date: $target_file_date"
# echo ""
# echo "dest_dir_sub:     $dest_dir_sub"
# echo ""

if [ -z "$dest_dir_sub" ]; then
  if [ -z "$SILENT" ]; then
    echo "no dest_dir_sub set.  skipping"
  fi
  exit 0
fi

src_dir="$(dirname "$target_file")"
dest_dir_full="$dest_dir/$dest_dir_sub"
if [ "$src_dir" = "$dest_dir_full" ]; then
  if [ -z "$SILENT" ]; then
    echo "src and dest are the same.  skipping"
  fi
  exit 0
fi

./move-file.sh "$target_file" "$dest_dir_full"