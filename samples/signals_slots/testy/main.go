/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package testy

type Bridge struct {
	_ struct {
		State     int                           `gml:"property"`
		Connect   func(addr string)             `gml:"slot"`
		Connected func(i int, s string, b bool) `gml:"signal"`
	}
}
