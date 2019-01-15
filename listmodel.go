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

	"github.com/desertbit/gml/pointer"
)

type ListModelHandler interface {
}

type ListModel struct {
	freed bool
	lm    C.gml_list_model
	ptr   unsafe.Pointer
}

func NewListModel() *ListModel {
	lm := &ListModel{}

	lm.ptr = pointer.Save(lm)
	//lm.lm = C.gml_imageprovider_new(lm.ptr)

	// Always free the C++ value.
	runtime.SetFinalizer(lm, freeListModel)

	// Check if something failed.
	// This should never happen is signalizes a fatal error.
	if lm.lm == nil {
		panic(fmt.Errorf("failed to create gml list model: C pointer is nil"))
	}

	return lm
}

func (lm *ListModel) Free() {
	freeListModel(lm)
}

func freeListModel(lm *ListModel) {
	if lm.freed {
		return
	}
	lm.freed = true
	//C.gml_imageprovider_free(lm.lm)
	pointer.Unref(lm.ptr)
}
