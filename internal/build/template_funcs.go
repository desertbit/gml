/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package build

import "text/template"

var tmplFuncMap = template.FuncMap{
	"goParams": tmplFuncGoParams,
	"cParams":  tmplFuncCParams,
}

func tmplFuncGoParams(params []*genParam, skipFirst bool) (s string) {
	for i, p := range params {
		if !skipFirst || i != 0 {
			s += ", "
		}
		s += p.Name + " " + p.Type
	}
	return
}

func tmplFuncCParams(params []*genParam, skipFirst bool) (s string) {
	for i, p := range params {
		if !skipFirst || i != 0 {
			s += ", "
		}
		s += p.Type + " " + p.Name
	}
	return
}
