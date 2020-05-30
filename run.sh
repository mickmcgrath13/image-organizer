#!/bin/bash

target_dir="$1"
dest_dir="$2"

START_TIME="$(date "+%Y-%m-%d %H:%M:%S %3N")" #add %3N as we want millisecond too
START_TIME_SECONDS="$(date "+%s")"

echo ""
echo "======= Moving pictures ======="
echo "from:"
echo "    $target_dir"
echo "to:"
echo "    $dest_dir"
echo "date: $START_TIME"
echo "DRY_RUN: $DRY_RUN"
echo "SILENT: $SILENT"
if [ -z "$(which exif)" ]; then
	echo "exif command exists: no"
else
	echo "exif command exists: yes"
fi
if [ -z "$(which exiftool)" ]; then
	echo "exiftool command exists: no"
else
	echo "exiftool command exists: yes"
fi
echo "==============================="
echo ""


if [ -d "$dest_dir" ]; then
  echo "Dest exists: $dest_dir"
  echo ""
else
  echo "Creating dest: $dest_dir"
  echo ""
  if [ -z "$DRY_RUN" ]; then
	  mkdir -p "$dest_dir"
	fi
fi

./process-item.sh "$target_dir" "$dest_dir"

END_TIME="$(date "+%Y-%m-%d %H:%M:%S %3N")" #add %3N as we want millisecond too
END_TIME_SECONDS="$(date "+%s")"

echo ""
echo "======= Moving pictures DONE ======="
echo "date:"
echo "$END_TIME"  
echo "Took: $(expr $END_TIME_SECONDS - $START_TIME_SECONDS) Seconds"
echo "==============================="
echo ""