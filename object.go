/*
 * GML - Go QML
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 Roland Singer <roland.singer[at]desertbit.com>
 * Copyright (c) 2019 Sebastian Borchers <sebastian[at]desertbit.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package gml

// #include <gml.h>
import "C"

import (
	"fmt"
	"unsafe"
)

type objectInitializer interface {
	GmlInit()
}

type objectGetter interface {
	GmlObject() *Object
}

type Object struct {
	ptr   unsafe.Pointer
	goPtr unsafe.Pointer
}

func (o *Object) GmlObject_Pointer() unsafe.Pointer {
	if o.ptr == nil {
		panic(fmt.Errorf("gml.Object pointer is nil: did you call GmlInit()?"))
	}
	return o.ptr
}

func (o *Object) GmlObject_SetPointer(ptr unsafe.Pointer) {
	o.ptr = ptr
}

func (o *Object) GmlObject_GoPointer() unsafe.Pointer {
	if o.goPtr == nil {
		panic(fmt.Errorf("gml.Object go pointer is nil: did you call GmlInit()?"))
	}
	return o.goPtr
}

func (o *Object) GmlObject_SetGoPointer(goPtr unsafe.Pointer) {
	o.goPtr = goPtr
}

func (o *Object) GmlObject() *Object {
	return o
}

func (o *Object) cObject() C.gml_object {
	return (C.gml_object)(o.GmlObject_Pointer())
}

func toObject(i interface{}) (*Object, error) {
	if i == nil {
		return nil, fmt.Errorf("invalid value: failed to get object: value is nil")
	}

	switch v := i.(type) {
	case *Object:
		return v, nil
	case objectGetter:
		return v.GmlObject(), nil
	default:
		return nil, fmt.Errorf("unknown type: failed to get object %T", v)
	}
}
