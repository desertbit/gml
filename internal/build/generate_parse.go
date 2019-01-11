/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package build

import (
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"path/filepath"
	"strings"
	"unicode"
)

type genTargets struct {
	Packages []*genPackage
}

type genPackage struct {
	Name    string
	Dir     string
	Structs []*genStruct
}

type genStruct struct {
	Name    string
	Signals []*genSignal
}

type genSignal struct {
	Name   string
	CName  string // first letter is always lower case
	Params []*genParam
}

type genParam struct {
	Name string
	Type string
}

// TODO: make concurrent with multiple goroutines.
func parseDirRecursive(dir string) (gt *genTargets, err error) {
	gt = &genTargets{}

	// Walk through all directories and fill the slice.
	var dirs []string
	err = filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Skip files.
		if !info.IsDir() {
			return nil
		}
		dirName := info.Name()

		// Skip hidden filea and files starting with a "_".
		if strings.HasPrefix(dirName, ".") || strings.HasPrefix(dirName, "_") {
			return filepath.SkipDir
		}

		dirs = append(dirs, path)
		return nil
	})
	if err != nil {
		return
	}

	// Parse all directories.
	for _, dir := range dirs {
		err = parseDir(gt, dir)
		if err != nil {
			return
		}
	}
	return
}

func parseDir(gt *genTargets, dir string) (err error) {
	gp := &genPackage{
		Dir: dir,
	}

	fset := token.NewFileSet()
	pkgs, err := parser.ParseDir(fset, dir, nil, 0)
	if err != nil {
		return
	}

	for pkgName, pkg := range pkgs {
		// Set the package name.
		gp.Name = pkgName

		for _, f := range pkg.Files {
			err = parseFile(gp, fset, f)
			if err != nil {
				return
			}
		}
	}

	// Skip if the package is empty.
	if len(gp.Structs) > 0 {
		gt.Packages = append(gt.Packages, gp)
	}
	return
}

func parseFile(gp *genPackage, fset *token.FileSet, f *ast.File) (err error) {
	// Search for struct definitions.
	for _, decl := range f.Decls {
		// Must be a token: type
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

		gs := &genStruct{
			Name: typeSpec.Name.Name,
		}

		for _, f := range structDecl.Fields.List {
			// Variable name must be "_".
			if len(f.Names) == 0 || f.Names[0].Name != "_" {
				continue
			}

			st, ok := f.Type.(*ast.StructType)
			if !ok {
				continue
			}

			err = parseInlineStruct(gs, fset, st)
			if err != nil {
				return
			}
		}

		// Skip if the struct is empty.
		if len(gs.Signals) > 0 { // TODO: add slots & properties
			gp.Structs = append(gp.Structs, gs)
		}
	}

	return
}

func parseInlineStruct(gs *genStruct, fset *token.FileSet, st *ast.StructType) (err error) {
	for _, f := range st.Fields.List {
		// Ensure name is set.
		if len(f.Names) == 0 {
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

		switch tagValue {
		case "signal":
			err = parseSignal(gs, fset, f, name)
			if err != nil {
				return
			}
		case "slot":
			// TODO:
		case "property":
			// TODO:
		default:
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid struct tag value: %v", tagValue))
		}
	}

	return
}

func parseSignal(gs *genStruct, fset *token.FileSet, f *ast.Field, name string) (err error) {
	// Must be a function/
	ft, ok := f.Type.(*ast.FuncType)
	if !ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: must be a function"))
	}

	signal := &genSignal{
		Name:   name,
		Params: make([]*genParam, len(ft.Params.List)),
	}

	// Ensure first char is lower case.
	cNameR := []rune(name)
	cNameR[0] = unicode.ToLower(rune(cNameR[0]))
	signal.CName = string(cNameR)

	for i, p := range ft.Params.List {
		ident, ok := p.Type.(*ast.Ident)
		if !ok {
			return newParseError(fset, f.Pos(), fmt.Errorf("failed to assert to *ast.Ident"))
		}

		// Ensure a parameter name is set.
		if len(p.Names) == 0 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal function parameter: name not set"))
		}

		signal.Params[i] = &genParam{
			Name: p.Names[0].Name,
			Type: ident.Name,
		}
	}

	gs.Signals = append(gs.Signals, signal)
	return
}

func newParseError(fset *token.FileSet, p token.Pos, err error) error {
	pos := fset.Position(p)
	return fmt.Errorf("%s: line %v: %v", pos.Filename, pos.Line, err)
}
