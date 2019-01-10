/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package print

import (
	"fmt"

	"github.com/fatih/color"
)

func SetNoColor(b bool) {
	color.NoColor = b
}

func PrintColor(s string) {
	color.Set(color.FgHiGreen)
	fmt.Print(s)
	color.Unset()
}

func printColorln(s string) {
	PrintColor(s + "\n")
}
