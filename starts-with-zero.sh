#!/bin/bash

var="$1"

if [[ "$var" =~ ^0_.*  ]]; then
    echo "true"
fi