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
		state     int    `gml:"property"`
		hello     func() `gml:"slot"`
		Connected func() `gml:"signal"`
		//sign      func(i int, s string, b bool) `gml:"signal"`
	}
}

func (b *Bridge) hello() {
	println("hello")
	b.EmitConnected()
}

func main() {
	app, err := gml.NewApp()
	if err != nil {
		log.Fatalln(err)
	}

	b := &Bridge{}
	b.GMLInit()
	app.SetRootContextProperty("bridge", b)

	/*go func() {
		time.Sleep(time.Second)
		b.EmitConnected()
	}()*/

	err = app.Load("qml/main.qml")
	if err != nil {
		log.Fatalln(err)
	}

	os.Exit(app.Exec())
}
