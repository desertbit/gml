/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package main

import (
	"log"
	"os"

	"github.com/desertbit/gml"
	_ "github.com/desertbit/gml/samples/signals_slots/testy"
)

type Bridge struct {
	gml.Object
	_ struct {
		state   int                                                                            `gml:"property"`
		clicked func()                                                                         `gml:"slot"`
		greet   func(i1 uint8, i2 int32, i3 int, s string, r rune, b byte, bb bool, bs []byte) `gml:"signal"`
	}
}

func (b *Bridge) clicked() {
	b.emitGreet(1, 2, 3, "foo", '本', 4, true, []byte{1, 2, 3})
}

func main() {
	app, err := gml.NewApp()
	if err != nil {
		log.Fatalln(err)
	}

	b := &Bridge{}
	b.GMLInit()
	app.SetContextProperty("bridge", b)

	err = app.Load("qml/main.qml")
	if err != nil {
		log.Fatalln(err)
	}

	os.Exit(app.Exec())
}
