/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package utils

import (
	"fmt"

	"github.com/fatih/color"
)

var (
	Verbose bool
)

func PrintColor(s string) {
	color.Set(color.FgHiGreen)
	fmt.Print(s)
	color.Unset()
}

func PrintColorln(s string) {
	PrintColor(s + "\n")
}
