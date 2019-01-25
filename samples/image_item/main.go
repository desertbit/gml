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

package main

import (
	"time"

	"github.com/desertbit/gml"
)

func main() {
	// Load image 1.
	imgCage1 := gml.NewImage()
	gml.Must(imgCage1.LoadFromFile("./cage1.jpg"))
	defer imgCage1.Free()

	// Load image 2.
	imgCage2 := gml.NewImage()
	gml.Must(imgCage2.LoadFromFile("./cage2.jpg"))
	defer imgCage2.Free()

	// Create the image item and set to image 1.
	item := gml.NewImageItem("cage")
	item.SetImage(imgCage1)

	// Change after a short timeout.
	go func() {
		time.Sleep(2 * time.Second)
		item.SetImage(imgCage2)
	}()

	gml.ExecExit("qrc:/qml/app.qml")
}
