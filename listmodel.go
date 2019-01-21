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
//
// extern int gml_list_model_row_count_go_slot(void* goPtr);
// extern gml_variant gml_list_model_data_go_slot(void* goPtr, int row);
// static void gml_list_model_init() {
//      gml_list_model_cb_register(
//      	gml_list_model_row_count_go_slot,
//			gml_list_model_data_go_slot
//      );
// }
import "C"
import (
	"fmt"
	"runtime"
	"unsafe"

	"github.com/desertbit/gml/pointer"
)

func init() {
	C.gml_list_model_init()
}

type ListModelHandler interface {
	RowCount() int
	Data(row int) interface{}
}

type ListModel struct {
	*Object

	freed bool
	lm    C.gml_list_model
	ptr   unsafe.Pointer

	handler ListModelHandler
}

func NewListModel(handler ListModelHandler) *ListModel {
	lm := &ListModel{handler: handler}

	lm.ptr = pointer.Save(lm)
	lm.lm = C.gml_list_model_new(lm.ptr)
	lm.Object = newObject(unsafe.Pointer(lm.lm))

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
	C.gml_list_model_free(lm.lm)
	pointer.Unref(lm.ptr)
}

func (lm *ListModel) Reset(dataModifier func()) {
	RunMain(func() {
		// Begin the reset operation.
		C.gml_list_model_begin_reset_model()
		// Perform the data modifications.
		dataModifier()
		// End the reset operation.
		C.gml_list_model_end_reset_model()
	})
}

func (lm *ListModel) Insert(row, count int, dataModifier func()) {
	RunMain(func() {
		// Begin the insert operation.
		C.gml_list_model_begin_insert_rows(lm.lm, C.int(row), C.int(count))
		// Perform the data modification.
		dataModifier()
		// End the insert operation.
		C.gml_list_model_end_insert_rows(lm.lm)
	})
}

func (lm *ListModel) Move(row, count, dstRow int, dataModifier func()) {
	RunMain(func() {
		// Begin the move operation.
		C.gml_list_model_begin_move_rows(lm.lm, C.int(row), C.int(count), C.int(dstRow))
		// Perform the data modification.
		dataModifier()
		// End the move operation.
		C.gml_list_model_end_move_rows(lm.lm)
	})
}

func (lm *ListModel) Reload(row, count int, dataModifier func()) {
	RunMain(func() {
		// Perform the data modification.
		dataModifier()
		// Signal the changed operation.
		C.gml_list_model_rows_data_changed(lm.lm, C.int(row), C.int(count))
	})
}

func (lm *ListModel) Remove(row, count int, dataModifier func()) {
	RunMain(func() {
		// Begin the remove operation.
		C.gml_list_model_begin_remove_rows(lm.lm, C.int(row), C.int(count))
		// Perform the data modification.
		dataModifier()
		// End the remove operation.
		C.gml_list_model_end_remove_rows(lm.lm)
	})
}

//#####################//
//### Exported to C ###//
//#####################//

//export gml_list_model_row_count_go_slot
func gml_list_model_row_count_go_slot(goPtr unsafe.Pointer) C.int {
	return C.int((pointer.Restore(goPtr)).(*ListModel).handler.RowCount())
}

//export gml_list_model_data_go_slot
func gml_list_model_data_go_slot(goPtr unsafe.Pointer, row C.int) C.gml_variant {
	data := (pointer.Restore(goPtr)).(*ListModel).handler.Data(int(row))

	v := ToVariant(data)
	// Release, because C++ is handling memory.
	v.Release()

	return v.ptr
}
