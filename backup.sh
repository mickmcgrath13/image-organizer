#!/bin/bash
cd /var/services/photo/AllPhotos/image-organizer
PHOTOS_ROOT="/var/services/photo"
DEST_FOLDER="$PHOTOS_ROOT/AllPhotos/photos"
LOG_FOLDER="$PHOTOS_ROOT/AllPhotos/log"

# SRC_FOLDER should be from $PHOTOS_ROOT
SRC_FOLDER="$1"


echo ""
echo "Checkig if LOG_FOLDER exists ($LOG_FOLDER)"
if [ -d "$LOG_FOLDER" ]; then
  echo "   LOG_FOLDER exists"
else
  echo "   LOG_FOLDER does not exist.  Creating"
  mkdir -p "$LOG_FOLDER"
fi
echo ""




current_date_str=$(date +'%Y-%m-%d-%H%M%S')
log_file_name="${current_date_str}_${SRC_FOLDER}.log"
echo "log_file_name: $log_file_name"

touch "$LOG_FOLDER/${log_file_name}"

IMAGE_ORGANIZER_MOVE="1" \
DRY_RUN="1" \
SILENT="1" \
OUTPUT_DATE_DETAILS="1" \
./run.sh \
"$PHOTOS_ROOT/$SRC_FOLDER" \
"$DEST_FOLDER" | tee -a "$LOG_FOLDER/${log_file_name}"