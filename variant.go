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
	"errors"
	"fmt"
	"runtime"
	"unsafe"

	"github.com/desertbit/gml/internal/json"
)

// TODO: think about adding a ticker routine calling gc...
// Hint: consider freeing a variant if not required anymore
//       to release memory as fast as possible.
//       The go garbage collector does not know about the C++ data
//       and might not trigger a gc cycle to release memory.
//       Consider this if you store bigger data values into a variant.
type Variant struct {
	freed bool
	ptr   C.gml_variant
}

func NewVariantFromPointer(ptr unsafe.Pointer) (v *Variant) {
	return newVariant((C.gml_variant)(ptr))
}

// TODO: free variant again. also add Free method and free as soon as possible within the gen code.
func ToVariant(i interface{}) *Variant {
	var ptr C.gml_variant

	switch d := i.(type) {
	case nil:
		ptr = C.gml_variant_new() // Always create a valid QVariant.

	case bool:
		var b C.u_int8_t
		if d {
			b = 1
		}
		ptr = C.gml_variant_new_from_bool(b)

	case float32:
		ptr = C.gml_variant_new_from_float(C.float(d))
	case float64:
		ptr = C.gml_variant_new_from_double(C.double(d))

	case int:
		ptr = C.gml_variant_new_from_int(C.int(d))
	case int8:
		ptr = C.gml_variant_new_from_int8(C.int8_t(d))
	case uint8: // Alias for byte
		ptr = C.gml_variant_new_from_uint8(C.u_int8_t(d))
	case int16:
		ptr = C.gml_variant_new_from_int16(C.int16_t(d))
	case uint16:
		ptr = C.gml_variant_new_from_uint16(C.u_int16_t(d))
	case int32:
		ptr = C.gml_variant_new_from_int32(C.int32_t(d))
	case uint32:
		ptr = C.gml_variant_new_from_uint32(C.u_int32_t(d))
	case int64:
		ptr = C.gml_variant_new_from_int64(C.int64_t(d))
	case uint64:
		ptr = C.gml_variant_new_from_uint64(C.u_int64_t(d))

	case Char: // TODO: remove?
		ptr = C.gml_variant_new_from_rune(C.int32_t(d))
	case string:
		cstr := C.CString(d)
		defer C.free(unsafe.Pointer(cstr))
		ptr = C.gml_variant_new_from_string(cstr) // Makes a deep copy.
	case []byte:
		ptr = C.gml_variant_new_from_bytes((*C.char)(unsafe.Pointer(&d[0])), C.int(len(d))) // Makes a deep copy.

	default:
		data, err := json.Marshal(i)
		if err != nil {
			// Don't fail on an error.
			fmt.Println("gml: ToVariant: failed to marshal value to json: ", err)
			ptr = C.gml_variant_new() // Always create a valid QVariant.
		} else {
			ptr = C.gml_variant_new_from_bytes((*C.char)(unsafe.Pointer(&data[0])), C.int(len(data))) // Makes a deep copy.
		}
	}

	return newVariant(ptr)
}

func newVariant(ptr C.gml_variant) (v *Variant) {
	// This should never happen. Signalizes a fatal error.
	if ptr == nil {
		panic(fmt.Errorf("failed to create gml variant: C pointer is nil"))
	}

	v = &Variant{
		ptr: ptr,
	}
	runtime.SetFinalizer(v, freeVariant) // Always free the C value.
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

func (v *Variant) Release() {
	v.freed = true
}

func (v *Variant) Pointer() unsafe.Pointer {
	return unsafe.Pointer(v.ptr)
}

// Pass a pointer.
func (v *Variant) Decode(i interface{}) (err error) {
	if i == nil {
		return errors.New("decode input is nil")
	}

	switch d := i.(type) {
	case *bool:
		*d = (C.gml_variant_to_bool(v.ptr) != 0)

	case *float32:
		*d = float32(C.gml_variant_to_float(v.ptr))
	case *float64:
		*d = float64(C.gml_variant_to_double(v.ptr))

	case *int:
		*d = int(C.gml_variant_to_int(v.ptr))
	case *int8:
		*d = int8(C.gml_variant_to_int8(v.ptr))
	case *uint8: // Alias for byte
		*d = uint8(C.gml_variant_to_uint8(v.ptr))
	case *int16:
		*d = int16(C.gml_variant_to_int16(v.ptr))
	case *uint16:
		*d = uint16(C.gml_variant_to_uint16(v.ptr))
	case *int32:
		*d = int32(C.gml_variant_to_int32(v.ptr))
	case *uint32:
		*d = uint32(C.gml_variant_to_uint32(v.ptr))
	case *int64:
		*d = int64(C.gml_variant_to_int64(v.ptr))
	case *uint64:
		*d = uint64(C.gml_variant_to_uint64(v.ptr))

	case *Char: // TODO: remove?
		*d = Char(C.gml_variant_to_rune(v.ptr))
	case *string:
		b := newBytes()
		defer b.Free()

		C.gml_variant_to_string(v.ptr, b.ptr)
		buf := b.String()
		if len(buf) == 0 {
			*d = ""
		} else {
			*d = string(buf)
		}

	case *[]byte:
		b := newBytes()
		defer b.Free()

		C.gml_variant_to_string(v.ptr, b.ptr)
		*d = b.Bytes()

	default:
		b := newBytes()
		defer b.Free()

		C.gml_variant_to_string(v.ptr, b.ptr)
		data := b.String()
		if len(data) == 0 {
			return fmt.Errorf("failed to decode variant: no data to decode")
		}

		err = json.Unmarshal(data, i)
		if err != nil {
			return fmt.Errorf("failed to decode variant: %v", err)
		}
	}

	return
}
