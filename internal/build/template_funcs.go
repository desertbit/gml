/*
 * GML - Go QML
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 Roland Singer <roland.singer[at]desertbit.com>
 * Copyright (c) 2019 Sebastian Borchers <sebastian[at]desertbit.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package build

import "text/template"

var tmplFuncMap = template.FuncMap{
	"goParams":  tmplFuncGoParams,
	"goCParams": tmplFuncGoCParams,
	"cParams":   tmplFuncCParams,
	"cppParams": tmplFuncCPPParams,

	"goToCParams":  tmplFuncGoToCParams,
	"cToGoParams":  tmplFuncCToGoParams,
	"cToCPPParams": tmplFuncCToCPPParams,
	"cppToCParams": tmplFuncCPPToCParams,

	"cToCPPValue": tmplFuncCToCPPValue,
	"cppToCValue": tmplFuncCPPToCValue,
	"goToCValue":  tmplFuncGoToCValue,
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

func tmplFuncGoCParams(params []*genParam, withType, skipFirstComma bool, optPrefix ...string) (s string) {
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
			s += " " + p.CGoType
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
	for _, p := range params {
		s += tmplFuncGoToCValue(p.Type, p.Name, prefix+p.Name, optsIndent...)
	}
	return
}

func tmplFuncCToGoParams(params []*genParam, prefix string, optsIndent ...int) (s string) {
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
		goName := prefix + p.Name

		switch p.Type {
		case "bool":
			addLine("var " + goName + " bool")
			addLine("if " + p.Name + " != 0 { " + goName + " = true }")
		case "byte":
			addLine(goName + " := byte(" + p.Name + ")")
		case "string":
			addLine(goName + " := C.GoString(" + p.Name + ")")
		case "rune":
			addLine(goName + " := rune(" + p.Name + ")")

		case "float32":
			addLine(goName + " := float32(" + p.Name + ")")
		case "float64":
			addLine(goName + " := float64(" + p.Name + ")")

		case "int":
			addLine(goName + " := int(" + p.Name + ")")
		case "int8":
			addLine(goName + " := int8(" + p.Name + ")")
		case "uint8":
			addLine(goName + " := uint8(" + p.Name + ")")
		case "int16":
			addLine(goName + " := int16(" + p.Name + ")")
		case "uint16":
			addLine(goName + " := uint16(" + p.Name + ")")
		case "int32":
			addLine(goName + " := int32(" + p.Name + ")")
		case "uint32":
			addLine(goName + " := uint32(" + p.Name + ")")
		case "int64":
			addLine(goName + " := int64(" + p.Name + ")")
		case "uint64":
			addLine(goName + " := uint64(" + p.Name + ")")

		default:
			addLine(goName + " := gml.NewVariantFromPointer((unsafe.Pointer)(" + p.Name + "))")
		}
	}
	return
}

func tmplFuncCToCPPParams(params []*genParam, skipFirstComma bool) (s string) {
	for i, p := range params {
		if !skipFirstComma || i != 0 {
			s += ", "
		}
		s += tmplFuncCToCPPValue(p.Type, p.Name)
	}
	return
}

func tmplFuncCToCPPValue(goType, name string) (s string) {
	switch goType {
	case "bool":
		return "bool(" + name + ")"
	case "byte":
		return name
	case "string":
		return "QString(" + name + ")"
	case "rune":
		return "QChar(" + name + ")"

	case "float32":
		return name
	case "float64":
		return name

	case "int":
		return name
	case "int8":
		return name
	case "uint8":
		return name
	case "int16":
		return name
	case "uint16":
		return name
	case "int32":
		return name
	case "uint32":
		return name
	case "int64":
		return name
	case "uint64":
		return name

	default:
		return "QVariant(*((QVariant*)" + name + "))" // Create a copy of the passed QVariant. The old QVariant will be deleted by Go.
	}
}

func tmplFuncCPPToCParams(params []*genParam, skipFirstComma bool) (s string) {
	for i, p := range params {
		if !skipFirstComma || i != 0 {
			s += ", "
		}
		s += tmplFuncCPPToCValue(p.Type, p.Name)
	}
	return
}

func tmplFuncCPPToCValue(goType, name string) (s string) {
	switch goType {
	case "bool":
		return "u_int8_t(" + name + ")"
	case "byte":
		return "char(" + name + ")"
	case "string":
		return name + ".toLocal8Bit().data()" // Be careful! Only as long as the object lives.
	case "rune":
		return "int32_t(" + name + ")"

	case "float32":
		return name
	case "float64":
		return name

	case "int":
		return name
	case "int8":
		return "int8_t(" + name + ")"
	case "uint8":
		return "u_int8_t(" + name + ")"
	case "int16":
		return "int16_t(" + name + ")"
	case "uint16":
		return "u_int16_t(" + name + ")"
	case "int32":
		return "int32_t(" + name + ")"
	case "uint32":
		return "u_int32_t(" + name + ")"
	case "int64":
		return "int64_t(" + name + ")"
	case "uint64":
		return "u_int64_t(" + name + ")"

	default:
		return "(gml_variant*)(new QVariant(" + name + "))" // Hint: Always free the object.
	}
}

func tmplFuncGoToCValue(goType, goName, cName string, optsIndent ...int) (s string) {
	var ident string
	if len(optsIndent) > 0 {
		for i := 0; i < optsIndent[0]; i++ {
			ident += " "
		}
	}

	addLine := func(l string) {
		s += "\n" + ident + l
	}

	switch goType {
	case "bool":
		addLine("var " + cName + " C.u_int8_t")
		addLine("if " + goName + " { " + cName + " = 1 }")
	case "byte":
		addLine(cName + " := C.char(" + goName + ")")
	case "string":
		addLine(cName + " := C.CString(" + goName + ")")
		addLine("defer C.free(unsafe.Pointer(" + cName + "))")
	case "rune":
		addLine(cName + " := C.int32_t(" + goName + ")")

	case "float32":
		addLine(cName + " := C.float(" + goName + ")")
	case "float64":
		addLine(cName + " := C.double(" + goName + ")")

	case "int":
		addLine(cName + " := C.int(" + goName + ")")
	case "int8":
		addLine(cName + " := C.int8_t(" + goName + ")")
	case "uint8":
		addLine(cName + " := C.u_int8_t(" + goName + ")")
	case "int16":
		addLine(cName + " := C.int16_t(" + goName + ")")
	case "uint16":
		addLine(cName + " := C.u_int16_t(" + goName + ")")
	case "int32":
		addLine(cName + " := C.int32_t(" + goName + ")")
	case "uint32":
		addLine(cName + " := C.u_int32_t(" + goName + ")")
	case "int64":
		addLine(cName + " := C.int64_t(" + goName + ")")
	case "uint64":
		addLine(cName + " := C.u_int64_t(" + goName + ")")

	default:
		addLine(cName + " := (C.gml_variant)(gml.ToVariant(" + goName + ").Pointer())")
	}
	return
}
