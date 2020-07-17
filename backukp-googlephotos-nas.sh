#!/bin/bash
cd /var/services/photo/AllPhotos/image-organizer

SRC_FOLDER="/var/services/photo/GooglePhotos"
DEST_FOLDER="/var/services/photo/GooglePhotosReformat"
LOG_FOLDER="/var/services/photo/GooglePhotosReformat_log"


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
log_file_name="${current_date_str}_GooglePhotosReformat_log.log"
echo "log_file_name: $log_file_name"

touch "$LOG_FOLDER/${log_file_name}"

# DRY_RUN="1" \
IMAGE_ORGANIZER_MOVE="1" \
SILENT="1" \
OUTPUT_DATE_DETAILS="1" \
./run.sh \
"$SRC_FOLDER" \
"$DEST_FOLDER" | tee -a "$LOG_FOLDER/${log_file_name}"