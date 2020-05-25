#!/bin/bash

target_file="$1"
dest_dir="$2"
dest_dir_sub=""


if [ ! -f "$target_file" ]; then
  echo "    is not file: $target_file"
  exit 0
fi

echo "Processing file:"
echo "    $target_file"


# check for corresponding json file
json_file_test="${target_file}.json"
json_file=""
if [ -f "$json_file_test" ]; then
  echo "    corresponding .json file: $(./last-path-part.sh "$json_file_test")"
  json_file="$json_file_test"

  json_data="$(cat "$json_file")"
  photoTakenTimeTimestamp="$(echo "$json_data" | ./bin/jq-linux64 -r  ".photoTakenTime.timestamp")"

  # "1279663094" || null
  if [ -n "$photoTakenTimeTimestamp" ]; then
    modified_year=$(date -d "@${photoTakenTimeTimestamp}" "+%Y")
    modified_month=$(date -d "@${photoTakenTimeTimestamp}" "+%B")
    dest_dir_sub="$modified_year/$modified_month"
    echo "    Setting date from corresponding json file '.photoTakenTime.timestamp': $dest_dir_sub"
  else
    echo "    corresponding json file does not contain key: .photoTakenTime.timestamp"
  fi

else
  echo "    corresponding json file does not exist"
fi


# if no date set, check if file's directory starts with format yyyy-mm-dd
if [ -z "$dest_dir_sub" ]; then
  parent_dir="$(./get-parent-dir.sh "$target_file")"
  parent_dir_date_str="$(./extract-date-from-dirname.sh "$parent_dir")"

  if [ -n "$parent_dir_date_str" ]; then
    modified_year=$(date -d "${parent_dir_date_str}" "+%Y")
    modified_month=$(date -d "${parent_dir_date_str}" "+%B")
    dest_dir_sub="$modified_year/$modified_month"
    echo "    Parent dir had format (yyyy-mm-dd): $dest_dir_sub"
  else
    echo "    Parent dir did not have format (yyyy-mm-dd): $parent_dir"
  fi
fi


# TODO: if no date set, check if file has exif data


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
  echo "    Setting date from 'stat' command: $dest_dir_sub"
fi



if [ -z "$dest_dir_sub" ]; then
  echo "no dest_dir_sub set.  skipping"
  exit 0
fi


dest_dir_full="$dest_dir/$dest_dir_sub"

# echo "    Ensure dest dir exists:"
# echo "        dest root:      $dest_dir"
# echo "        dest sub:       $dest_dir_sub"
# echo "        dest_dir_full:  $dest_dir_full"
mkdir -p "$dest_dir_full"



# echo "    Check if file exists"
dest_file="$(./last-path-part.sh "$target_file")"
dest_file_full="$dest_dir_full/$dest_file"
while [ -f "$dest_file_full" ]; do
  dest_file="0_${dest_file}"
  dest_file_full="$dest_dir_full/$dest_file"
  echo "        File already exists ($dest_file_full)."
  echo "            Renaming:"
  echo "            $dest_file"
done

if [ -n "$IMAGE_ORGANIZER_MOVE" ]; then
  echo "    MOVING:"
  echo "        from: $target_file"
  echo "        to: $dest_file_full"
  mv "$target_file" "$dest_file_full"

  # move corresponding json file, too
  #  taking a shortcut by simply appending '.json'
  if [ -n "$json_file" ]; then
    echo "    MOVING corresponding json file:"
    echo "        from: $target_file"
    echo "        to: ${dest_file_full}.json"
    mv "$json_file" "${dest_file_full}.json"
  fi
else
  echo "    COPYING:"
  echo "        from: $target_file"
  echo "        to: $dest_file_full"
  cp "$target_file" "$dest_file_full"

  # copy corresponding json file, too
  #  taking a shortcut by simply appending '.json'
  if [ -n "$json_file" ]; then
    echo "    COPYING corresponding json file:"
    echo "        from: $target_file"
    echo "        to: ${dest_file_full}.json"
    cp "$json_file" "${dest_file_full}.json"
  fi
fi

