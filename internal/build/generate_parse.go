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

import (
	"fmt"
	"go/ast"
	"go/build"
	"go/importer"
	"go/parser"
	"go/token"
	"go/types"
	"os"
	"path/filepath"
	"strings"
	"unicode"

	"github.com/desertbit/gml/internal/utils"
)

const (
	skipPrefix    = "gml_gen_"
	cBasePrefix   = "gml_gen"
	cppBasePrefix = "GMLGen"
)

var (
	typesConf = types.Config{
		Importer:         importer.For("source", nil),
		IgnoreFuncBodies: true,
		FakeImportC:      true,
	}
)

// TODO: make concurrent with multiple goroutines.
func parseDirRecursive(dir string) (gt *genTargets, err error) {
	// Obtain all imports including the package in the base dir.
	imports, basePath, err := getPackageImports(dir)
	if err != nil {
		return
	}

	gt = &genTargets{}
	fset := token.NewFileSet()

	// In reverse for deepest import first.
	for i := len(imports) - 1; i >= 0; i-- {
		err = parseDir(gt, fset, filepath.Join(basePath, imports[i]))
		if err != nil {
			return
		}
	}

	return
}

// TODO: use ast package with ImportsOnly to make this even faster?
func getPackageImports(dir string) (imports []string, basePath string, err error) {
	dir, err = filepath.Abs(dir)
	if err != nil {
		return
	}

	pkg, err := build.ImportDir(dir, 0)
	if err != nil {
		return
	}

	// Base import without the main package import path.
	basePath = filepath.Clean(strings.TrimSuffix(dir, pkg.ImportPath))

	// Add the main package first.
	imports = append(imports, pkg.ImportPath)

	// Add further recursive packages.
	err = getPackageImportsRec(pkg, pkg.ImportPath, basePath, &imports)
	if err != nil {
		return
	}

	return
}

func getPackageImportsRec(pkg *build.Package, mustPrefix, basePath string, imports *[]string) (err error) {
Loop:
	for _, imp := range pkg.Imports {
		if !strings.HasPrefix(imp, pkg.ImportPath) {
			continue Loop
		}

		// Check if already present in imports slice.
		for _, i := range *imports {
			if i == imp {
				continue Loop
			}
		}

		// Add import.
		*imports = append(*imports, imp)

		// Add further recursive packages.
		var subPkg *build.Package
		subPkg, err = build.ImportDir(filepath.Join(basePath, imp), 0)
		if err != nil {
			return
		}
		err = getPackageImportsRec(subPkg, mustPrefix, basePath, imports)
		if err != nil {
			return
		}
	}
	return
}

func parseDir(gt *genTargets, fset *token.FileSet, dir string) (err error) {
	// Parse go sources and skip gml_gen prefixed files.
	pkgs, err := parser.ParseDir(fset, dir, func(i os.FileInfo) bool {
		return !strings.HasPrefix(i.Name(), skipPrefix)
	}, 0)
	if err != nil {
		return
	}

	// There should be only one package in the map,
	// if the go source is valid and correct.
	if len(pkgs) != 1 {
		return fmt.Errorf("invalid package: multiple package definitions")
	}

	// Obtain the single package.
	var pkgName string
	var pkg *ast.Package
	for n, p := range pkgs {
		pkgName = n
		pkg = p
		break
	}

	gp := &genPackage{
		Dir:         dir,
		PackageName: pkgName,
	}

	// Create a slice of ast files.
	i := 0
	files := make([]*ast.File, len(pkg.Files))
	for _, f := range pkg.Files {
		files[i] = f
		i++
	}

	info := &types.Info{
		Defs: make(map[*ast.Ident]types.Object),
	}

	// Type-check the package containing only file f.
	// Check returns a *types.Package.
	_, err = typesConf.Check(pkgName, fset, files, info)
	if err != nil {
		return
	}

	for id, obj := range info.Defs {
		if obj == nil {
			continue
		}

		objT := obj.Type()

		// Must be a named type.
		_, ok := objT.(*types.Named)
		if !ok {
			continue
		}

		// Underlying type must be a struct.
		s, ok := objT.Underlying().(*types.Struct)
		if !ok {
			continue
		}

		var (
			hasEmbeddedObject bool
			structName        = obj.Name()
			numFields         = s.NumFields()
		)

		gs := &genStruct{
			Name:        structName,
			CBaseName:   cBasePrefix + "_" + utils.FirstCharToLower(gp.PackageName) + "_" + structName,
			CPPBaseName: cppBasePrefix + utils.FirstCharToUpper(gp.PackageName) + structName,
		}

		// Check all struct fields.
		for i = 0; i < numFields; i++ {
			f := s.Field(i)

			// Check if this is an embedded gml.Object field.
			if f.Embedded() && strings.HasSuffix(f.Type().String(), "/gml.Object") {
				hasEmbeddedObject = true
				continue
			}

			// Check for the _ struct field.
			name := f.Name()
			if name != "_" {
				continue
			}
			su, ok := f.Type().(*types.Struct)
			if !ok {
				continue
			}

			err = parseUnderlineStruct(gs, fset, su)
			if err != nil {
				return
			}
		}

		// Skip if the struct is empty.
		if len(gs.Signals) == 0 && len(gs.Slots) == 0 && len(gs.Properties) == 0 {
			continue
		}

		// There must be one embedded gml.Object field.
		if !hasEmbeddedObject {
			return newParseError(fset, id.Pos(), fmt.Errorf("invalid struct: gml.Object must be embedded"))
		}

		gp.Structs = append(gp.Structs, gs)
	}

	// Skip if the package is empty.
	if len(gp.Structs) > 0 {
		gt.Packages = append(gt.Packages, gp)
	}
	return

}

