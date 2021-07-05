// Copyright (c) 2020 Roland Singer, Sebastian Borchers
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package codegen

import (
	"bufio"
	"errors"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"sync"
	"unicode"

	"github.com/desertbit/closer/v3"
)

const (
	skipPrefix    = "gml_gen_"
	cBasePrefix   = "gml_gen"
	cppBasePrefix = "GMLGen"
)

func parseDir(cl closer.Closer, dir string) (pkgs []*Package, err error) {
	// Remove the generated go file, if present.
	// This file might cause errors if it is out-of-date, stopping the parsing process.
	goGenFilePath := filepath.Join(dir, genGoFilename)
	err = os.Remove(goGenFilePath)
	if err != nil && !errors.Is(err, os.ErrNotExist) {
		return
	}

	// Find the go.mod file in the directory.
	goModPath, err := findGoMod(dir)
	if err != nil {
		return
	}

	// Parse the go.mod file to obtain the root import path.
	goModRoot, err := extractGoModRoot(goModPath)
	if err != nil {
		return
	}

	var (
		wg          sync.WaitGroup
		parseImport func(path string)

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

		// Parse the go code in this package.
		pkg, importPaths, err := parseGoPackage(filepath.Join(dir, strings.TrimPrefix(path, goModRoot)))
		if err != nil {
			errChan <- err
			return
		}

		mx.Lock()
		if pkg != nil && len(pkg.Structs) > 0 {
			pkgs = append(pkgs, pkg)
		}
		mx.Unlock()

		for _, path := range importPaths {
			// We are only interested in imported project packages.
			if !strings.HasPrefix(path, goModRoot) {
				continue
			}

			// Skip, if already handled.
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
	go parseImport(goModRoot)

	// Wait for the routines to finish.
	wg.Wait()

	// Read potential errors from the error chan.
	select {
	case err = <-errChan:
	default:
	}
	return
}

// findGoMod searches for a go.mod file in the given directory and returns
// its full path, if successful.
func findGoMod(dir string) (path string, err error) {
	const goMod = "go.mod"

	for {
		// Check, if the go.mod file exists in the current directory.
		path = filepath.Join(dir, goMod)
		if fi, err := os.Stat(path); err == nil && !fi.IsDir() {
			// Make path absolute.
			path, err = filepath.Abs(path)
			if err != nil {
				return "", err
			}
			return path, nil
		}

		// Continue search in the parent directory.
		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
		dir = parent
	}

	return "", fmt.Errorf("%s not found", goMod)
}

// extractGoModRoot parses the given go.mod file
func extractGoModRoot(goModPath string) (root string, err error) {
	// Open the go mod file for reading.
	f, err := os.Open(goModPath)
	if err != nil {
		return
	}
	defer f.Close()

	// Search line by line for the module directive.
	s := bufio.NewScanner(f)
	for s.Scan() {
		line := strings.TrimSpace(s.Text())
		if !strings.HasPrefix(line, "module ") {
			continue
		}
		root = strings.TrimSpace(strings.TrimPrefix(line, "module"))
		break
	}

	// If the scanner encountered an error, return it.
	err = s.Err()
	if err != nil {
		return
	}

	if root == "" {
		err = fmt.Errorf("failed to extract module root from '%s'", goModPath)
	}
	return
}

// parseGopackage codegens the given directory for go code and returns an abstract representation of the found package,
// as well as all imports of all combined files in it.
func parseGoPackage(dir string) (pkg *Package, imports []string, err error) {
	// The ast file set for the current package.
	fset := token.NewFileSet()

	// Parse go sources and skip gml_gen prefixed files.
	pkgs, err := parser.ParseDir(fset, dir, func(i os.FileInfo) bool { return !strings.HasPrefix(i.Name(), skipPrefix) }, 0)
	if err != nil {
		return
	}

	// There should be only one package in the map,
	// if the go source is valid and correct.
	if len(pkgs) == 0 {
		err = fmt.Errorf("'%s': no package definition found", dir)
		return
	} else if len(pkgs) > 1 {
		err = fmt.Errorf("'%s': multiple package definitions found", dir)
		return
	}

	// Obtain the single package.
	var name string
	var ap *ast.Package
	for n, p := range pkgs {
		name = n
		ap = p
		break
	}

	// Our parsed results for the package.
	pkg = &Package{
		Dir:         dir,
		PackageName: name,
	}

	// Parse all the go source files in the package.
	for _, f := range ap.Files {
		var imps []string
		imps, err = parseGoFile(pkg, fset, f)
		if err != nil {
			return
		}

		imports = append(imports, imps...)
	}

	return
}

// parseGoFile parses the given file and searches for any gml specific declarations that need to be
// added to our Package metatype.
// Examples for this are structs that embed gml types and/or define QML slots/signals/properties.
// In addition, all go imports of the file are returned.
func parseGoFile(pkg *Package, fset *token.FileSet, f *ast.File) (imports []string, err error) {
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

		// Create our struct metatype.
		str := &Struct{
			Name:        structName,
			CBaseName:   cBasePrefix + "_" + firstCharToLower(pkg.PackageName) + "_" + structName,
			CPPBaseName: cppBasePrefix + firstCharToUpper(pkg.PackageName) + structName,
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
					str.AdditionalType = "ListModel"
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

			err = parseGoUnderlineStruct(str, fset, st)
			if err != nil {
				return
			}
		}

		// Skip if the struct is empty.
		if len(str.Signals) == 0 && len(str.Slots) == 0 && len(str.Properties) == 0 {
			continue
		}

		// There must be one embedded gml.Object field.
		if !hasEmbeddedObject {
			err = newError(fset, decl.Pos(), fmt.Errorf("invalid struct: gml.Object must be embedded"))
			return
		}

		pkg.Structs = append(pkg.Structs, str)
	}

	return
}

// parseGoUnderlineStruct parses an anonymous struct, which may contain QML signal/slot/property
// declarations of gml. All findings are added to our Struct metatype.
func parseGoUnderlineStruct(s *Struct, fset *token.FileSet, st *ast.StructType) (err error) {
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
			err = parseSignal(s, fset, f, name)
			if err != nil {
				return
			}
		case "slot":
			err = parseSlot(s, fset, f, name)
			if err != nil {
				return
			}
		case "property,silent":
			silent = true
			fallthrough
		case "property":
			err = parseProperty(s, fset, f, name, silent)
			if err != nil {
				return
			}
		default:
			return newError(fset, f.Pos(), fmt.Errorf("invalid struct tag value: %v", tagValue))
		}
	}
	return
}

