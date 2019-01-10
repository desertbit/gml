package main

import (
	"log"
	"os"

	"github.com/desertbit/gml"
)

type A struct {
}

type Bridge struct {
	_ struct {
		State     int                `gml:"property"`
		Connect   func(addr string)  `gml:"slot"`
		Connected func(foo int, a A) `gml:"signal"`
	}

	i int
}

func (b *Bridge) Connect(addr string) {

}

func main() {
	app, err := gml.NewApp()
	if err != nil {
		log.Fatalln(err)
	}

	err = app.Load("qml/main.qml")
	if err != nil {
		log.Fatalln(err)
	}

	os.Exit(app.Exec())
}
