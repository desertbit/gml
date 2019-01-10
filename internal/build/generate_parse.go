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
)

type genTargets struct {
	Signals []*genSignal
}

type genSignal struct {
	Filename string
	Name     string
	Params   []*genParam
}

type genParam struct {
	Name string
	Type string
}

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
	fset := token.NewFileSet()
	pkgs, err := parser.ParseDir(fset, dir, nil, 0)
	if err != nil {
		return
	}

	for _, pkg := range pkgs {
		for _, f := range pkg.Files {
			err = parseFile(gt, fset, f)
			if err != nil {
				return
			}
		}
	}
	return
}

func parseFile(gt *genTargets, fset *token.FileSet, f *ast.File) (err error) {
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

		for _, f := range structDecl.Fields.List {
			// Variable name must be "_".
			if len(f.Names) == 0 || f.Names[0].Name != "_" {
				continue
			}

			st, ok := f.Type.(*ast.StructType)
			if !ok {
				continue
			}

			err = parseInlineStruct(gt, fset, st)
			if err != nil {
				return
			}
		}
	}

	return
}

func parseInlineStruct(gt *genTargets, fset *token.FileSet, st *ast.StructType) (err error) {
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

		switch tagValue {
		case "signal":
			err = parseSignal(gt, fset, f, name)
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

func parseSignal(gt *genTargets, fset *token.FileSet, f *ast.Field, name string) (err error) {
	// Must be a function/
	ft, ok := f.Type.(*ast.FuncType)
	if !ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: must be a function"))
	}

	signal := &genSignal{
		Filename: fset.Position(f.Pos()).Filename,
		Name:     name,
		Params:   make([]*genParam, len(ft.Params.List)),
	}

	for i, p := range ft.Params.List {
		ident, ok := p.Type.(*ast.Ident)
		if !ok {
			return newParseError(fset, f.Pos(), fmt.Errorf("failed to assert to *ast.Ident"))
		}

		// Ensure names is not empty.
		if len(p.Names) == 0 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal function parameter: names is empty"))
		}

		signal.Params[i] = &genParam{
			Name: p.Names[0].Name,
			Type: ident.Name,
		}
	}

	gt.Signals = append(gt.Signals, signal)
	return
}

func newParseError(fset *token.FileSet, p token.Pos, err error) error {
	pos := fset.Position(p)
	return fmt.Errorf("%s: line %v: %v", pos.Filename, pos.Line, err)
}
