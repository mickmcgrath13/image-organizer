#!/bin/bash

monthname="$1"

monthnumber="$(date -d "2000 1 $monthname" "+%m" 2>&1)"

if [ -n "$(echo "$monthnumber" | grep invalid)" ]; then
	monthnumber="$monthname"
fi

echo "$monthnumber"