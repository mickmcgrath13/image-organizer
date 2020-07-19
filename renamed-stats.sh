#!/bin/bash


if [ -z "$LOG_ROOT" ]; then
	LOG_ROOT="/media/tron/Seagate Expansion Drive/GooglePhotos/log_sync"
fi
if [ -z "$LOG_FILE" ]; then
	LOG_FILE="2020-07-12-125119.log"
fi

#################
################# DEBUGGING
#################
arr_renamed='[{"item":"","count":1},{"item":"2004/February","count":1},{"item":"2004/January","count":1},{"item":"2005/February","count":1},{"item":"2005/January","count":1},{"item":"2010/August","count":21},{"item":"2010/December","count":4},{"item":"2010/July","count":27},{"item":"2010/November","count":3},{"item":"2010/October","count":8},{"item":"2010/September","count":14},{"item":"2011/April","count":4},{"item":"2011/August","count":1},{"item":"2011/December","count":28},{"item":"2011/February","count":5},{"item":"2011/January","count":5},{"item":"2011/September","count":11},{"item":"2012/April","count":94},{"item":"2012/August","count":24},{"item":"2012/December","count":54},{"item":"2012/February","count":23},{"item":"2012/January","count":45},{"item":"2012/July","count":59},{"item":"2012/June","count":18},{"item":"2012/March","count":60},{"item":"2012/May","count":124},{"item":"2012/November","count":77},{"item":"2012/October","count":74},{"item":"2012/September","count":13},{"item":"2013/April","count":70},{"item":"2013/August","count":44},{"item":"2013/February","count":5},{"item":"2013/January","count":24},{"item":"2013/July","count":18},{"item":"2013/June","count":2},{"item":"2013/March","count":63},{"item":"2013/May","count":8},{"item":"2013/October","count":51},{"item":"2013/September","count":28},{"item":"2014/December","count":1},{"item":"2015/January","count":1},{"item":"2016/December","count":2},{"item":"2016/May","count":540},{"item":"2017/February","count":2},{"item":"2018/December","count":2},{"item":"2018/July","count":2},{"item":"2018/November","count":2},{"item":"2018/October","count":2}]'
arr_processed='[{"item":"","count":1},{"item":"2004/February","count":1},{"item":"2004/January","count":1},{"item":"2005/February","count":1},{"item":"2005/January","count":1},{"item":"2005/October","count":1},{"item":"2006/February","count":18},{"item":"2006/November","count":2},{"item":"2008/December","count":1},{"item":"2010/August","count":91},{"item":"2010/December","count":10},{"item":"2010/July","count":92},{"item":"2010/November","count":12},{"item":"2010/October","count":34},{"item":"2010/September","count":43},{"item":"2011/April","count":68},{"item":"2011/August","count":28},{"item":"2011/December","count":87},{"item":"2011/February","count":26},{"item":"2011/January","count":27},{"item":"2011/July","count":5},{"item":"2011/June","count":40},{"item":"2011/May","count":16},{"item":"2011/November","count":53},{"item":"2011/October","count":585},{"item":"2011/September","count":18},{"item":"2012/April","count":135},{"item":"2012/August","count":35},{"item":"2012/December","count":63},{"item":"2012/February","count":35},{"item":"2012/January","count":65},{"item":"2012/July","count":92},{"item":"2012/June","count":32},{"item":"2012/March","count":99},{"item":"2012/May","count":169},{"item":"2012/November","count":88},{"item":"2012/October","count":96},{"item":"2012/September","count":13},{"item":"2013/April","count":78},{"item":"2013/August","count":117},{"item":"2013/February","count":8},{"item":"2013/January","count":33},{"item":"2013/July","count":87},{"item":"2013/June","count":27},{"item":"2013/March","count":72},{"item":"2013/May","count":16},{"item":"2013/October","count":113},{"item":"2013/September","count":68},{"item":"2014/April","count":266},{"item":"2014/August","count":33},{"item":"2014/December","count":67},{"item":"2014/February","count":187},{"item":"2014/January","count":188},{"item":"2014/July","count":58},{"item":"2014/June","count":142},{"item":"2014/March","count":144},{"item":"2014/May","count":176},{"item":"2014/November","count":35},{"item":"2014/October","count":35},{"item":"2014/September","count":37},{"item":"2015/April","count":41},{"item":"2015/August","count":166},{"item":"2015/December","count":545},{"item":"2015/February","count":55},{"item":"2015/January","count":128},{"item":"2015/July","count":68},{"item":"2015/June","count":250},{"item":"2015/March","count":106},{"item":"2015/May","count":88},{"item":"2015/November","count":439},{"item":"2015/October","count":179},{"item":"2015/September","count":236},{"item":"2016/April","count":87},{"item":"2016/August","count":77},{"item":"2016/December","count":379},{"item":"2016/February","count":45},{"item":"2016/January","count":130},{"item":"2016/July","count":91},{"item":"2016/June","count":65},{"item":"2016/March","count":57},{"item":"2016/May","count":912},{"item":"2016/November","count":238},{"item":"2016/October","count":40},{"item":"2016/September","count":379},{"item":"2017/April","count":1406},{"item":"2017/August","count":6311},{"item":"2017/December","count":4427},{"item":"2017/February","count":886},{"item":"2017/January","count":1072},{"item":"2017/July","count":807},{"item":"2017/June","count":2819},{"item":"2017/March","count":1032},{"item":"2017/May","count":1920},{"item":"2017/November","count":1137},{"item":"2017/October","count":1677},{"item":"2017/September","count":2178},{"item":"2018/April","count":3375},{"item":"2018/August","count":7746},{"item":"2018/December","count":4051},{"item":"2018/February","count":1241},{"item":"2018/January","count":1373},{"item":"2018/July","count":5371},{"item":"2018/June","count":3356},{"item":"2018/March","count":5125},{"item":"2018/May","count":1108},{"item":"2018/November","count":2196},{"item":"2018/October","count":1448},{"item":"2018/September","count":1331}]'
years="
2004
2005
"
months="
January
February
March"
#################
################# END DEBUGGING
#################



