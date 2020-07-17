#!/bin/bash


SRC_FOLDER="/run/user/1000/gvfs/smb-share:server=192.168.1.100,share=photo/GooglePhotos"
DEST_FOLDER="/run/user/1000/gvfs/smb-share:server=192.168.1.100,share=photo/AllPhotos/photos"
LOG_FOLDER="/media/tron/Seagate Expansion Drive/GooglePhotos/log_google_sync_nas"


if [ -n "$CLEAN_TEST" ]; then
	echo "cleaning LOG_FOLDER: $LOG_FOLDER"
	rm -rf "$LOG_FOLDER"
	exit 0
fi


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
log_file_name="${current_date_str}.log"
echo "log_file_name: $log_file_name"

touch "$LOG_FOLDER/${log_file_name}"

IMAGE_ORGANIZER_MOVE="1" \
DRY_RUN="1" \
SILENT="1" \
SKIP_IF_EXISTS="1" \
SKIP_JSON_OUTPUT="1" \
./run.sh \
"$SRC_FOLDER" \
"$DEST_FOLDER" | tee -a "$LOG_FOLDER/${log_file_name}"