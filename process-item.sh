#!/bin/bash

target_item="$1"
dest_dir="$2"

if [ -z "$SILENT" ]; then
	echo ""
	echo ""
	echo ""
fi

# echo "Processing item (file or directory?):"
# echo "    $target_item"
if [ -d "$target_item" ]; then
  # echo "    is directory"
  ./process-directory.sh "$target_item" "$dest_dir"
elif [ -f "$target_item" ]; then
  # echo "    is file"
  if [ -n "$EXIF_CHECK" ] && ( [ -n "$(which exif)" ] || [ -n "$(which exiftool)"] ); then
  	./process-file-exif.sh "$target_item" "$dest_dir"
  else
  	if [ -z "$(which exif)" ]; then
  		if [ -z "$SILENT" ]; then
	  		echo "    exif command not available"
	  	fi
  	fi

  	if [ -z "$(which exiftool)" ]; then
  		if [ -z "$SILENT" ]; then
	  		echo "    exiftool command not available"
	  	fi
  	fi
  	./process-file.sh "$target_item" "$dest_dir"
  fi
else
  echo "    Not processing $target_item"
  echo "    neither file nor directory"
fi