// parseSignal parses the current ast struct field as a QML signal declaration and adds its findings
// to the our Struct metatype.
func parseSignal(s *Struct, fset *token.FileSet, f *ast.Field, name string) (err error) {
	// Must be a function.
	ft, ok := f.Type.(*ast.FuncType)
	if !ok {
		return newError(fset, f.Pos(), fmt.Errorf("invalid signal: must be a function"))
	}

	// Ensure the function does not contain any return value.
	if ft.Results != nil && len(ft.Results.List) > 0 {
		return newError(fset, f.Pos(), fmt.Errorf("invalid signal: must not contain a return value"))
	}

	signal := &Signal{
		Name:    name,
		CPPName: firstCharToLower(name), // Qt signal names must be lower-case.
		Params:  make([]*Param, 0, len(ft.Params.List)),
	}

	// Prepare the emit name.
	// Prefix with emit and ensure it is private or public as specified.
	if unicode.IsUpper(rune(signal.Name[0])) {
		signal.EmitName = "Emit" + signal.Name
	} else {
		signal.EmitName = "emit" + firstCharToUpper(signal.Name)
	}

	// Prepare all params.
	for _, p := range ft.Params.List {
		// Variadic functions are not supported.
		_, ok := p.Type.(*ast.Ellipsis)
		if ok {
			return newError(fset, f.Pos(), fmt.Errorf("invalid signal: variadic functions are not supported"))
		}

		// Ensure a parameter name is set.
		if len(p.Names) == 0 {
			return newError(fset, f.Pos(), fmt.Errorf("invalid signal: function parameter: name not set"))
		}

		for _, n := range p.Names {
			signal.Params = append(signal.Params, &Param{
				Name: n.Name,
				Type: newTypeConverter(goType(p.Type)),
			})
		}
	}

	s.Signals = append(s.Signals, signal)
	return
}

