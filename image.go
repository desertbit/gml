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
	"errors"
	"fmt"
	"image"
	"image/draw"
	"runtime"
	"unsafe"
)

type Image struct {
	freed bool
	img   C.gml_image
}

func NewImage() (img *Image) {
	return newImage(C.gml_image_new(), true)
}

func newImage(imgC C.gml_image, free bool) (img *Image) {
	// Check if something failed.
	// This should never happen is signalizes a fatal error.
	if imgC == nil {
		panic(fmt.Errorf("gml image: C pointer is nil"))
	}

	img = &Image{
		freed: !free,
		img:   imgC,
	}

	// Always free the C++ value if defined so.
	if free {
		runtime.SetFinalizer(img, freeImage)
	}

	return
}

func freeImage(img *Image) {
	if img.freed {
		return
	}
	img.freed = true
	C.gml_image_free(img.img)
}

func (img *Image) Free() {
	freeImage(img)
}

// Reset the image to an empty image.
func (img *Image) Reset() {
	C.gml_image_reset(img.img)

	// Prevent the GC from freeing. Go issue 13347
	runtime.KeepAlive(img)
}

// SetTo performs a shallow copy.
func (img *Image) SetTo(other *Image) {
	C.gml_image_set_to(img.img, other.img)

	// Prevent the GC from freeing. Go issue 13347
	runtime.KeepAlive(img)
	runtime.KeepAlive(other)
}

func (img *Image) LoadFromGoImage(gimg image.Image) error {
	b := gimg.Bounds()

	// Get the RGBA image if present.
	// Otherwise convert to RGBA.
	imgRGBA, ok := gimg.(*image.RGBA)
	if !ok {
		imgRGBA = image.NewRGBA(b)
		draw.Draw(imgRGBA, b, gimg, b.Min, draw.Src)
	}

	// Ensure the image is not empty.
	if len(imgRGBA.Pix) == 0 {
		return errors.New("empty rgba image")
	}

	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	ret := C.gml_image_load_from_rgba(
		img.img,
		(*C.char)(unsafe.Pointer(&imgRGBA.Pix[0])),
		C.int(len(imgRGBA.Pix)),
		C.int(b.Dx()),
		C.int(b.Dy()),
		C.int(imgRGBA.Stride),
		apiErr.err,
	)
	if ret != 0 {
		return apiErr.Err("failed to load from data")
	}

	// Prevent the GC from freeing. Go issue 13347
	runtime.KeepAlive(img)
	runtime.KeepAlive(gimg)

	return nil
}

func (img *Image) LoadFromFile(filename string) error {
	if len(filename) == 0 {
		return fmt.Errorf("empty filename")
	}

	filenameC := C.CString(filename)
	defer C.free(unsafe.Pointer(filenameC))

	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	ret := C.gml_image_load_from_file(img.img, filenameC, apiErr.err)
	if ret != 0 {
		return apiErr.Err("failed to load from file")
	}

	// Prevent the GC from freeing. Go issue 13347
	runtime.KeepAlive(img)

	return nil
}

func (img *Image) LoadFromData(data []byte) error {
	if len(data) == 0 {
		return fmt.Errorf("empty data")
	}

	apiErr := errorPool.Get()
	defer errorPool.Put(apiErr)

	ret := C.gml_image_load_from_data(img.img, (*C.char)(unsafe.Pointer(&data[0])), C.int(len(data)), apiErr.err)
	if ret != 0 {
		return apiErr.Err("failed to load from data")
	}

	// Prevent the GC from freeing. Go issue 13347
	runtime.KeepAlive(img)
	runtime.KeepAlive(data)

	return nil
}
