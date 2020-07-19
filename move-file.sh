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


###
###  RENAME LOGIC
###
dest_file="$(./last-path-part.sh "$target_file")"
dest_file_full="$dest_dir/$dest_file"
renamed_str=""
dest_file_start="$dest_file"
while [ -f "$dest_file_full" ]; do
  dest_file="0_${dest_file}"
  dest_file_full="$dest_dir/$dest_file"
  if [ -z "$SILENT" ]; then
    echo "        Renaming:"
    echo "        $dest_file"
  fi
  renamed_str=",\"renamed\": true,\"renamed_from\":\"$dest_file_start\",\"renamed_to\":\"$dest_file\""
done


# skip if file starts with 0_
if [ -n "SKIP_IF_RENAMED_BEFORE" ]; then
  if [ -z "$renamed_str" ]; then
    STARTS_WITH_0="$(./starts-with-zero "$dest_file")"
    if [ -n "$STARTS_WITH_0" ]; then
      renamed_str=",\"renamed\": true,\"STARTS_WITH_0\":\"true\",\"file\":\"$dest_file_full\""
    fi
  fi
fi


###
###  DRY_RUN LOGIC
###
dry_run_str=""
if [ -n "$DRY_RUN" ]; then
  dry_run_str=",\"dry-run\": true"
fi


###
###  SKIP LOGIC
###
skipped_str=""
if [ -n "$SKIP_IF_EXISTS" ]; then
  skipped_str=",\"skip-if-exists\": true"
fi



skip_action=""
if [ -n "$dry_run_str" ] || ([ -n "$skipped_str" ] && [ -n "$renamed_str" ]); then
  skip_action="1"
fi


#  taking a shortcut by simply appending '.json'
dest_file_full_json="${dest_file_full}.json"


###
###  MOVE OR COPY
###
action_str_moving="\"action\":\"moving\""
action_str_copying="\"action\":\"copying\""
from_to_str=",\"from\":\"$target_file\",\"to\":\"$dest_file_full\""
from_to_str_json=",\"from\":\"$json_file\",\"to\":\"${dest_file_full_json}\""


if [ -n "$IMAGE_ORGANIZER_MOVE" ]; then
  echo "{${action_str_moving}${from_to_str}${renamed_str}${dry_run_str}${skipped_str}}"

  if [ -z "$skip_action" ]; then
    if [ -n "$IMAGE_ORGANIZER_MOVE_COPYDELETE" ]; then
      cp "$target_file" "$dest_file_full"
      if [ -f "$dest_file_full" ]; then
        echo "{\"remote\":\"$dest_file_full\",\"local\":\"$target_file\", \"copydelete\": true, \"success\": \"remote exists. delete local.\"}"
        rm "$target_file"
      else
        echo "{\"remote\":\"$dest_file_full\",\"local\":\"$target_file\", \"copydelete\": true, \"error\": \"file does not exist in remote location\"}"
      fi
    else
      mv "$target_file" "$dest_file_full"
    fi
  fi

  # move corresponding json file, too
  if [ -n "$json_file" ]; then
    if [ -z "$SKIP_JSON_OUTPUT" ]; then
      echo "{${action_str_moving}${from_to_str_json}}"
    fi

    if [ -z "$skip_action" ]; then
      if [ -n "$IMAGE_ORGANIZER_MOVE_COPYDELETE" ]; then
        cp "$json_file" "${dest_file_full_json}"
        if [ -f "${dest_file_full_json}" ]; then
          echo "{\"remote\":\"$dest_file_full_json\",\"local\":\"$json_file\", \"copydelete\": true, \"success\": \"remote exists. delete local.\"}"
          rm "$json_file"
        else
          echo "{{\"remote\":\"$dest_file_full_json\",\"local\":\"$json_file\", \"copydelete\": true, \"error\": \"file does not exist in remote location\"}"
        fi
      else
        mv "$json_file" "${dest_file_full_json}"
      fi
    fi
  fi
else
  echo "${action_str_copying}${from_to_str}${renamed_str}${skipped_str}}"
  if [ -z "$skip_action" ]; then
    cp "$target_file" "$dest_file_full"
  fi

  # copy corresponding json file, too
  #  taking a shortcut by simply appending '.json'
  if [ -n "$json_file" ]; then
    if [ -z "$SKIP_JSON_OUTPUT" ]; then
      echo "${action_str_copying}${from_to_str_json}}"
    fi

    if [ -z "$skip_action" ]; then
      cp "$json_file" "${dest_file_full_json}"
    fi
  fi
fi