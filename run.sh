#!/bin/bash

image_name=$1

if [ -z "$image_name" ]; then
  docker ps
else
  docker run -i -t $image_name /bin/bash
  #docker run -p 80 -i -t $image_name /bin/bash
fi
