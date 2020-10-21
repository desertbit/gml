// Copyright (c) 2020 Roland Singer, Sebastian Borchers
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package codegen

import "fmt"

func (g *generator) goFile(path string, pkg *Package) error {
	g.writefLn("package %s\n", pkg.PackageName)

	// Compiler directives and C headers.
	g.writeLn("/*")
	g.writeLn("#cgo pkg-config: Qt5Core Qt5Qml Qt5Quick")
	g.writeLn("#cgo LDFLAGS: -lstdc++")
	g.writeLn("#include <gml.h>")
	g.writeLn("#include <gml_gen.h>\n")

	for _, str := range pkg.Structs {
		for _, slot := range str.Slots {
			g.writef("extern %s %s_%s_go_slot(void* _goPtr", slot.RetType.C, str.CBaseName, slot.Name)
			g.cParams(slot.Params, true, false)
			g.writeLn(")")
		}
		for _, prop := range str.Properties {
			if prop.Silent {
				continue
			}

			g.writefLn("extern void %s_%s_go_prop_changed(void* _goPtr);", str.CBaseName, prop.Name)
		}

		g.writefLn("static void %s_register() {", str.CBaseName)
		for _, slot := range str.Slots {
			g.writefLn("%s_%s_cb_register(%s_%s_go_slot);", str.CBaseName, slot.Name, str.CBaseName, slot.Name)
		}
		for _, prop := range str.Properties {
			g.writefLn("%s_%s_cb_register(%s_%s_go_prop_changed);", str.CBaseName, prop.Name, str.CBaseName, prop.Name)
		}
		g.writeLn("}\n")
	}
	g.writeLn("*/")

	// Go imports.
	imports := []string{"unsafe", "runtime", "github.com/desertbit/gml", "github.com/desertbit/gml/pointer"}
	g.writeLn(`import "C"`)
	g.writeLn("import (")
	for _, imp := range imports {
		g.indent(func() {
			g.writefLn(`"%s"`, imp)
		})
	}
	g.writeLn(")\n")

	// Ensure import usages.
	g.writeLn("// Force to use the gml package. The import is not always required...")
	g.writeLn("var (")
	g.indent(func() {
		g.writeLn("_ unsafe.Pointer")
		g.writeLn("_ runtime.Error")
		g.writeLn("_ gml.Object")
		g.writeLn("_ = pointer.Save")
	})
	g.writeLn(")\n")

	// Generate struct.
	for _, str := range pkg.Structs {
		g.goStruct(str)
	}

	// Commit the file.
	return g.commit(path)
}

func (g *generator) goStruct(str *Struct) {
	g.writeLn("//###")
	g.writefLn("//### %s", str.Name)
	g.writeLn("//###\n")

	// init()
	g.writefLn("func init() { C.%s_register() }", str.CBaseName)

	// GmlInit()
	g.writefLn("func (_v *%s) GmlInit() {", str.Name)
	g.indent(func() {
		g.writeLn("goPtr := pointer.Save(_v)")
		g.writeLn("_v.GmlObject_SetGoPointer(goPtr)")
		g.writefLn("_v.GmlObject_SetPointer(unsafe.Pointer(C.%s_new(goPtr)))", str.CBaseName)
		g.writefLn("runtime.SetFinalizer(_v, func(_v *%s) {", str.Name)
		g.indent(func() {
			g.writefLn("C.%s_free((C.%s)(_v.GmlObject_Pointer()))", str.CBaseName, str.CBaseName)
			g.writeLn("pointer.Unref(goPtr)")
		})
		g.writeLn("})")
	})
	g.writeLn("}\n")

	g.writeLn("// Signals")
	for _, s := range str.Signals {
		g.goSignal(str, s)
	}

	g.writeLn("// Slots")
	for _, s := range str.Slots {
		g.goSlot(str, s)
	}

	g.writeLn("// Properties")
	for _, p := range str.Properties {
		g.goProperty(str, p)
	}

	g.ln()
}

func (g *generator) goSignal(str *Struct, s *Signal) {
	// Method declaration.
	g.writef("func (_v *%s) %s(", str.Name, s.EmitName)
	g.goParams(s.Params, true, true, "")
	g.writeLn(") {")

	// Method body.
	g.indent(func() {
		g.writefLn("_ptr := (C.%s)(_v.GmlObject_Pointer())", str.CBaseName)
		g.go2CgoParams(s.Params, "_c_")
		g.writefLn("C.%s_%s(_ptr", str.CBaseName, s.Name)
		g.goParams(s.Params, false, false, "_c_")
		g.writeLn(")")
	})

	g.writeLn("}\n")
}

