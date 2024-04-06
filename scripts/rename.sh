#!/bin/bash

for f in *; do
	if [[ -d $f ]]; then
		sed -i "s/\*\.qml/*.js/g" $f/CMakeLists.txt
	fi
done