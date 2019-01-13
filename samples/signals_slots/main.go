/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package main

import (
	"fmt"
	"log"
	"os"
	"syscall"
	"time"

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
	fmt.Println(syscall.Gettid()) // TODO:
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

	go func() {
		time.Sleep(time.Second)
		b.EmitConnected()
		fmt.Println(syscall.Gettid()) // TODO:

		app.RunMain(func() {
			fmt.Println(syscall.Gettid())
		})
	}()

	err = app.Load("qml/main.qml")
	if err != nil {
		log.Fatalln(err)
	}

	fmt.Println(syscall.Gettid()) // TODO:

	os.Exit(app.Exec())
}
