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
	"strings"
)

func generate(ctx *Context) (err error) {
	// Parse all packages in the source directory.
	fset := token.NewFileSet()
	pkgs, err := parser.ParseDir(fset, ctx.SourceDir, nil, 0)
	if err != nil {
		return
	}

	for _, pkg := range pkgs {
		for _, f := range pkg.Files {
			err = parseFile(fset, f)
			if err != nil {
				return
			}
		}
	}
	return
}

func parseFile(fset *token.FileSet, f *ast.File) (err error) {
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

			err = handleInlineStruct(fset, st)
			if err != nil {
				return
			}
		}
	}

	return
}

func handleInlineStruct(fset *token.FileSet, st *ast.StructType) (err error) {
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
			err = handleSignal(fset, f, name)
			if err != nil {
				return
			}

		case "slot":
		case "property":
		default:
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid struct tag value: %v", tagValue))
		}
	}

	return
}

func handleSignal(fset *token.FileSet, f *ast.Field, name string) (err error) {
	// Must be a function/
	ft, ok := f.Type.(*ast.FuncType)
	if !ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal: must be a function"))
	}

	//fmt.Println("signal:", name, ft.Params.List[0].Names[0].Name)

	for _, p := range ft.Params.List {
		i, ok := p.Type.(*ast.Ident)
		if !ok {
			return newParseError(fset, f.Pos(), fmt.Errorf("failed to assert to *ast.Ident"))
		}

		fmt.Println(i.Name)
	}

	return
}

func newParseError(fset *token.FileSet, p token.Pos, err error) error {
	pos := fset.Position(p)
	return fmt.Errorf("%s: line %v: %v", pos.Filename, pos.Line, err)
}
