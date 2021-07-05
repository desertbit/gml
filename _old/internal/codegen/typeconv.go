// Copyright (c) 2020 Roland Singer, Sebastian Borchers
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package codegen

import "fmt"

type TypeConverter struct {
	Go         string
	C          string
	Cpp        string
	CppDefault string
	Cgo        string

	Go2Cgo func(goName, cName string) []string
	Cgo2Go func(goName, cName string) []string
	C2Cpp  func(name string) string
	Cpp2C  func(name string) string
	FreeC  func(name string) []string
}

func newTypeConverter(goType string) (tc TypeConverter) {
	for _, tc = range typeConverters {
		if tc.Go == goType {
			return
		}
	}
	tc = defaultTypeConverter
	return
}

var voidTypeConverter = TypeConverter{
	C:      "void",
	Cpp:    "void",
	Go2Cgo: func(goName, cName string) []string { return []string{} },
	Cgo2Go: func(goName, cName string) []string { return []string{} },
	C2Cpp:  func(name string) string { return "" },
	Cpp2C:  func(name string) string { return "" },
	FreeC:  func(name string) []string { return []string{} },
}

var defaultTypeConverter = TypeConverter{
	Go:         "interface{}",
	C:          "gml_variant",
	Cpp:        "QVariant",
	CppDefault: "QVariant()",
	Cgo:        "C.gml_variant",
	Go2Cgo: func(goName, cName string) []string {
		vName := "_v_" + goName
		return []string{
			fmt.Sprintf("%s := gml.ToVariant(%s)", vName, goName),
			fmt.Sprintf("defer %s.Free()", vName),
			fmt.Sprintf("%s := (C.gml_variant)(%s.Pointer())", cName, vName),
		}
	},
	Cgo2Go: func(goName, cName string) []string {
		return []string{fmt.Sprintf("%s := gml.NewVariantFromPointer((unsafe.Pointer)(%s))", goName, cName)}
	},
	C2Cpp: func(name string) string {
		// Create a copy of the passed QVariant. The old QVariant will be deleted by Go.
		return fmt.Sprintf("QVariant(*((QVariant*)%s))", name)
	},
	Cpp2C: func(name string) string {
		// Always free the object.
		return fmt.Sprintf("(gml_variant*)(new QVariant(%s))", name)
	},
	FreeC: func(name string) []string {
		return []string{fmt.Sprintf("gml_variant_free(%s);", name)}
	},
}

var typeConverters = []TypeConverter{
	{
		Go:         "bool",
		C:          "u_int8_t",
		Cpp:        "bool",
		CppDefault: "false",
		Cgo:        "C.u_int8_t",
		Go2Cgo: func(goName, cName string) []string {
			return []string{
				fmt.Sprintf("var %s C.u_int8_t", cName),
				fmt.Sprintf("if %s { %s = 1 }", goName, cName),
			}
		},
		Cgo2Go: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := %s != 0", goName, cName)}
		},
		C2Cpp: func(name string) string { return fmt.Sprintf("bool(%s)", name) },
		Cpp2C: func(name string) string { return fmt.Sprintf("u_int8_t(%s)", name) },
		FreeC: func(name string) []string { return []string{} },
	},
	{
		Go:         "byte",
		C:          "char",
		Cpp:        "char",
		CppDefault: "0",
		Cgo:        "C.char",
		Go2Cgo: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := C.char(%s)", cName, goName)}
		},
		Cgo2Go: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := byte(%s)", goName, cName)}
		},
		C2Cpp: func(name string) string { return name },
		Cpp2C: func(name string) string { return fmt.Sprintf("char(%s)", name) },
		FreeC: func(name string) []string { return []string{} },
	},
	{
		Go:         "string",
		C:          "char*",
		Cpp:        "QString",
		CppDefault: `""`,
		Cgo:        "*C.char",
		Go2Cgo: func(goName, cName string) []string {
			return []string{
				fmt.Sprintf("%s := C.CString(%s)", cName, goName),
				fmt.Sprintf("defer C.free(unsafe.Pointer(%s))", cName),
			}
		},
		Cgo2Go: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := C.GoString(%s)", goName, cName)}
		},
		C2Cpp: func(name string) string { return fmt.Sprintf("QString(%s)", name) },
		Cpp2C: func(name string) string {
			// Be careful! Only as long as the object lives.
			return fmt.Sprintf("%s.toUtf8().data()", name)
		},
		FreeC: func(name string) []string {
			return []string{fmt.Sprintf("free(%s);", name)}
		},
	},
	{
		Go:         "rune",
		C:          "int32_t",
		Cpp:        "QChar",
		CppDefault: "''",
		Cgo:        "C.int32_t",
		Go2Cgo: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := C.int32_t(%s)", cName, goName)}
		},
		Cgo2Go: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := rune(%s)", goName, cName)}
		},
		C2Cpp: func(name string) string { return fmt.Sprintf("QChar(%s)", name) },
		Cpp2C: func(name string) string { return fmt.Sprintf("int32_t(%s)", name) },
		FreeC: func(name string) []string { return []string{} },
	},
	{
		Go:         "float32",
		C:          "float",
		Cpp:        "float",
		CppDefault: "0",
		Cgo:        "C.float",
		Go2Cgo: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := C.float(%s)", cName, goName)}
		},
		Cgo2Go: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := float32(%s)", goName, cName)}
		},
		C2Cpp: func(name string) string { return name },
		Cpp2C: func(name string) string { return name },
		FreeC: func(name string) []string { return []string{} },
	},
	{
		Go:         "float64",
		C:          "double",
		Cpp:        "double",
		CppDefault: "0",
		Cgo:        "C.double",
		Go2Cgo: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := C.double(%s)", cName, goName)}
		},
		Cgo2Go: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := float64(%s)", goName, cName)}
		},
		C2Cpp: func(name string) string { return name },
		Cpp2C: func(name string) string { return name },
		FreeC: func(name string) []string { return []string{} },
	},
	{
		Go:         "int",
		C:          "int",
		Cpp:        "int",
		CppDefault: "0",
		Cgo:        "C.int",
		Go2Cgo: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := C.int(%s)", cName, goName)}
		},
		Cgo2Go: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := int(%s)", goName, cName)}
		},
		C2Cpp: func(name string) string { return name },
		Cpp2C: func(name string) string { return name },
		FreeC: func(name string) []string { return []string{} },
	},
	{
		Go:         "int32",
		C:          "int",
		Cpp:        "int",
		CppDefault: "0",
		Cgo:        "C.int",
		Go2Cgo: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := C.int32_t(%s)", cName, goName)}
		},
		Cgo2Go: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := int32(%s)", goName, cName)}
		},
		C2Cpp: func(name string) string { return name },
		Cpp2C: func(name string) string { return fmt.Sprintf("int32_t(%s)", name) },
		FreeC: func(name string) []string { return []string{} },
	},
	{
		Go:         "int64",
		C:          "long",
		Cpp:        "long",
		CppDefault: "0",
		Cgo:        "C.long",
		Go2Cgo: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := C.int64_t(%s)", cName, goName)}
		},
		Cgo2Go: func(goName, cName string) []string {
			return []string{fmt.Sprintf("%s := int64(%s)", goName, cName)}
		},
		C2Cpp: func(name string) string { return name },
		Cpp2C: func(name string) string { return fmt.Sprintf("int64_t(%s)", name) },
		FreeC: func(name string) []string { return []string{} },
	},
}
