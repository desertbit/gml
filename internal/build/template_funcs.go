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
	"cppParams":   tmplFuncCPPParams,
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

func tmplFuncCPPParams(params []*genParam, withType, skipFirstComma bool) (s string) {
	for i, p := range params {
		if !skipFirstComma || i != 0 {
			s += ", "
		}
		if withType {
			s += p.CPPType + " "
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

	for _, p := range params {
		cName := prefix + p.Name

		switch p.Type {
		case "bool":
			addLine(cName + " := C.uint8_t(" + p.Name + ")")

		case "byte":
			addLine(cName + " := C.char(" + p.Name + ")")
		case "[]byte":
			addLine(cName + " := (*C.char)(unsafe.Pointer(&" + p.Name + "[0]))")

		case "string":
			addLine(cName + " := C.CString(" + p.Name + ")")
			addLine("defer C.free(unsafe.Pointer(" + cName + "))")
		case "rune":
			addLine(cName + " := C.int32_t(" + p.Name + ")")

		case "float32":
			addLine(cName + " := C.float(" + p.Name + ")")
		case "float64":
			addLine(cName + " := C.double(" + p.Name + ")")

		case "int":
			addLine(cName + " := C.int(" + p.Name + ")")
		case "int8":
			addLine(cName + " := C.int8_t(" + p.Name + ")")
		case "uint8":
			addLine(cName + " := C.uint8_t(" + p.Name + ")")
		case "int16":
			addLine(cName + " := C.int16_t(" + p.Name + ")")
		case "uint16":
			addLine(cName + " := C.uint16_t(" + p.Name + ")")
		case "int32":
			addLine(cName + " := C.int32_t(" + p.Name + ")")
		case "uint32":
			addLine(cName + " := C.uint32_t(" + p.Name + ")")
		case "int64":
			addLine(cName + " := C.int64_t(" + p.Name + ")")
		case "uint64":
			addLine(cName + " := C.uint64_t(" + p.Name + ")")

		default:
			// TODO:
			addLine("gml_variant")
		}
	}
	return
}
