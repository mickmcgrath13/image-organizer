#!/bin/bash



from_path="/media/tron/Seagate Expansion Drive/GooglePhotos/dist"

type="$1"
item_key="$2"


if [ -z "$LOG_ROOT" ]; then
	LOG_ROOT="/media/tron/Seagate Expansion Drive/GooglePhotos/log_sync"
fi
if [ -z "$LOG_FILE" ]; then
	LOG_FILE="2020-07-12-125119.log"
fi

function jsonify(){
	local json_str="$1"
	echo "$json_str" | sed '1s/^/[/;$!s/$/,/;$s/$/]/' | tr -d '\n'
}

function count_by_folder(){
	local j="$1"
	local p="$2"
	j="$(echo "$j" | jq -r ".[].$p")"
	j="${j//\/media\/tron\/Seagate Expansion Drive\/GooglePhotos\/dist\//}"
	j="$(echo "$j" | sed 's,/*[^/]\+/*$,,')"
	echo "$j" | jq -R -s -c 'split("\n")' | jq -r -c "map({item: .}) | group_by(.item) | map({item: .[0].item, count: length})"
}

raw_str="$(cat "$LOG_ROOT/$LOG_FILE" | grep $type)"
json_str="$(jsonify "$raw_str")"

echo "$(count_by_folder "$json_str" "$item_key")"
