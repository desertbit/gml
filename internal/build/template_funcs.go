/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package build

import "text/template"

var tmplFuncMap = template.FuncMap{
	"goParams":    tmplFuncGoParams,
	"cParams":     tmplFuncCParams,
	"goToCParams": tmplFuncGoToCParams,
}

func tmplFuncGoParams(params []*genParam, withType, skipFirstComma bool, optPrefix ...string) (s string) {
	var prefix string
	if len(optPrefix) > 0 {
		prefix = optPrefix[0]
	}

	for i, p := range params {
		if !skipFirstComma || i != 0 {
			s += ", "
		}
		s += prefix + p.Name
		if withType {
			s += " " + p.Type
		}
	}
	return
}

func tmplFuncCParams(params []*genParam, withType, skipFirstComma bool) (s string) {
	for i, p := range params {
		if !skipFirstComma || i != 0 {
			s += ", "
		}
		if withType {
			s += p.CType + " "
		}
		s += p.Name
	}
	return
}

func tmplFuncGoToCParams(params []*genParam, prefix string, optsIndent ...int) (s string) {
	var ident string
	if len(optsIndent) > 0 {
		for i := 0; i < optsIndent[0]; i++ {
			ident += " "
		}
	}

	addLine := func(l string) {
		s += "\n" + ident + l
	}

	// TODO: add all missing.
	for _, p := range params {
		switch p.Type {
		case "int":
			addLine(prefix + p.Name + " := C.int(" + p.Name + ")")
		case "bool":
			addLine(prefix + p.Name + " := C.int(" + p.Name + ")")
		case "string":
			return "*char" // TODO:
		default:
			return "gml_variant" // TODO:
		}
	}

	return
}
