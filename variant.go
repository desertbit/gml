/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package gml

// #include <gml.h>
import "C"

import (
	"unsafe"
)

type Variant struct {
	ptr unsafe.Pointer
}

func ToVariant(i interface{}) (v *Variant) {
	// TODO: always create a valid QVariant
	return
}

func (v *Variant) Pointer() unsafe.Pointer {
	return v.ptr
}
