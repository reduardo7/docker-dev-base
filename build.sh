#!/bin/bash

image_name="$1"
image_id="$2"

if [ -z "$image_name" ]; then
  echo "Error! No image name."
  exit 1
fi

if [ -z "$image_name" ]; then
  docker ps
else
  if [ -z "$image_id" ]; then
    docker build -t $image_name .
  else
    docker commit $image_id $image_name
  fi
fi
