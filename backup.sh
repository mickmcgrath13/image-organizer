#!/bin/bash
cd /var/services/photo/AllPhotos/image-organizer
PHOTOS_ROOT="/var/services/photo"
DEST_FOLDER="$PHOTOS_ROOT/AllPhotos/photos"

# SRC_FOLDER should be from $PHOTOS_ROOT
SRC_FOLDER="$1"
current_date_str=$(date +'%Y-%m-%d-%H%M%S')
log_file_name="${current_date_str}_${SRC_FOLDER}.log"
echo "log_file_name: $log_file_name"

IMAGE_ORGANIZER_MOVE="1" \
./run.sh \
"$PHOTOS_ROOT/$SRC_FOLDER" \
"$DEST_FOLDER" | tee -a "$PHOTOS_ROOT/AllPhotos/log/${log_file_name}"