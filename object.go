/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package gml

// #include <gml.h>
import "C"

import (
	"fmt"
	"unsafe"
)

type Object struct {
	ptr unsafe.Pointer
}

func (o *Object) GMLObject_Pointer() unsafe.Pointer {
	if o.ptr == nil {
		panic(fmt.Errorf("gml.Object pointer is nil: did you call GMLInit()?"))
	}
	return o.ptr
}

func (o *Object) GMLObject_SetPointer(ptr unsafe.Pointer) {
	o.ptr = ptr
}

func (o *Object) GMLObject() *Object {
	return o
}

func (o *Object) cObject() C.gml_object {
	return (C.gml_object)(o.GMLObject_Pointer())
}
