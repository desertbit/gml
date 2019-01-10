package main

import "C"
import (
	"github.com/desertbit/gml/internal/app"
	_ "github.com/desertbit/gml/samples"
)

func main() {}

//export GmlRun
func GmlRun() string {
	return app.Run()
}

