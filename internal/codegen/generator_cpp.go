// Copyright (c) 2020 Roland Singer, Sebastian Borchers
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package codegen

func (g *generator) cppHeaderFile(path string, pkg *Package) error {
	g.writefLn("// %s\n", header)

	// Ifndef.
	g.writefLn("#ifndef GML_GEN_CPP_%s_H", pkg.PackageName)
	g.writefLn("#define GML_GEN_CPP_%s_H\n", pkg.PackageName)

	// Includes.
	g.writefLn(`#include "../gen_c/%s.h"`, pkg.PackageName)
	includes := []string{"<iostream>", "<gml.h>", "<gml_cpp.h>", "<QObject>", "<QByteArray>", "<QString>", "<QChar>", "<QVariant>"}
	for _, incl := range includes {
		g.writefLn("#include %s", incl)
	}

	for _, str := range pkg.Structs {
		g.cppStructHeader(str)
	}
	g.ln()

	// Ifndef end.
	g.writeLn("#endif")

	return g.commit(path)
}

func (g *generator) cppStructHeader(str *Struct) {
	g.writeLn("//###")
	g.writefLn("//### %s", str.Name)
	g.writeLn("//###\n")

	// Class definition.
	g.writef("class %s : public ", str.CPPBaseName)
	if str.AdditionalType == "ListModel" {
		g.writeLn("GmlListModel")
	} else {
		g.writeLn("QObject")
	}
	g.writeLn("{")

	// Macros.
	g.indent(func() {
		g.writeLn("Q_OBJECT")
		for _, p := range str.Properties {
			g.writefLn("Q_PROPERTY(%s %s READ %sGet WRITE %sSet NOTIFY %sChanged)", p.Type.Cpp, p.CPPName, p.CPPName, p.CPPName, p.CPPName)
		}
	})
	g.ln()

	// Private.
	g.writeLn("private:")
	g.indent(func() {
		g.writeLn("void* goPtr;")
	})
	g.ln()

	// Public.
	g.writeLn("public:")
	g.indent(func() {
		g.cppStructMethodDeclConstr(str)
		g.writeLn(";")
	})
	g.ln()

	// Signals.
	g.writeLn("signals:")
	g.indent(func() {
		for _, s := range str.Signals {
			g.writef("void %s(", s.CPPName)
			g.cppParams(s.Params, true, true)
			g.writeLn(");")
		}
	})
	g.ln()

	// Slots.
	g.writeLn("public slots:")
	g.indent(func() {
		for _, s := range str.Slots {
			g.writef("%s %s(", s.RetType.Cpp, s.CPPName)
			g.cppParams(s.Params, true, true)
			g.writeLn(");")
		}
	})
	g.ln()

	// Properties.
	g.writeLn("public:")
	g.indent(func() {
		for _, p := range str.Properties {
			g.writefLn("void %sSet(%s v);", p.CPPName, p.Type.Cpp)
			g.writefLn("%s %sGet();", p.Type.Cpp, p.CPPName)
		}
	})
	g.ln()

	g.writeLn("private:")
	g.indent(func() {
		for _, p := range str.Properties {
			g.writefLn("%s %s;", p.Type.Cpp, p.CPPName)
		}
	})
	g.ln()

	g.writeLn("signals:")
	g.indent(func() {
		for _, p := range str.Properties {
			g.writefLn("void %sChanged(%s v);", p.CPPName, p.Type.Cpp)
		}
	})
	g.ln()

	g.writeLn("private slots:")
	g.indent(func() {
		for _, p := range str.Properties {
			if !p.Silent {
				g.writefLn("void %sOnChanged();", p.CPPName)
			}
		}
	})
	g.ln()

	// Class end.
	g.writeLn("};")
}

// TODO: add some catch exception handlers?
func (g *generator) cppSourceFile(path string, pkg *Package) error {
	g.writefLn("// %s\n", header)

	g.writefLn(`#include "%s.h"`, pkg.PackageName)
	g.ln()

	for _, str := range pkg.Structs {
		g.writeLn("//###")
		g.writefLn("//### %s", str.Name)
		g.writeLn("//###\n")

		g.cppStruct(str)
		g.ln()
	}

	return g.commit(path)
}

func (g *generator) cppStruct(str *Struct) {
	// New.
	g.cStructMethodDeclNew(str)
	g.writeLn(" {")
	g.indent(func() {
		g.writefLn("auto _vv = new %s(go_ptr);", str.CPPBaseName)
		g.writeLn("return (void*)_vv;")
	})
	g.writeLn("}\n")

	// Free.
	g.cStructMethodDeclFree(str)
	g.writeLn(" {")
	g.indent(func() {
		g.writeLn("if (_v == NULL) return;")
		g.writefLn("auto _vv = (%s*)_v;", str.CPPBaseName)
		g.writeLn("delete _vv;")
		g.writeLn("_v = NULL;")
	})
	g.writeLn("}\n")

	// Constructor.
	// Method Declaration & Member initializer list.
	g.writef("%s::", str.CPPBaseName)
	g.cppStructMethodDeclConstr(str)
	g.writeLn(" :")
	g.indent(func() {
		if str.AdditionalType == "ListModel" {
			g.writeLn("GmlListModel(goPtr),")
		}
		g.write("goPtr(goPtr)")
		for _, p := range str.Properties {
			g.writef(",\n%s(%s)", p.CPPName, p.Type.CppDefault)
		}
		g.ln()
	})
	g.writeLn("{")
	// Method body.
	g.indent(func() {
		for _, p := range str.Properties {
			if !p.Silent {
				g.writefLn("QObject::connect(this, &%s::%sChanged, this, &%s::%sOnChanged);", str.CPPBaseName, p.CPPName, str.CPPBaseName, p.CPPName)
			}
		}
	})
	g.writeLn("}\n")

	for _, s := range str.Signals {
		g.cppSignal(str, s)
	}

	for _, s := range str.Slots {
		g.cppSlot(str, s)
	}

	for _, p := range str.Properties {
		g.cppProperty(str, p)
	}
}

