#!/bin/bash

target_file="$1"
dest_dir="$2"
dest_dir_sub="$3"
json_file="$4"

dest_dir_full="$dest_dir/$dest_dir_sub"

# echo "    Ensure dest dir exists:"
# echo "        dest root:      $dest_dir"
# echo "        dest sub:       $dest_dir_sub"
# echo "        dest_dir_full:  $dest_dir_full"
if [ -z "$DRY_RUN" ]; then
  mkdir -p "$dest_dir_full"
fi


dest_file="$(./last-path-part.sh "$target_file")"
dest_file_full="$dest_dir_full/$dest_file"
while [ -f "$dest_file_full" ]; do
  dest_file="0_${dest_file}"
  dest_file_full="$dest_dir_full/$dest_file"
  echo "        Renaming:"
  echo "        $dest_file"
done

if [ -n "$IMAGE_ORGANIZER_MOVE" ]; then
  echo "    MOVING:"
  echo "        from: $target_file"
  echo "        to: $dest_file_full"

  if [ -z "$DRY_RUN" ]; then
    mv "$target_file" "$dest_file_full"
  fi

  # move corresponding json file, too
  #  taking a shortcut by simply appending '.json'
  if [ -n "$json_file" ]; then
    echo "    MOVING corresponding json file:"
    echo "        from: $target_file"
    echo "        to: ${dest_file_full}.json"

    if [ -z "$DRY_RUN" ]; then
      mv "$json_file" "${dest_file_full}.json"
    fi
  fi
else
  echo "    COPYING:"
  echo "        from: $target_file"
  echo "        to: $dest_file_full"

  if [ -z "$DRY_RUN" ]; then
    cp "$target_file" "$dest_file_full"
  fi

  # copy corresponding json file, too
  #  taking a shortcut by simply appending '.json'
  if [ -n "$json_file" ]; then
    echo "    COPYING corresponding json file:"
    echo "        from: $target_file"
    echo "        to: ${dest_file_full}.json"

    if [ -z "$DRY_RUN" ]; then
      cp "$json_file" "${dest_file_full}.json"
    fi
  fi
fi