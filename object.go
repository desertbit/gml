/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package gml

import (
	"unsafe"
)

type Object struct {
	ptr unsafe.Pointer
}

func (o *Object) GMLObject_Pointer() unsafe.Pointer {
	return o.ptr
}

func (o *Object) GMLObject_SetPointer(ptr unsafe.Pointer) {
	o.ptr = ptr
}
