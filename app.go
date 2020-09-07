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
	"fmt"
	"os"
	"runtime"
	"sync"
	"unsafe"

	"github.com/desertbit/gml/internal/utils"
	"github.com/desertbit/gml/pointer"
)

func init() {
	// Ensure the thread is locked for init functions and main.
	runtime.LockOSThread()

	C.gml_app_init()
}

type app struct {
	freed    bool
	threadID int

	app  C.gml_app
	argc int
	argv **C.char

	mutex      sync.Mutex
	ctxPropMap map[string]interface{}
	imgProvMap map[string]*ImageProvider
}

func newApp() (a *app, err error) {
	// Only pass the executable name.
	args := os.Args
	if len(args) > 1 {
		args = args[:1]
	}
	return newAppWithArgs(args)
}

func newAppWithArgs(args []string) (a *app, err error) {
	// Ensure the thread is locked within this context of app creation.
	runtime.LockOSThread()

	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	a = &app{
		threadID:   utils.GetThreadID(),
		argc:       len(args),
		argv:       toCharArray(args),
		ctxPropMap: make(map[string]interface{}),
		imgProvMap: make(map[string]*ImageProvider),
	}

	a.app = C.gml_app_new(C.int(a.argc), a.argv, apiErr.err)
	if a.app == nil {
		err = apiErr.Err("failed to create new app")
		return
	}

	// Get the density independent pixels and set them as context property.
	dp, err := a.getDp()
	if err != nil {
		return
	}
	err = a.SetContextProperty("dp", dp)
	if err != nil {
		return
	}

	return
}

func (a *app) getDp() (dp float64, err error) {
	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	dp = float64(C.gml_app_get_dp(a.app, apiErr.err))
	if dp == -1 {
		err = apiErr.Err("failed to get dp")
	}

	// Magic.
	dp /= 140.0
	return
}

// RunMain runs the function on the applications main thread.
func (a *app) RunMain(f func()) {
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

	ret := C.gml_app_run_main(a.app, ptr)
	if ret != 0 {
		// This is fatal!
		panic(fmt.Errorf("failed to run on main thread"))
		return
	}

	<-doneChan
}

// Load the root QML file located at url.
// Hint: Must be called within main thread.
func (a *app) Load(url string) error {
	urlC := C.CString(url)
	defer C.free(unsafe.Pointer(urlC))

	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	ret := C.gml_app_load(a.app, urlC, apiErr.err)
	if ret != 0 {
		return apiErr.Err("failed to load url")
	}
	return nil
}

// TODO: Remove? Currently not used.
// LoadData loads the QML given in data.
// Hint: Must be called within main thread.
func (a *app) LoadData(data string) error {
	dataC := C.CString(data)
	defer C.free(unsafe.Pointer(dataC))

	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	ret := C.gml_app_load_data(a.app, dataC, apiErr.err)
	if ret != 0 {
		return apiErr.Err("failed to load data")
	}
	return nil
}

// AddImportPath adds the given import path to the app engine.
// Hint: Must be called within main thread.
func (a *app) AddImportPath(path string) {
	pathC := C.CString(path)
	defer C.free(unsafe.Pointer(pathC))

	C.gml_app_add_import_path(a.app, pathC)
}

// AddImageProvider adds the image provider to the app engine for the given id.
func (a *app) AddImageProvider(id string, ip *ImageProvider) error {
	idC := C.CString(id)
	defer C.free(unsafe.Pointer(idC))

	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	var ret C.int
	a.RunMain(func() {
		ret = C.gml_app_add_imageprovider(a.app, idC, ip.ptr, apiErr.err)
	})
	if ret != 0 {
		return apiErr.Err("failed to add image provider")
	}

	// Add to map to ensure it gets not garbage collected.
	// It is in use by the C++ context;
	a.mutex.Lock()
	a.imgProvMap[id] = ip
	a.mutex.Unlock()

	return nil
}

// Exec loads the root QML file located at url,
// executes the application and returns the exit code.
// This method is blocking.
// Hint: Must be called within main thread.
func (a *app) Exec(url string) (retCode int, err error) {
	// Load the main qml.
	err = a.Load(url)
	if err != nil {
		return
	}

	// Execute the app.
	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	retCode = int(C.gml_app_exec(a.app, apiErr.err))
	if retCode != 0 {
		err = apiErr.Err("app execution failed")
		return
	}
	return
}

// Quit the application.
func (a *app) Quit() {
	a.RunMain(func() {
		C.gml_app_quit(a.app)
	})
}

func (a *app) SetContextProperty(name string, v interface{}) (err error) {
	if len(name) == 0 {
		return errors.New("property name is empty")
	}

	nameC := C.CString(name)
	defer C.free(unsafe.Pointer(nameC))

	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	var ret C.int

	// Try to obtain the object from the interface.
	obj, err := toObject(v)
	if err == nil {
		a.RunMain(func() {
			ret = C.gml_app_set_root_context_property_object(a.app, nameC, obj.cObject(), apiErr.err)
		})
		if ret != 0 {
			return apiErr.Err("failed to set context property object")
		}

		// Add to map to ensure it gets not garbage collected.
		// It is in use by the C++ context;
		a.mutex.Lock()
		a.ctxPropMap[name] = v
		a.mutex.Unlock()

		return
	}

	// Obtain a variant from the interface.
	variant := ToVariant(v)
	defer variant.Free()

	a.RunMain(func() {
		ret = C.gml_app_set_root_context_property_variant(a.app, nameC, variant.ptr, apiErr.err)
	})
	if ret != 0 {
		return apiErr.Err("failed to set context property variant")
	}

	// It is not necessary to add the variant to the context property map.
	// C++ has made a copy of our variant, therefore we can safely garbage
	// collect it on the Go side.

	return nil
}

func (a *app) SetApplicationName(name string) {
	nameC := C.CString(name)
	defer C.free(unsafe.Pointer(nameC))

	a.RunMain(func() {
		C.gml_app_set_application_name(a.app, nameC)
	})
}

func (a *app) SetOrganizationName(name string) {
	nameC := C.CString(name)
	defer C.free(unsafe.Pointer(nameC))

	a.RunMain(func() {
		C.gml_app_set_organization_name(a.app, nameC)
	})
}

func (a *app) SetApplicationVersion(version string) {
	versionC := C.CString(version)
	defer C.free(unsafe.Pointer(versionC))

	a.RunMain(func() {
		C.gml_app_set_application_version(a.app, versionC)
	})
}

type WindowState int

const (
	WindowNoState WindowState = 0
	WindowMinimized WindowState = 1
	WindowMaximized WindowState = 2
	WindowFullscreen WindowState = 4
	WindowActive WindowState = 8
)

func (a *app) SetTopLevelWindowState(ws WindowState) (err error) {
	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	var ret C.int
	a.RunMain(func() {
		ret = C.gml_set_top_level_window_state(C.int(ws), apiErr.err)
		if ret < 0 {
			err = apiErr.Err("failed to set top-level window visibility")
			return
		}
	})

	return
}

//#####################//
//### Exported to C ###//
//#####################//

//export gml_app_run_main_go_slot
func gml_app_run_main_go_slot(goPtr unsafe.Pointer) {
	f := (pointer.Restore(goPtr)).(func())
	f()
}