func (g *generator) goSlot(str *Struct, s *Slot) {
	methodName := fmt.Sprintf("%s_%s_go_slot", str.CBaseName, s.Name)

	// Method declaration.
	g.writefLn("//export %s", methodName)
	g.writef("func %s(_goPtr unsafe.Pointer", methodName)
	g.goParams(s.Params, true, false, "")
	g.writefLn(") %s {", s.RetType.Cgo)

	// Method body.
	g.indent(func() {
		g.writefLn("_v := (pointer.Restore(_goPtr)).(*%s)", str.Name)
		g.cgo2GoParams(s.Params, "_go_")

		if s.NoRet {
			g.writef("_v.%s(", s.Name)
			g.goParams(s.Params, false, true, "_go_")
			g.writeLn(")")
		} else {
			g.writef("_r := _v.%s(", s.Name)
			g.goParams(s.Params, false, true, "_go_")
			g.writeLn(")")
			g.writeLines(s.RetType.Go2Cgo("_r", "_rc"))
			g.writeLn("return _rc")
		}
	})

	g.writeLn("}\n")
}

func (g *generator) goProperty(str *Struct, p *Property) {
	// Getter.
	g.writefLn("func (_v *%s) %s() (r %s) {", str.Name, p.Name, p.Type.Go)
	g.indent(func() {
		g.writefLn("_ptr := (C.%s)(_v.GmlObject_Pointer())", str.CBaseName)
		g.writeLn("gml.RunMain(func() {")
		g.indent(func() {
			g.writefLn("v := C.%s_%s_get(_ptr)", str.CBaseName, p.Name)
			g.writeLines(p.Type.Cgo2Go("vg", "v"))
			g.writeLn("r = vg")
		})
		g.writeLn("})")
		g.writeLn("return")
	})
	g.writeLn("}\n")

	// Setter.
	g.writefLn("func (_v *%s) %s(v %s) {", str.Name, p.SetName, p.Type.Go)
	g.indent(func() {
		g.writefLn("_ptr := (C.%s)(_v.GmlObject_Pointer())", str.CBaseName)
		g.writeLines(p.Type.Go2Cgo("v", "vc"))
		g.writeLn("gml.RunMain(func() {")
		g.indent(func() {
			g.writefLn("C.%s_%s_set(_ptr, vc)", str.CBaseName, p.Name)
		})
		g.writeLn("})")
	})
	g.writeLn("}\n")

	// OnChange.
	if !p.Silent {
		methodName := fmt.Sprintf("%s_%s_go_prop_changed", str.CBaseName, p.Name)
		g.writefLn("//export %s", methodName)
		g.writefLn("func %s(_goPtr unsafe.Pointer)", methodName)
		g.indent(func() {
			g.writefLn("_v := (pointer.Restore(_goPtr)).(*%s)", str.Name)
			g.writefLn("_v.on%sChanged()", p.PublicName)
		})
		g.writeLn("}\n")
	}
}

//##############//
//### Helper ###//
//##############//

func (g *generator) goParams(ps []*Param, withType, skipFirstComma bool, prefix string) {
	for i, p := range ps {
		if !skipFirstComma || i != 0 {
			g.write(", ")
		}

		g.writef("%s%s", prefix, p.Name)
		if withType {
			g.writef(" %s", p.Type.Go)
		}
	}
}

func (g *generator) cGoParams(ps []*Param, withType, skipFirstComma bool, prefix string) {
	for i, p := range ps {
		if !skipFirstComma || i != 0 {
			g.write(", ")
		}

		g.writef("%s%s", prefix, p.Name)
		if withType {
			g.writef(" %s", p.Type.Cgo)
		}
	}
}

func (g *generator) go2CgoParams(ps []*Param, namePrefix string) {
	for _, p := range ps {
		for _, line := range p.Type.Go2Cgo(p.Name, namePrefix+p.Name) {
			g.writeLn(line)
		}
	}
}

func (g *generator) cgo2GoParams(ps []*Param, namePrefix string) {
	for _, p := range ps {
		for _, line := range p.Type.Cgo2Go(p.Name, namePrefix+p.Name) {
			g.writeLn(line)
		}
	}
}
