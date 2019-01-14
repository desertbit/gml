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
// extern void gml_app_run_main_go_slot(void* goPtr);
// static void gml_app_init() {
//      gml_app_run_main_cb_register(gml_app_run_main_go_slot);
// }
import "C"
import (
	"errors"
	"os"
	"runtime"
	"unsafe"

	"github.com/desertbit/gml/internal/utils"
	"github.com/desertbit/gml/pointer"
)

func init() {
	// Ensure the thread is locked for init functions and main.
	runtime.LockOSThread()

	C.gml_app_init()
}

// TODO: free
type App struct {
	threadID int

	app  C.gml_app
	argc int
	argv **C.char // TODO: free

	gcMap map[string]interface{}
}

func NewApp() (a *App, err error) {
	// Only pass the executable name.
	args := os.Args
	if len(args) > 1 {
		args = args[:1]
	}
	return NewAppWithArgs(args)
}

func NewAppWithArgs(args []string) (a *App, err error) {
	// Ensure the thread is locked within this context of app creation.
	runtime.LockOSThread()

	a = &App{
		threadID: utils.GetThreadID(),
		argc:     len(args),
		argv:     toCharArray(args),
		gcMap:    make(map[string]interface{}),
	}
	a.app = C.gml_app_new(C.int(a.argc), a.argv)
	return
}

// RunMain runs the function on the applications main thread.
func (a *App) RunMain(f func()) {
	// Check if already running on the main thread.
	if utils.GetThreadID() == a.threadID {
		f()
		return
	}

	doneChan := make(chan struct{})
	cb := func() {
		f()
		close(doneChan)
	}

	ptr := pointer.Save(cb)
	defer pointer.Unref(ptr)

	// TODO:
	_ = C.gml_app_run_main(a.app, ptr)
	/*if error {
		return
	}*/

	<-doneChan
}

// Load the root QML file located at url.
// Hint: Must be called within main thread.
func (a *App) Load(url string) error {
	urlC := C.CString(url)
	defer C.free(unsafe.Pointer(urlC))

	// TODO:
	_ = int(C.gml_app_load(a.app, urlC))
	return nil
}

// Load the QML given in data.
// Hint: Must be called within main thread.
func (a *App) LoadData(data string) error {
	dataC := C.CString(data)
	defer C.free(unsafe.Pointer(dataC))

	// TODO:
	_ = int(C.gml_app_load_data(a.app, dataC))
	return nil
}

func (a *App) AddImportPath(path string) error {
	pathC := C.CString(path)
	defer C.free(unsafe.Pointer(pathC))

	// TODO:
	_ = int(C.gml_app_add_import_path(a.app, pathC))
	return nil
}

// Exec executes the application and returns the exit code.
// This method is blocking.
// Hint: Must be called within main thread.
func (a *App) Exec() int {
	return int(C.gml_app_exec(a.app))
}

// Quit the application.
func (a *App) Quit() (retCode int) {
	a.RunMain(func() {
		retCode = int(C.gml_app_quit(a.app))
	})
	return
}

func (a *App) SetContextProperty(name string, v interface{}) (err error) {
	if len(name) == 0 {
		return errors.New("property name is empty")
	}

	// Try to obtain the object from the interface.
	obj, err := toObject(v)
	if err != nil {
		return
	}

	nameC := C.CString(name)
	defer C.free(unsafe.Pointer(nameC))

	a.RunMain(func() {
		// TODO:
		_ = int(C.gml_app_set_root_context_property(a.app, nameC, obj.cObject()))
	})

	// Add to map to ensure it gets not garbage collected.
	// It is in use by the C++ context;
	a.gcMap[name] = v

	return nil
}

//#####################//
//### Exported to C ###//
//#####################//

//export gml_app_run_main_go_slot
func gml_app_run_main_go_slot(goPtr unsafe.Pointer) {
	f := (pointer.Restore(goPtr)).(func())
	f()
}
