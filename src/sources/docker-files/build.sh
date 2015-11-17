#!/bin/bash

for f in `ls -A`; do
  if [[ "$f" == *.sh ]]; then
    echo "$ chmod a+x $f"
    chmod a+x $f
  fi
done