// parseSlot parses the current ast struct field as a QML slot declaration and adds its findings
// to the our Struct metatype.
func parseSlot(gs *Struct, fset *token.FileSet, f *ast.Field, name string) (err error) {
	// Must be a function.
	ft, ok := f.Type.(*ast.FuncType)
	if !ok {
		return newError(fset, f.Pos(), fmt.Errorf("invalid slot: must be a function"))
	}

	slot := &Slot{
		Name:    name,
		CPPName: firstCharToLower(name), // Qt slot names must be lower-case.
		Params:  make([]*Param, 0, len(ft.Params.List)),
		NoRet:   true,
		RetType: voidTypeConverter,
	}

	// Handle return values.
	if ft.Results != nil && len(ft.Results.List) > 0 {
		if len(ft.Results.List) > 1 {
			return newError(fset, f.Pos(), fmt.Errorf("invalid slot: multiple return values are not supported"))
		}
		slot.NoRet = false
		slot.RetType = newTypeConverter(goType(ft.Results.List[0].Type))
	}

	// Prepare all params.
	for _, p := range ft.Params.List {
		// Variadic functions are not supported.
		_, ok := p.Type.(*ast.Ellipsis)
		if ok {
			return newError(fset, f.Pos(), fmt.Errorf("invalid slot: variadic functions are not supported"))
		}

		// Ensure a parameter name is set.
		if len(p.Names) == 0 {
			return newError(fset, f.Pos(), fmt.Errorf("invalid slot: function parameter: name not set"))
		}

		for _, n := range p.Names {
			slot.Params = append(slot.Params, &Param{
				Name: n.Name,
				Type: newTypeConverter(goType(p.Type)),
			})
		}
	}

	gs.Slots = append(gs.Slots, slot)
	return
}

// parseProperty parses the current ast struct field as a QML property declaration and adds its findings
// to the our Struct metatype.
func parseProperty(gs *Struct, fset *token.FileSet, f *ast.Field, name string, silent bool) (err error) {
	// Ensure it is not a function signature.
	_, ok := f.Type.(*ast.FuncType)
	if ok {
		return newError(fset, f.Pos(), fmt.Errorf("invalid property: must be a variable"))
	}

	privName := firstCharToLower(name)
	pubName := firstCharToUpper(name)

	var setName string
	if unicode.IsUpper(rune(name[0])) {
		setName = "Set" + pubName
	} else {
		setName = "set" + pubName
	}

	prop := &Property{
		Name:       name,
		PublicName: pubName,
		CPPName:    privName,
		SetName:    setName,

		Type: newTypeConverter(goType(f.Type)),

		Silent: silent,
	}

	gs.Properties = append(gs.Properties, prop)
	return
}

// goType extracts the go type from the given ast.Expr.
// Returns interface{} if unknown.
func goType(t ast.Expr) string {
	// Check if basic type.
	ident, ok := t.(*ast.Ident)
	if ok {
		return ident.Name
	}

	return "interface{}"
}

// newError returns an error with the current position and filename of the parser included.
func newError(fset *token.FileSet, p token.Pos, err error) error {
	pos := fset.Position(p)
	return fmt.Errorf("%s: line %v: %v", pos.Filename, pos.Line, err)
}

// firstCharToLower returns a new copy of s with its first char guaranteed to be a lowercase letter.
func firstCharToLower(s string) string {
	if len(s) == 0 {
		return ""
	}

	// Ensure first char is lower case.
	sr := []rune(s)
	sr[0] = unicode.ToLower(rune(sr[0]))
	return string(sr)
}

// firstCharToLower returns a new copy of s with its first char guaranteed to be an uppercase letter.
func firstCharToUpper(s string) string {
	if len(s) == 0 {
		return ""
	}

	// Ensure first char is lower case.
	sr := []rune(s)
	sr[0] = unicode.ToUpper(rune(sr[0]))
	return string(sr)
}
