#!/usr/bin/env bash

set -e

input="$GML_DEST_BINARY"
destDir="$GML_DEST_DIR/deps"

if [[ "$input" == "" ]]; then
    echo "no executable"
    exit 1
elif [[ "$destDir" == "" ]]; then
    echo "no target directory specified"
    exit 1
fi

if [[ -d "$destDir" ]]; then
    rm -rf "$destDir"
fi

gml-copy-dlls \
    -input "$input" \
    -dest "$destDir"   \
    -src "/mxe/usr/${CROSS_TRIPLE}" \
    -enforce "/mxe/usr/${CROSS_TRIPLE}/qt5/qml,/mxe/usr/${CROSS_TRIPLE}/qt5/plugins/platforms,/mxe/usr/${CROSS_TRIPLE}/qt5/plugins/imageformats,/mxe/usr/${CROSS_TRIPLE}/qt5/plugins/position,/mxe/usr/${CROSS_TRIPLE}/qt5/plugins/geoservices" \
    -objdump "/mxe/usr/bin/${CROSS_TRIPLE}-objdump"

mv -f "$destDir/qml/"* "$destDir/"
rm -rf "$destDir/qml"