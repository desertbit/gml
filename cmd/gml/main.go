/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package main

import (
	"fmt"
	"os"

	"github.com/desertbit/gml/internal/print"
	"github.com/desertbit/grumble"
)

var App = grumble.New(&grumble.Config{
	Name:        "gml",
	Description: "go qml tool",

	Flags: func(f *grumble.Flags) {
		f.Bool("v", "verbose", false, "verbose mode")
		f.BoolL("no-color", false, "disable color output")
	},
})

func init() {
	App.OnInit(func(a *grumble.App, f grumble.FlagMap) error {
		print.SetNoColor(f.Bool("no-color"))

		if f.Bool("verbose") {
			// TODO:
		}
		return nil
	})
}

func main() {
	err := App.Run()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
