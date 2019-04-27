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

// #cgo pkg-config: Qt5Core Qt5Qml Qt5Quick
// #cgo CFLAGS: -I${SRCDIR}/internal/binding/headers
// #cgo LDFLAGS: -lstdc++
// #include <gml.h>
import "C"
import (
	"fmt"
	"log"
	"os"
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

// AddImageProvider adds the image provider to the app engine for the given id.
func AddImageProvider(id string, ip *ImageProvider) error {
	return gapp.AddImageProvider(id, ip)
}

func SetContextProperty(name string, v interface{}) (err error) {
	return gapp.SetContextProperty(name, v)
}

// AddImportPath adds the given import path to the app engine.
// Hint: Must be called within main thread.
func AddImportPath(path string) {
	gapp.AddImportPath(path)
}
