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

type listModelInitializer interface {
	initListModel(handler ListModelHandler)
}

type ListModelHandler interface {
	RowCount() int
	Data(row int) interface{}
}

type ListModel struct {
	Object

	ptr     C.gml_list_model
	handler ListModelHandler
}

func InitListModel(m interface{}) {
	lmi, ok := m.(listModelInitializer)
	if !ok {
		panic(fmt.Errorf("failed to assert to list model"))
	}

	handler, ok := m.(ListModelHandler)
	if !ok {
		panic(fmt.Errorf("failed to assert to list model handler"))
	}

	lmi.initListModel(handler)
}

func (lm *ListModel) initListModel(handler ListModelHandler) {
	lm.handler = handler

	// If signals, slots or properties are defined on the model handler,
	// then use the generated C++ type by calling GmlInit...
	// Otherwise this is a standalone ListModel.
	switch ht := lm.handler.(type) {
	case objectInitializer:
		ht.GmlInit()
		lm.ptr = (C.gml_list_model)(lm.GmlObject_Pointer())

	default:
		handlerGoPtr := pointer.Save(lm.handler)
		lm.GmlObject_SetGoPointer(handlerGoPtr)

		lm.ptr = C.gml_list_model_new(handlerGoPtr)
		lm.GmlObject_SetPointer(unsafe.Pointer(lm.ptr))

		// Always cleanup.
		runtime.SetFinalizer(lm, func(lm *ListModel) {
			C.gml_list_model_free(lm.ptr)
			pointer.Unref(handlerGoPtr)
		})
	}

	// Check if something failed.
	// This should never happen. It signalizes a fatal error.
	if lm.ptr == nil {
		panic(fmt.Errorf("failed to create gml list model: C pointer is nil"))
	}
}

func (lm *ListModel) Reset(dataModifier func()) {
	RunMain(func() {
		// Begin the reset operation.
		C.gml_list_model_begin_reset_model(lm.ptr)
		// Perform the data modifications.
		dataModifier()
		// End the reset operation.
		C.gml_list_model_end_reset_model(lm.ptr)
	})
}

func (lm *ListModel) Insert(row, count int, dataModifier func()) {
	RunMain(func() {
		// Begin the insert operation.
		C.gml_list_model_begin_insert_rows(lm.ptr, C.int(row), C.int(count))
		// Perform the data modification.
		dataModifier()
		// End the insert operation.
		C.gml_list_model_end_insert_rows(lm.ptr)
	})
}

func (lm *ListModel) Move(row, count, dstRow int, dataModifier func()) {
	RunMain(func() {
		// Begin the move operation.
		C.gml_list_model_begin_move_rows(lm.ptr, C.int(row), C.int(count), C.int(dstRow))
		// Perform the data modification.
		dataModifier()
		// End the move operation.
		C.gml_list_model_end_move_rows(lm.ptr)
	})
}

func (lm *ListModel) Reload(row, count int, dataModifier func()) {
	RunMain(func() {
		// Perform the data modification.
		dataModifier()
		// Signal the changed operation.
		C.gml_list_model_rows_data_changed(lm.ptr, C.int(row), C.int(count))
	})
}

func (lm *ListModel) Remove(row, count int, dataModifier func()) {
	RunMain(func() {
		// Begin the remove operation.
		C.gml_list_model_begin_remove_rows(lm.ptr, C.int(row), C.int(count))
		// Perform the data modification.
		dataModifier()
		// End the remove operation.
		C.gml_list_model_end_remove_rows(lm.ptr)
	})
}

//#####################//
//### Exported to C ###//
//#####################//

//export gml_list_model_row_count_go_slot
func gml_list_model_row_count_go_slot(goPtr unsafe.Pointer) C.int {
	return C.int((pointer.Restore(goPtr)).(ListModelHandler).RowCount())
}

//export gml_list_model_data_go_slot
func gml_list_model_data_go_slot(goPtr unsafe.Pointer, row C.int) C.gml_variant {
	data := (pointer.Restore(goPtr)).(ListModelHandler).Data(int(row))

	v := ToVariant(data)
	// Release, because C++ is handling memory.
	v.Release()

	return v.ptr
}
