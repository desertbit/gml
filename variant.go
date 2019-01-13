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
	ptr C.gml_variant
}

// TODO: free variant again. also add Free method and free as soon as possible within the gen code.
func ToVariant(i interface{}) (v *Variant) {
	// TODO: always create a valid QVariant
	v = &Variant{}
	v.ptr = C.gml_variant_new()
	return
}

func (v *Variant) Pointer() unsafe.Pointer {
	return unsafe.Pointer(v.ptr)
}
