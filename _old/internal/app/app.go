package app

import (
	"github.com/desertbit/closer"
)

var (
	close = closer.New()
)

func Run() string {
	<-close.CloseChan()
	return ""
}

func Exit() {
	close.Close()
}
