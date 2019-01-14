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

// Package pointer is based on: https://github.com/desertbit/go-pointer
package pointer

// #include <stdlib.h>
import "C"
import (
	"sync"
	"unsafe"
)

var (
	mutex sync.Mutex
	store = map[unsafe.Pointer]interface{}{}
)

func Save(v interface{}) unsafe.Pointer {
	if v == nil {
		return nil
	}

	// Generate real fake C pointer.
	// This pointer will not store any data, but will bi used for indexing purposes.
	// Since Go doest allow to cast dangling pointer to unsafe.Pointer, we do rally allocate one byte.
	// Why we need indexing, because Go doest allow C code to store pointers to Go data.
	ptr := C.malloc(C.size_t(1))
	if ptr == nil {
		panic("can't allocate 'cgo-pointer hack index pointer': ptr == nil")
	}

	mutex.Lock()
	store[ptr] = v
	mutex.Unlock()

	return ptr
}

func Restore(ptr unsafe.Pointer) (v interface{}) {
	if ptr == nil {
		return nil
	}

	mutex.Lock()
	v = store[ptr]
	mutex.Unlock()
	return
}

func Unref(ptr unsafe.Pointer) {
	if ptr == nil {
		return
	}

	mutex.Lock()
	delete(store, ptr)
	mutex.Unlock()

	C.free(ptr)
}
