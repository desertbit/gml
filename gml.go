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
	"log"
	"os"
	"unsafe"
)

// Global app variable.
var gapp *app

func init() {
	// Right now there is only support for one global app.
	// This simplifies the gml API.
	var err error
	gapp, err = newApp()
	if err != nil {
		log.Fatalf("gml: failed to create global application: %v", err)
	}

	SetSearchPaths("qml", []string{":/qml"})
	SetSearchPaths("res", []string{":/resources"})
}

// Must exits the application with a fatal log if the error is present.
func Must(err error) {
	if err != nil {
		log.Fatalf("gml must: %v", err)
	}
}

// RunMain runs the function on the applications main thread.
func RunMain(f func()) {
	gapp.RunMain(f)
}

// Exec load the root QML file located at url,
// executes the application and returns the exit code.
// This method is blocking.
// Hint: Must be called within main thread.
func Exec(url string) (retCode int, err error) {
	return gapp.Exec(url)
}

// ExecExit load the root QML file located at url,
// executes the app, prints errors and exits
// the application with the specific exit code.
func ExecExit(url string) {
	ret, err := gapp.Exec(url)
	if err != nil {
		fmt.Println(err)
	}
	os.Exit(ret)
}

// Quit the application.
func Quit() {
	gapp.Quit()
}

func SetApplicationName(name string) {
	gapp.SetApplicationName(name)
}

func SetOrganizationName(name string) {
	gapp.SetOrganizationName(name)
}

func SetApplicationVersion(version string) {
	gapp.SetApplicationVersion(version)
}

func SetWindowIcon(name string) {
	gapp.SetWindowIcon(name)
}

// AddImageProvider adds the image provider to the app engine for the given id.
func AddImageProvider(id string, ip *ImageProvider) error {
	return gapp.AddImageProvider(id, ip)
}

func SetContextProperty(name string, v interface{}) error {
	return gapp.SetContextProperty(name, v)
}

func SwitchLanguage(lang string) error {
	return gapp.SwitchLanguage(lang)
}

// AddImportPath adds the given import path to the app engine.
// Hint: Must be called within main thread.
func AddImportPath(path string) {
	gapp.AddImportPath(path)
}

// SetSearchPaths sets or replaces Qt's search paths for file names with the prefix prefix to searchPaths.
// To specify a prefix for a file name, prepend the prefix followed by a single colon (e.g., "images:undo.png", "xmldocs:books.xml"). prefix can only contain letters or numbers (e.g., it cannot contain a colon, nor a slash).
// Qt uses this search path to locate files with a known prefix. The search path entries are tested in order, starting with the first entry.
func SetSearchPaths(prefix string, searchPaths []string) {
	if len(prefix) == 0 || len(searchPaths) == 0 {
		return
	}

	prefixC := C.CString(prefix)
	defer C.free(unsafe.Pointer(prefixC))

	pathsC := toCharArray(searchPaths)
	defer freeCharArray(pathsC, len(searchPaths))

	C.gml_global_set_search_paths(prefixC, pathsC, C.int(len(searchPaths)))
}

// SetIconThemeName sets the current icon theme to name.
func SetIconThemeName(name string) {
	nameC := C.CString(name)
	defer C.free(unsafe.Pointer(nameC))

	C.gml_global_set_icon_theme_name(nameC)
}

// SetIconThemeSearchPaths sets the search paths for icon themes to paths.
func SetIconThemeSearchPaths(searchPaths ...string) {
	if len(searchPaths) == 0 {
		return
	}

	pathsC := toCharArray(searchPaths)
	defer freeCharArray(pathsC, len(searchPaths))

	C.gml_global_set_icon_theme_search_paths(pathsC, C.int(len(searchPaths)))
}

/*
func ExecDev(basePath, url string) (retCode int, err error) {
	AddImportPath(basePath)

	w := watcher.New()
	w.SetMaxEvents(1)

	go func() {
		for {
			select {
			case event := <-w.Event:
				RunMain(func() {
					fmt.Println(event) // Print the event's info. TODO: log
					gapp.ClearComponentCache()
				})

			case err := <-w.Error:
				log.Println("dev file watcher error: %v", err)

			case <-w.Closed:
				return
			}
		}
	}()

	err = w.AddRecursive(filepath.Join(basePath, "qml"))
	if err != nil {
		return
	}

	go func() {
		err := w.Start(time.Millisecond * 250)
		if err != nil {
			log.Println("dev file watcher failed: %v", err)
		}
	}()

	return Exec(url)
}

func ExecDevExit(basePath, url string) {
	ret, err := ExecDev(basePath, url)
	if err != nil {
		fmt.Println(err)
	}
	os.Exit(ret)
}
*/
