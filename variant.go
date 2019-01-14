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
	"runtime"
	"unsafe"
)

type Variant struct {
	freed bool
	ptr   C.gml_variant
}

// TODO: free variant again. also add Free method and free as soon as possible within the gen code.
func ToVariant(i interface{}) (v *Variant) {
	v = &Variant{}

	// Always free the C++ value.
	runtime.SetFinalizer(v, freeVariant)

	switch d := i.(type) {
	case nil:
		v.ptr = C.gml_variant_new() // Always create a valid QVariant.

	case bool:
		var b C.u_int8_t
		if d {
			b = 1
		}
		v.ptr = C.gml_variant_new_from_bool(b)

	case float32:
		v.ptr = C.gml_variant_new_from_float(C.float(d))
	case float64:
		v.ptr = C.gml_variant_new_from_double(C.double(d))

	case int:
		v.ptr = C.gml_variant_new_from_int(C.int(d))
	case int8:
		v.ptr = C.gml_variant_new_from_int8(C.int8_t(d))
	case uint8: // Alias for byte
		v.ptr = C.gml_variant_new_from_uint8(C.u_int8_t(d))
	case int16:
		v.ptr = C.gml_variant_new_from_int16(C.int16_t(d))
	case uint16:
		v.ptr = C.gml_variant_new_from_uint16(C.u_int16_t(d))
	case int32:
		v.ptr = C.gml_variant_new_from_int32(C.int32_t(d))
	case uint32:
		v.ptr = C.gml_variant_new_from_uint32(C.u_int32_t(d))
	case int64:
		v.ptr = C.gml_variant_new_from_int64(C.int64_t(d))
	case uint64:
		v.ptr = C.gml_variant_new_from_uint64(C.u_int64_t(d))

	case Char:
		v.ptr = C.gml_variant_new_from_qchar(C.int32_t(d))
	case string:
		cstr := C.CString(d)
		defer C.free(unsafe.Pointer(cstr))
		v.ptr = C.gml_variant_new_from_string(cstr) // Makes a deep copy.
	case []byte:
		v.ptr = C.gml_variant_new_from_bytes((*C.char)(unsafe.Pointer(&d[0])), C.int(len(d))) // Makes a deep copy.

	// TODO: QStringList?

	default:
		v.ptr = C.gml_variant_new() // Always create a valid QVariant.
	}

	// Check if something failed.
	// This should never happen is signalizes a fatal error.
	if v.ptr == nil {
		panic(fmt.Errorf("failed to create gml variant: C pointer is nil"))
	}
	return
}

func freeVariant(v *Variant) {
	if v.freed {
		return
	}
	v.freed = true
	C.gml_variant_free(v.ptr)
}

func (v *Variant) Free() {
	freeVariant(v)
}

func (v *Variant) Pointer() unsafe.Pointer {
	return unsafe.Pointer(v.ptr)
}
