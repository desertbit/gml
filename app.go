/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
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

func (a *App) SetRootContextProperty(name string, v interface{}) (err error) {
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
