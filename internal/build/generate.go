/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package build

import "fmt"

// TODO: make concurrent with multiple goroutines.
func generate(ctx *Context) (err error) {
	gt, err := parseDirRecursive(ctx.SourceDir)
	if err != nil {
		return
	}

	for _, s := range gt.Signals {
		fmt.Println("signal", s.Name, s.Filename)
		for i, p := range s.Params {
			fmt.Println(i, p.Name, p.Type)
		}
	}

	return
}
