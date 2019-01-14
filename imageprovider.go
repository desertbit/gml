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
// extern void gml_imageprovider_request_go_slot(void* goPtr, char* id, gml_image img);
// static void gml_imageprovider_init() {
//      gml_imageprovider_request_cb_register(gml_imageprovider_request_go_slot);
// }
import "C"
import (
	"fmt"
	"runtime"
	"unsafe"

	"github.com/desertbit/gml/pointer"
)

func init() {
	C.gml_imageprovider_init()
}

type ImageProviderCallback func(id string, img *Image) error

type ImageProvider struct {
	freed bool
	ip    C.gml_imageprovider
	ptr   unsafe.Pointer

	callback ImageProviderCallback
}

func NewImageProvider(callback ImageProviderCallback) *ImageProvider {
	ip := &ImageProvider{
		callback: callback,
	}
	ip.ptr = pointer.Save(ip)
	ip.ip = C.gml_imageprovider_new(ip.ptr)

	// Always free the C++ value.
	runtime.SetFinalizer(ip, freeImageProvider)

	// Check if something failed.
	// This should never happen is signalizes a fatal error.
	if ip.ip == nil {
		panic(fmt.Errorf("failed to create gml imageprovider: C pointer is nil"))
	}

	return ip
}

func freeImageProvider(ip *ImageProvider) {
	if ip.freed {
		return
	}
	ip.freed = true
	C.gml_imageprovider_free(ip.ip)
	pointer.Unref(ip.ptr)
}

func (ip *ImageProvider) Free() {
	freeImageProvider(ip)
}

//#####################//
//### Exported to C ###//
//#####################//

//export gml_imageprovider_request_go_slot
func gml_imageprovider_request_go_slot(goPtr unsafe.Pointer, idc *C.char, imgC C.gml_image) {
	ip := (pointer.Restore(goPtr)).(*ImageProvider)
	id := C.GoString(idc)
	img := newImage(imgC, false) // Don't free the image. We are not the owner of the pointer.

	// Run in a new goroutine.
	go func() {
		gerr := ip.callback(id, img)
		_ = gerr // TODO:
	}()
}
