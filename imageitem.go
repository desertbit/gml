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
// extern void gml_image_item_request_go_slot(char* id, gml_image img);
// static void gml_image_item_init() {
//      gml_image_item_request_cb_register(gml_image_item_request_go_slot);
// }
import "C"
import (
	"log"
	"sync"
	"unsafe"
)

var (
	imageItemsMutex sync.Mutex
	imageItems      = make(map[string]*ImageItem)
)

func init() {
	C.gml_image_item_init()
}

//#################//
//### ImageItem ###//
//#################//

type ImageItem struct {
	id  string
	idC *C.char

	mutex    sync.Mutex
	released bool
	img      *Image
}

func NewImageItem(id string) (i *ImageItem) {
	i = &ImageItem{
		id:  id,
		idC: C.CString(id),
		img: NewImage(),
	}

	old := setImageItem(id, i)
	if old != nil {
		old.release(true)
	}

	// Hint: Does not need a finalizer, because it is always in the map
	//       and Release must be called.
	return
}

// SetImage sets the image by doing a shallow copy.
func (i *ImageItem) SetImage(img *Image) {
	i.mutex.Lock()
	i.img.SetTo(img)
	i.mutex.Unlock()

	// Notify the change to QML.
	// Don't need RunMain, because this emits only a signal.
	C.gml_image_item_emit_changed(i.idC)
}

func (i *ImageItem) ResetImage() {
	i.mutex.Lock()
	i.img.Reset()
	i.mutex.Unlock()

	// Notify the change to QML.
	// Don't need RunMain, because this emits only a signal.
	C.gml_image_item_emit_changed(i.idC)
}

// Release this image item.
// Don't use it anymore after this call, because memory is freed.
func (i *ImageItem) Release() {
	i.release(false)
}

func (i *ImageItem) release(skipMapDelete bool) {
	i.mutex.Lock()
	defer i.mutex.Unlock()

	if i.released {
		return
	}
	i.released = true

	if !skipMapDelete {
		deleteImageItem(i.id)
	}

	C.free(unsafe.Pointer(i.idC))
	i.img.Free()
}

//######################//
//### Image Item Map ###//
//######################//

func getImageItem(id string) (i *ImageItem) {
	imageItemsMutex.Lock()
	i = imageItems[id]
	imageItemsMutex.Unlock()
	return
}

func setImageItem(id string, i *ImageItem) (old *ImageItem) {
	imageItemsMutex.Lock()
	old = imageItems[id]
	imageItems[id] = i
	imageItemsMutex.Unlock()
	return
}

func deleteImageItem(id string) {
	imageItemsMutex.Lock()
	delete(imageItems, id)
	imageItemsMutex.Unlock()
}

//#####################//
//### Exported to C ###//
//#####################//

//export gml_image_item_request_go_slot
func gml_image_item_request_go_slot(
	idC *C.char,
	imgC C.gml_image,
) {
	id := C.GoString(idC)
	img := newImage(imgC, false) // Don't free the image. We are not the owner of the pointer.

	i := getImageItem(id)
	if i == nil {
		log.Println("gml: image item not registered for source ID:", id)
		return
	}

	i.mutex.Lock()
	img.SetTo(i.img)
	i.mutex.Unlock()
}
