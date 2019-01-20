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
// extern void gml_image_item_request_go_slot(char* src, gml_image img);
// static void gml_image_item_init() {
//      gml_image_item_request_cb_register(gml_image_item_request_go_slot);
// }
import "C"
import (
	"log"
	"sync"
)

var (
	imageItemsMutex sync.Mutex
	imageItems      = make(map[string]*ImageItem)
)

func init() {
	C.gml_image_item_init()
}

type ImageItem struct {
	id       string
	released bool
	callback func(img *Image)
}

// Don't block the callback. This will block the main ui thread.
func NewImageItem(id string, callback func(img *Image)) (i *ImageItem) {
	i = &ImageItem{
		id:       id,
		callback: callback,
	}

	imageItemsMutex.Lock()
	if old, ok := imageItems[id]; ok {
		old.released = true
	}
	imageItems[id] = i
	imageItemsMutex.Unlock()

	return
}

func (i *ImageItem) Release() {
	imageItemsMutex.Lock()
	defer imageItemsMutex.Unlock()

	if i.released {
		return
	}
	i.released = true

	delete(imageItems, i.id)
}

//#####################//
//### Exported to C ###//
//#####################//

//export gml_image_item_request_go_slot
func gml_image_item_request_go_slot(
	srcC *C.char,
	imgC C.gml_image,
) {
	id := C.GoString(srcC)
	img := newImage(imgC, false) // Don't free the image. We are not the owner of the pointer.

	var i *ImageItem
	imageItemsMutex.Lock()
	i = imageItems[id]
	imageItemsMutex.Unlock()

	if i == nil {
		log.Println("gml: image item not registered for source ID:", id)
		return
	}

	i.callback(img)
}
