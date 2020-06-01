#!/bin/bash

d1=$(date -d "$1" "+%s")
d2=$(date -d "$2" "+%s")
d3=$(date -d "$3" "+%s")
d4=$(date -d "$4" "+%s")
d5=$(date -d "$5" "+%s")

d_out="$1"
min="$d1"

if [ -n "$2" ] && [ "$d2" -lt "$min" ]; then
	d_out="$2"
	min="$d2"
fi

if [ -n "$3	" ] && [ "$d3" -lt "$min" ]; then
	d_out="$3"
	min="$d3"
fi

if [ -n "$4" ] && [ "$d4" -lt "$min" ]; then
	d_out="$4"
	min="$d4"
fi

if [ -n "$5" ] && [ "$d5" -lt "$min" ]; then
	d_out="$5"
	min="$d5"
fi

echo "$d_out"