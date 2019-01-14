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
	"io/ioutil"
	"log"
	"os"

	"github.com/desertbit/gml"
	_ "github.com/desertbit/gml/samples/signals_slots/testy"
)

type Bridge struct {
	gml.Object
	_ struct {
		//state   int                                                                            `gml:"property"`
		clicked func(i int, v *gml.Variant)                                                    `gml:"slot"`
		greet   func(i1 uint8, i2 int32, i3 int, s string, r rune, b byte, bb bool, bs []byte) `gml:"signal"`
	}
}

func (b *Bridge) clicked(i int, v *gml.Variant) {
	b.emitGreet(1, 2, 3, "foo", '本', 4, true, []byte{1, 2, 3})
}

func main() {
	app, err := gml.NewApp()
	if err != nil {
		log.Fatalln(err)
	}

	b := &Bridge{}
	b.GMLInit()
	err = app.SetContextProperty("bridge", b)
	if err != nil {
		log.Fatalln(err)
	}

	err = app.AddImageProvider(
		"imgprov",
		gml.NewImageProvider(
			gml.KeepAspectRatio,
			gml.FastTransformation,
			func(id string, img *gml.Image) error {
				data, _ := ioutil.ReadFile("/tmp/a.png")
				return img.LoadFromData(data)
			},
		),
	)
	if err != nil {
		log.Fatalln(err)
	}

	err = app.Load("qrc:/qml/main.qml")
	if err != nil {
		log.Fatalln(err)
	}

	os.Exit(app.Exec())
}
