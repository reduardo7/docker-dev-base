#!/bin/bash

for f in $PATH_HOME/*.sh; do
	chmod a+x $f
done