func parseUnderlineStruct(gs *genStruct, fset *token.FileSet, s *types.Struct) (err error) {
	numFields := s.NumFields()
	for i := 0; i < numFields; i++ {
		// Extract the tag value and key.
		tagValue := s.Tag(i)
		pos := strings.Index(tagValue, ":")
		if pos < 0 {
			continue
		}
		tagKey := tagValue[:pos]
		tagValue = strings.Trim(tagValue[pos+1:], "\"")

		// Tag key must match gml token.
		if tagKey != "gml" {
			continue
		}

		f := s.Field(i)

		// Ensure name is set.
		name := f.Name()
		if len(name) == 0 {
			continue
		}

		var (
			silent bool
		)

		switch tagValue {
		case "signal":
			err = parseSignal(gs, fset, f, name)
			if err != nil {
				return
			}
		case "slot":
			err = parseSlot(gs, fset, f, name)
			if err != nil {
				return
			}
		case "property,silent":
			silent = true
			fallthrough
		case "property":
			err = parseProperty(gs, fset, f, name, silent)
			if err != nil {
				return
			}
		default:
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid struct tag value: %v", tagValue))
		}
	}
	return
}

func parseSignal(gs *genStruct, fset *token.FileSet, f *types.Var, name string) (err error) {
	// Must be a function signature.
	s, ok := f.Type().(*types.Signature)
	if !ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: must be a function signature"))
	}

	// Variadic functions are not supported.
	if s.Variadic() {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: variadic functions are not supported"))
	}

	// Ensure the function does not contain any return value.
	retVals := s.Results()
	if retVals != nil && retVals.Len() > 0 {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: must not contain a return value"))
	}

	params := s.Params()
	paramsLen := params.Len()

	signal := &genSignal{
		Name:    name,
		CPPName: utils.FirstCharToLower(name), // Qt signal names must be lower-case.
		Params:  make([]*genParam, 0, paramsLen),
	}

	// Prepare the emit name.
	// Prefix with emit and ensure it is private or public as specified.
	if unicode.IsUpper(rune(signal.Name[0])) {
		signal.EmitName = "Emit" + signal.Name
	} else {
		signal.EmitName = "emit" + utils.FirstCharToUpper(signal.Name)
	}

	// Prepare all params.
	for i := 0; i < paramsLen; i++ {
		p := params.At(i)
		pName := p.Name()

		// Ensure a parameter name is set.
		if len(pName) == 0 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal function parameter: name not set"))
		}

		typeStr := goType(p.Type())
		signal.Params = append(signal.Params, &genParam{
			Name:    pName,
			Type:    typeStr,
			CType:   goTypeToC(typeStr),
			CPPType: goTypeToCPP(typeStr),
		})
	}

	gs.Signals = append(gs.Signals, signal)
	return
}

