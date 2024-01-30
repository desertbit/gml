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
	"errors"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"io/ioutil"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"sync"
	"unicode"

	"github.com/desertbit/closer/v3"
	"github.com/desertbit/gml/internal/utils"
)

const (
	skipPrefix    = "gml_gen_"
	cBasePrefix   = "gml_gen"
	cppBasePrefix = "GMLGen"
)

func parseDirRecursive(ctx *Context) (gt *genTargets, err error) {
	// Our parsed results.
	gt = &genTargets{}

	// Find go mod file in the root directory.
	goModFilePath, err := utils.FindModPath(ctx.RootDir)
	if err != nil {
		return
	}

	// Parse the go.mod file to obtain the root import path.
	goRootImport, err := parseGoMod(goModFilePath)
	if err != nil {
		return
	}

	// Retrieve the difference between root and source dir.
	// This must be appended to the go root import as well.
	goRootImport = filepath.Join(goRootImport, strings.TrimPrefix(ctx.SourceDir, ctx.RootDir))

	var (
		wg          sync.WaitGroup
		parseImport func(path string)

		cl         = closer.New()
		numWorkers = runtime.NumCPU()
		imports    = make(map[string]bool)
		mx         = sync.Mutex{}
		errChan    = make(chan error, numWorkers)
	)

	// Define the worker routine.
	parseImport = func(path string) {
		defer wg.Done()

		// Check, if the closer is closing.
		if cl.IsClosing() {
			return
		}

		gPkg, importPaths, err := parseDir(filepath.Join(ctx.SourceDir, strings.TrimPrefix(path, goRootImport)))
		if err != nil {
			errChan <- err
			return
		}

		mx.Lock()
		if gPkg != nil && len(gPkg.Structs) > 0 {
			gt.Packages = append(gt.Packages, gPkg)
		}
		mx.Unlock()

		for _, path := range importPaths {
			// We are only interested in imported project packages.
			if !strings.HasPrefix(path, goRootImport) {
				continue
			}

			// Skip if already handled.
			mx.Lock()
			if imports[path] {
				mx.Unlock()
				continue
			}
			imports[path] = true
			mx.Unlock()

			// Start a new routine for each import path.
			wg.Add(1)
			go parseImport(path)
		}
	}

	// Start with the root import.
	wg.Add(1)
	go parseImport(goRootImport)

	// Close the closer if no routine is running anymore.
	go func() {
		wg.Wait()
		cl.Close()
	}()

	// Read potential errors from the error chan.
	select {
	case <-cl.ClosedChan():
		select {
		case err = <-errChan:
		default:
		}
	case err = <-errChan:
		cl.Close()
	}
	return
}

func parseGoMod(path string) (rootImport string, err error) {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return
	}

	lines := strings.Split(string(data), "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if !strings.HasPrefix(line, "module ") {
			continue
		}
		rootImport = strings.TrimSpace(strings.TrimPrefix(line, "module"))
		break
	}

	if rootImport == "" {
		err = errors.New("failed to extract module import path")
	}
	return
}

func parseDir(dir string) (gPkg *genPackage, imports []string, err error) {
	// Remove the generated go file if present.
	// This file might cause errors if it is out-of-date
	// and might stop the parsing process.
	genFilePath := filepath.Join(dir, genGoFilename)
	e, err := utils.Exists(genFilePath)
	if err != nil {
		return
	} else if e {
		err = os.Remove(genFilePath)
		if err != nil {
			return
		}
	}

	// The ast file set for the current package.
	fset := token.NewFileSet()

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
		err = fmt.Errorf("invalid package: multiple package definitions")
		return
	}

	// Obtain the single package.
	var pkgName string
	var pkg *ast.Package
	for n, p := range pkgs {
		pkgName = n
		pkg = p
		break
	}

	// Our parsed results for the package.
	gPkg = &genPackage{
		Dir:         dir,
		PackageName: pkgName,
	}

	// Parse all the go source files.
	for _, f := range pkg.Files {
		imports, err = parseFile(gPkg, fset, f)
		if err != nil {
			return
		}
	}

	return
}

