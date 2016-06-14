#!/bin/bash

#thanks to a stackexchange post for this one.....

find -name "* *" -print0 | sort -rz | \
	while read -d $'\0' f; do mv -v "$f" "$(dirname "$f")/$(basename "${f// /_}")"; done