func (g *generator) cppStructMethodDeclConstr(str *Struct) {
	g.writef("%s(void* goPtr)", str.CPPBaseName)
}

func (g *generator) cppSignal(str *Struct, s *Signal) {
	g.cSignalMethodDecl(str, s)
	g.writeLn(" {")
	g.indent(func() {
		g.writefLn("auto _vv = (%s*)_v;", str.CPPBaseName)
		g.writef("emit _vv->%s(", s.CPPName)
		g.c2CppParams(s.Params, true)
		g.writeLn(");")
	})
	g.writeLn("}\n")
}

func (g *generator) cppSlot(str *Struct, s *Slot) {
	g.writefLn("%s_%s_cb_t %s_%s_cb = NULL;\n", str.CBaseName, s.Name, str.CBaseName, s.Name)
	g.cSlotMethodDecl(str, s)
	g.writeLn(" {")
	g.indent(func() {
		g.writefLn("%s_%s_cb = cb;", str.CBaseName, s.Name)
	})
	g.writeLn("}\n")

	g.writef("%s %s::%s(", s.RetType.Cpp, str.CPPBaseName, s.CPPName)
	g.cppParams(s.Params, true, true)
	g.writeLn(" {")
	g.indent(func() {
		if s.NoRet {
			g.writef("%s_%s_cb(this->goPtr", str.CBaseName, s.Name)
			g.cpp2CParams(s.Params, false)
			g.writeLn(");")
			return
		}

		g.writef("%s _r = %s_%s_cb(this->goPtr", s.RetType.C, str.CBaseName, s.Name)
		g.cpp2CParams(s.Params, false)
		g.writeLn(");")
		g.writefLn("%s _r_cpp = %s;", s.RetType.Cpp, s.RetType.C2Cpp("_r"))
		g.writeLines(s.RetType.FreeC("_r"))
		g.writeLn("return _r_cpp;")
	})
	g.writeLn("}\n")
}

func (g *generator) cppProperty(str *Struct, p *Property) {
	// C methods.
	if !p.Silent {
		g.writefLn("%s_%s_changed_cb_t %s_%s_changed_cb = NULL;\n", str.CBaseName, p.Name, str.CBaseName, p.Name)
		g.cPropertyMethodDeclChange(str, p)
		g.writeLn(" {")
		g.indent(func() {
			g.writefLn("%s_%s_changed_cb = cb;", str.CBaseName, p.Name)
		})
		g.writeLn("}\n")
	}

	g.cPropertyMethodDeclGet(str, p)
	g.writeLn(" {")
	g.indent(func() {
		g.writefLn("auto cc = (%s*)c;", p.CPPName)
		g.writefLn("%s v = cc->%sGet();", p.Type.Cpp, p.CPPName)
		g.writefLn("return %s;", p.Type.Cpp2C("v"))
	})
	g.writeLn("}\n")

	g.cPropertyMethodDeclSet(str, p)
	g.writeLn(" {")
	g.indent(func() {
		g.writefLn("auto cc = (%s*)c;", str.CPPBaseName)
		g.writefLn("return %s;", p.Type.C2Cpp("v"))
	})
	g.writeLn("}\n")

	// Cpp methods.
	if !p.Silent {
		g.writefLn("void %s::%sOnChanged() {", str.CPPBaseName, p.CPPName)
		g.indent(func() {
			g.writefLn("%s_%s_changed_cb(this->goPtr);", str.CBaseName, p.Name)
		})
		g.writeLn("}\n")
	}

	g.writefLn("%s %s::%sGet() {", p.Type.Cpp, str.CPPBaseName, p.CPPName)
	g.indent(func() {
		g.writefLn("return %s;", p.CPPName)
	})
	g.writeLn("}\n")

	g.writefLn("void %s::%sSet(%s v) {", str.CPPBaseName, p.CPPName, p.Type.Cpp)
	g.indent(func() {
		g.writefLn("%s = v;", p.CPPName)
		g.writefLn("emit %sChanged(v);", p.CPPName)
	})
	g.writeLn("}\n")
}

//##############//
//### Helper ###//
//##############//

func (g *generator) cppParams(ps []*Param, withType, skipFirstComma bool) {
	for i, p := range ps {
		if !skipFirstComma || i != 0 {
			g.write(", ")
		}
		if withType {
			g.writef("%s ", p.Type.Cpp)
		}
		g.write(p.Name)
	}
}

func (g *generator) c2CppParams(ps []*Param, skipFirstComma bool) {
	for i, p := range ps {
		if !skipFirstComma || i != 0 {
			g.write(" ,")
		}
		g.write(p.Type.C2Cpp(p.Name))
	}
}

func (g *generator) cpp2CParams(ps []*Param, skipFirstComma bool) {
	for i, p := range ps {
		if !skipFirstComma || i != 0 {
			g.write(" ,")
		}
		g.write(p.Type.Cpp2C(p.Name))
	}
}
