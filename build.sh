#!/bin/bash

if [ -z "$BASH" ]; then
    bash "$0" "$@"
    exit $?
fi

# Utils

s() {
    echo
    echo
}

e() {
    echo "# $@"
}

# Build

image_name="$1"
image_id="$2"
if [ -z "$image_name" ]; then
    e "Usage:"
    e "    $0 IMAGE_NAME [IMAGE_ID]"
    e
    e "    IMAGE_NAME: Image Name"
    e "    IMAGE_ID: (OPTIONAL) Image ID (see 'docker ps')"
    exit 1
fi

s ; s

e "Resources..."
mkdir resources
ln -fs /home/ecuomo resources/home

if [ -z "$image_id" ]; then
    e "Building ${image_name}..."
    docker build -t $image_name .
else
    e "Building ${image_name} from ${image_id}..."
    docker commit $image_id $image_name
fi