func parseSlot(gs *genStruct, fset *token.FileSet, f *types.Var, name string) (err error) {
	// Must be a function signature.
	s, ok := f.Type().(*types.Signature)
	if !ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot: must be a function signature"))
	}

	// Variadic functions are not supported.
	if s.Variadic() {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot: variadic functions are not supported"))
	}

	// Handkle returns values.
	var retType string
	retVals := s.Results()
	if retVals != nil && retVals.Len() > 0 {
		if retVals.Len() > 1 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot: multiple return values are not supported"))
		}
		retType = retVals.At(0).Type().String()
	}

	params := s.Params()
	paramsLen := params.Len()

	slot := &genSlot{
		Name:    name,
		CPPName: utils.FirstCharToLower(name), // Qt slot names must be lower-case.
		Params:  make([]*genParam, 0, paramsLen),
		NoRet:   (retType == ""),
		RetType: retType,
	}

	// Set to void type if no return type is set.
	if slot.NoRet {
		slot.CRetType = "void"
		slot.CPPRetType = "void"
	} else {
		slot.CRetType = goTypeToC(retType)
		slot.CPPRetType = goTypeToCPP(retType)
		slot.CGoRetType = goTypeToCGo(retType)
	}

	// Prepare all params.
	for i := 0; i < paramsLen; i++ {
		p := params.At(i)
		pName := p.Name()

		// Ensure a parameter name is set.
		if len(pName) == 0 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot function parameter: name not set"))
		}

		typeStr := goType(p.Type())
		slot.Params = append(slot.Params, &genParam{
			Name:    pName,
			Type:    typeStr,
			CType:   goTypeToC(typeStr),
			CGoType: goTypeToCGo(typeStr),
			CPPType: goTypeToCPP(typeStr),
		})
	}

	gs.Slots = append(gs.Slots, slot)
	return
}

func parseProperty(gs *genStruct, fset *token.FileSet, f *types.Var, name string, silent bool) (err error) {
	// Ensure it is not a function signature.
	_, ok := f.Type().(*types.Signature)
	if ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid property: must be a variable"))
	}

	typeStr := goType(f.Type())
	privName := utils.FirstCharToLower(name)
	pubName := utils.FirstCharToUpper(name)

	var setName string
	if unicode.IsUpper(rune(name[0])) {
		setName = "Set" + pubName
	} else {
		setName = "set" + pubName
	}

	prop := &genProperty{
		Name:       name,
		PublicName: pubName,
		CPPName:    privName,
		SetName:    setName,

		Type:    typeStr,
		CType:   goTypeToC(typeStr),
		CPPType: goTypeToCPP(typeStr),

		Silent: silent,
	}

	gs.Properties = append(gs.Properties, prop)
	return
}

func newParseError(fset *token.FileSet, p token.Pos, err error) error {
	pos := fset.Position(p)
	return fmt.Errorf("%s: line %v: %v", pos.Filename, pos.Line, err)
}

// Returns interface{} if unknown.
func goType(t types.Type) string {
	switch t := t.(type) {
	case *types.Basic:
		return t.String()
	default:
		return "interface{}"
	}
}

func goTypeToC(t string) string {
	switch t {
	case "bool":
		return "u_int8_t"
	case "byte":
		return "char"
	case "string":
		return "char*"
	case "rune":
		return "int32_t"

	case "float32":
		return "float"
	case "float64":
		return "double"

	case "int":
		return "int"
	case "int8":
		return "int8_t"
	case "uint8":
		return "u_int8_t"
	case "int16":
		return "int16_t"
	case "uint16":
		return "u_int16_t"
	case "int32":
		return "int32_t"
	case "uint32":
		return "u_int32_t"
	case "int64":
		return "int64_t"
	case "uint64":
		return "u_int64_t"

	default:
		return "gml_variant"
	}
}

func goTypeToCPP(t string) string {
	switch t {
	case "bool":
		return "bool"
	case "byte":
		return "char"
	case "string":
		return "QString"
	case "rune":
		return "QChar"

	case "float32":
		return "float"
	case "float64":
		return "double"

	// QML only supports int.
	case "int":
		return "int"
	case "int8":
		return "int"
	case "uint8":
		return "int"
	case "int16":
		return "int"
	case "uint16":
		return "int"
	case "int32":
		return "int"
	case "uint32":
		return "int"

	// TODO: support int64 & uint64.
	case "int64":
		panic("currently int64 is not supported")
	case "uint64":
		panic("currently uint64 is not supported")

	default:
		return "QVariant"
	}
}

func goTypeToCGo(t string) string {
	switch t {
	case "bool":
		return "C.u_int8_t"
	case "byte":
		return "C.char"
	case "string":
		return "*C.char"
	case "rune":
		return "C.int32_t"

	case "float32":
		return "C.float"
	case "float64":
		return "C.double"

	case "int":
		return "C.int"
	case "int8":
		return "C.int8_t"
	case "uint8":
		return "C.u_int8_t"
	case "int16":
		return "C.int16_t"
	case "uint16":
		return "C.u_int16_t"
	case "int32":
		return "C.int32_t"
	case "uint32":
		return "C.u_int32_t"
	case "int64":
		return "C.int64_t"
	case "uint64":
		return "C.u_int64_t"

	default:
		return "C.gml_variant"
	}
}
