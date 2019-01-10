/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package gml

// #cgo pkg-config: Qt5Core Qt5Qml Qt5Quick
// #cgo CFLAGS: -I${SRCDIR}/binding/headers
// #cgo LDFLAGS: -lstdc++
// #cgo LDFLAGS: ${SRCDIR}/binding/build/libbinding.a
// #include <gml.h>
import "C"