func parseFile(gp *genPackage, fset *token.FileSet, f *ast.File) (imports []string, err error) {
	// Obtain all imports.
	imports = make([]string, len(f.Imports))
	for i, imp := range f.Imports {
		imports[i] = strings.Trim(imp.Path.Value, "\"")
	}

	// Search for struct definitions.
	for _, decl := range f.Decls {
		// Must be a type token.
		typeDecl, ok := decl.(*ast.GenDecl)
		if !ok || typeDecl.Tok != token.TYPE || len(typeDecl.Specs) == 0 {
			continue
		}

		typeSpec, ok := typeDecl.Specs[0].(*ast.TypeSpec)
		if !ok {
			continue
		}

		structDecl, ok := typeSpec.Type.(*ast.StructType)
		if !ok {
			continue
		}

		var (
			hasEmbeddedObject bool
			structName        = typeSpec.Name.Name
		)

		gs := &genStruct{
			Name:        structName,
			CBaseName:   cBasePrefix + "_" + utils.FirstCharToLower(gp.PackageName) + "_" + structName,
			CPPBaseName: cppBasePrefix + utils.FirstCharToUpper(gp.PackageName) + structName,
		}

		// Check all struct fields.
		for _, f := range structDecl.Fields.List {
			// If this field is an embedded type, then
			// check for the required embedded gml type.
			if len(f.Names) == 0 {
				se, ok := f.Type.(*ast.SelectorExpr)
				if !ok || se.Sel == nil {
					continue
				}

				ind, ok := se.X.(*ast.Ident)
				if !ok || ind.Name != "gml" {
					continue
				}

				name := se.Sel.Name
				if name == "Object" || name == "ListModel" {
					hasEmbeddedObject = true
				}
				if name == "ListModel" {
					gs.AdditionalType = "ListModel"
				}
				continue
			}

			// Check for the _ struct field.
			if len(f.Names) == 0 || f.Names[0].Name != "_" {
				continue
			}

			st, ok := f.Type.(*ast.StructType)
			if !ok {
				continue
			}

			err = parseUnderlineStruct(gs, fset, st)
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
			err = newParseError(fset, decl.Pos(), fmt.Errorf("invalid struct: gml.Object must be embedded"))
			return
		}

		gp.Structs = append(gp.Structs, gs)
	}

	return
}

func parseUnderlineStruct(gs *genStruct, fset *token.FileSet, st *ast.StructType) (err error) {
	for _, f := range st.Fields.List {
		// Ensure name is set.
		if len(f.Names) == 0 || f.Tag == nil {
			continue
		}

		// Extract the tag value and key.
		tagValue := strings.Trim(f.Tag.Value, "`")
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

		name := f.Names[0].Name
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

func parseSignal(gs *genStruct, fset *token.FileSet, f *ast.Field, name string) (err error) {
	// Must be a function.
	ft, ok := f.Type.(*ast.FuncType)
	if !ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: must be a function"))
	}

	// Ensure the function does not contain any return value.
	if ft.Results != nil && len(ft.Results.List) > 0 {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: must not contain a return value"))
	}

	signal := &genSignal{
		Name:    name,
		CPPName: utils.FirstCharToLower(name), // Qt signal names must be lower-case.
		Params:  make([]*genParam, 0, len(ft.Params.List)),
	}

	// Prepare the emit name.
	// Prefix with emit and ensure it is private or public as specified.
	if unicode.IsUpper(rune(signal.Name[0])) {
		signal.EmitName = "Emit" + signal.Name
	} else {
		signal.EmitName = "emit" + utils.FirstCharToUpper(signal.Name)
	}

	// Prepare all params.
	for _, p := range ft.Params.List {
		// Variadic functions are not supported.
		_, ok := p.Type.(*ast.Ellipsis)
		if ok {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: variadic functions are not supported"))
		}

		typeStr := goType(p.Type)

		// Ensure a parameter name is set.
		if len(p.Names) == 0 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: function parameter: name not set"))
		}

		for _, n := range p.Names {
			signal.Params = append(signal.Params, &genParam{
				Name:    n.Name,
				Type:    typeStr,
				CType:   goTypeToC(typeStr),
				CPPType: goTypeToCPP(typeStr),
			})
		}
	}

	gs.Signals = append(gs.Signals, signal)
	return
}

func parseSlot(gs *genStruct, fset *token.FileSet, f *ast.Field, name string) (err error) {
	// Must be a function.
	ft, ok := f.Type.(*ast.FuncType)
	if !ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot: must be a function"))
	}

	// Handle return values.
	var retType string
	if ft.Results != nil && len(ft.Results.List) > 0 {
		if len(ft.Results.List) > 1 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot: multiple return values are not supported"))
		}
		retType = goType(ft.Results.List[0].Type)
	}

	slot := &genSlot{
		Name:    name,
		CPPName: utils.FirstCharToLower(name), // Qt slot names must be lower-case.
		Params:  make([]*genParam, 0, len(ft.Params.List)),
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
	for _, p := range ft.Params.List {
		// Variadic functions are not supported.
		_, ok := p.Type.(*ast.Ellipsis)
		if ok {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot: variadic functions are not supported"))
		}

		typeStr := goType(p.Type)

		// Ensure a parameter name is set.
		if len(p.Names) == 0 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot: function parameter: name not set"))
		}

		for _, n := range p.Names {
			slot.Params = append(slot.Params, &genParam{
				Name:    n.Name,
				Type:    typeStr,
				CType:   goTypeToC(typeStr),
				CGoType: goTypeToCGo(typeStr),
				CPPType: goTypeToCPP(typeStr),
			})
		}
	}

	gs.Slots = append(gs.Slots, slot)
	return
}

func parseProperty(gs *genStruct, fset *token.FileSet, f *ast.Field, name string, silent bool) (err error) {
	// Ensure it is not a function signature.
	_, ok := f.Type.(*ast.FuncType)
	if ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid property: must be a variable"))
	}

	typeStr := goType(f.Type)
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
func goType(t ast.Expr) string {
	// Check if basic type.
	ident, ok := t.(*ast.Ident)
	if ok {
		return ident.Name
	}

	return "interface{}"
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
