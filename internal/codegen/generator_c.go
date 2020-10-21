// Copyright (c) 2020 Roland Singer, Sebastian Borchers
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package codegen

import (
	"path/filepath"
)

// TODO: doc correct?
// This should be in a separate directory, so no unnecessary files are in the global include dir.
func (g *generator) cMainHeaderFile(pkgs []*Package, genDir string) error {
	// Ifndef.
	g.writeLn("#ifndef GML_GEN_C_INCLUDE_H")
	g.writeLn("#define GML_GEN_C_INCLUDE_H")

	// Includes.
	for _, pkg := range pkgs {
		g.writefLn(`#include "../%s.h"`, pkg.PackageName)
	}

	// Ifndef end.
	g.writeLn("#endif")

	return g.commit(filepath.Join(genDir, "gml_gen.h"))
}

func (g *generator) cHeaderFile(path string, pkg *Package) (err error) {
	// Ifndef.
	g.writefLn("#ifndef GML_GEN_C_%s_H", pkg.PackageName)
	g.writefLn("#define GML_GEN_C_%s_H\n", pkg.PackageName)

	// Includes.
	g.writeLn("#incldue <gml.h>\n")

	// Cpp extern definition.
	g.writeLn("#ifdef __cplusplus")
	g.writeLn(`extern "C" {`)
	g.writeLn("#endif\n")

	for _, str := range pkg.Structs {
		g.cStructHeader(str)
	}
	g.ln()

	// Cpp extern definition end.
	g.writeLn("#ifdef __cplusplus")
	g.writeLn("}")
	g.writeLn("#endif\n")

	// Ifndef end.
	g.writeLn("#endif")

	return g.commit(path)
}

func (g *generator) cStructHeader(str *Struct) {
	g.writeLn("//###")
	g.writefLn("//### %s", str.Name)
	g.writeLn("//###\n")

	// Definitions.
	g.writefLn("typedef void* %s;\n", str.CBaseName)

	// Declarations.
	g.cStructMethodDeclNew(str)
	g.writeLn(";")
	g.cStructMethodDeclFree(str)
	g.writeLn(";\n")

	g.writeLn("// Signals.")
	for _, s := range str.Signals {
		g.cSignalMethodDecl(str, s)
		g.writeLn(";")
	}
	g.ln()

	g.writeLn("// Slots.")
	for _, s := range str.Slots {
		g.writef("typedef %s (*%s_%s_cb_t)(void* _go_ptr", s.RetType.C, str.CBaseName, s.Name)
		g.cParams(s.Params, true, false)
		g.writeLn(");")

		g.cSlotMethodDecl(str, s)
		g.writeLn(";")
	}
	g.ln()

	g.writeLn("// Properties.")
	for _, p := range str.Properties {
		g.cPropertyMethodDeclGet(str, p)
		g.writeLn(";")
		g.cPropertyMethodDeclSet(str, p)
		g.writeLn(";")
		if !p.Silent {
			g.cPropertyMethodDeclChange(str, p)
			g.writeLn(";")
		}
	}
	g.ln()
}

func (g *generator) cStructMethodDeclNew(str *Struct) {
	g.writef("%s %s_new(void* go_ptr)", str.CBaseName, str.CBaseName)
}
func (g *generator) cStructMethodDeclFree(str *Struct) {
	g.writef("void %s_free(%s)", str.CBaseName, str.CBaseName)
}

func (g *generator) cSignalMethodDecl(str *Struct, s *Signal) {
	g.writef("void %s_%s(%s _v", str.CBaseName, s.Name, str.CBaseName)
	g.cParams(s.Params, true, false)
	g.write(")")
}

func (g *generator) cSlotMethodDecl(str *Struct, s *Slot) {
	g.writefLn("void %s_%s_cb_register(%s_%s_cb_t cb)", str.CBaseName, s.Name, str.CBaseName, s.Name)
}

func (g *generator) cPropertyMethodDeclGet(str *Struct, p *Property) {
	g.writefLn("%s %s_%s_get(%s c)", p.Type.C, str.CBaseName, p.Name, str.CBaseName)
}

func (g *generator) cPropertyMethodDeclSet(str *Struct, p *Property) {
	g.writefLn("void %s_%s_set(%s c, %s v)", str.CBaseName, p.Name, str.CBaseName, p.Type.C)
}

func (g *generator) cPropertyMethodDeclChange(str *Struct, p *Property) {
	g.writefLn("void %s_%s_cb_register(%s_%s_changed_cb_t cb)", str.CBaseName, p.Name, str.CBaseName, p.Name)
}

//##############//
//### Helper ###//
//##############//

func (g *generator) cParams(ps []*Param, withType, skipFirstComma bool) {
	for i, p := range ps {
		if !skipFirstComma || i != 0 {
			g.write(", ")
		}
		if withType {
			g.writef("%s ", p.Type.C)
		}
		g.write(p.Name)
	}
}