echo "LOG_ROOT: $LOG_ROOT"
echo "LOG_FILE: $LOG_FILE"

arr_renamed="$(IS_NAS="$IS_NAS" LOG_ROOT="$LOG_ROOT" LOG_FILE="$LOG_FILE" /bin/bash count-per-folder.sh "renamed" "from")"
arr_processed="$(IS_NAS="$IS_NAS" LOG_ROOT="$LOG_ROOT" LOG_FILE="$LOG_FILE" /bin/bash count-per-folder.sh "processing" "processing")"

years="
2004
2005
2006
2007
2008
2009
2010
2011
2012
2013
2014
2015
2016
2017
2018
2019
2020
"
months="
January
February
March
April
May
June
July
August
September
October
November
December
"

output=""
while IFS= read -r year; do
	if [ -z "$year" ]; then continue; fi
	while IFS= read -r month; do
		if [ -z "$month" ]; then continue; fi

	    yearmonth="$year/$month"
		items_renamed="$(echo "$arr_renamed" | jq -r -c ".[] | select(.item == \"$yearmonth\") | .count"  | tr -d '[:space:]')"
		if [ -z "$items_renamed" ]; then
			items_renamed="0"
		fi

		items_processed="$(echo "$arr_processed" | jq -r -c ".[] | select(.item == \"$yearmonth\") | .count" | tr -d '[:space:]')"
		if [ -z "$items_processed" ]; then
			items_processed="0"
		fi

		output="$output
{\"item\": \"$yearmonth\",\"renamed\": $items_renamed, \"processed\": $items_processed}"
	done <<< "$months"
done <<< "$years"


echo "output"
echo "$output"