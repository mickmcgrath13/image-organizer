#!/bin/bash

target_file="$1"
dest_dir="$2"

if [ -z "$DRY_RUN" ]; then
  mkdir -p "$dest_dir"
fi


json_file_test="${target_file}.json"
json_file=""
if [ -f "$json_file_test" ]; then
  if [ -z "$SILENT" ]; then
    echo "    corresponding .json file: $(./last-path-part.sh "$json_file_test")"
  fi

  json_file="$json_file_test"
fi



dest_file="$(./last-path-part.sh "$target_file")"
dest_file_full="$dest_dir/$dest_file"
while [ -f "$dest_file_full" ]; do
  dest_file="0_${dest_file}"
  dest_file_full="$dest_dir/$dest_file"
  if [ -z "$SILENT" ]; then
    echo "        Renaming:"
    echo "        $dest_file"
  fi
done

if [ -n "$IMAGE_ORGANIZER_MOVE" ]; then
  echo "{\"action\":\"moving\",\"from\":\"$target_file\",\"to\":\"$dest_file_full\"}"

  if [ -z "$DRY_RUN" ]; then
    mv "$target_file" "$dest_file_full"
  fi

  # move corresponding json file, too
  #  taking a shortcut by simply appending '.json'
  if [ -n "$json_file" ]; then
    echo "{\"action\":\"moving\",\"from\":\"$json_file\",\"to\":\"${dest_file_full}.json\"}"

    if [ -z "$DRY_RUN" ]; then
      mv "$json_file" "${dest_file_full}.json"
    fi
  fi
else
  echo "{\"action\":\"copying\",\"from\":\"$target_file\",\"to\":\"$dest_file_full\"}"
  if [ -z "$DRY_RUN" ]; then
    cp "$target_file" "$dest_file_full"
  fi

  # copy corresponding json file, too
  #  taking a shortcut by simply appending '.json'
  if [ -n "$json_file" ]; then
    echo "{\"action\":\"copying\",\"from\":\"$json_file\",\"to\":\"${dest_file_full}.json\"}"

    if [ -z "$DRY_RUN" ]; then
      cp "$json_file" "${dest_file_full}.json"
    fi
  fi
fi