#!/bin/bash

d="$1"
y=$(date -d "$d" "+%Y")
m=$(date -d "$d" "+%B")
echo "$y/$m"