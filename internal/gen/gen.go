/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package gen

import (
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"log"
	"strings"
)

func Gen() {
	fset := token.NewFileSet()
	f, err := parser.ParseFile(fset, "_test.go", nil, 0)
	if err != nil {
		log.Fatalln(err)
	}

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

			handleInlineStruct(st)
		}
	}
}

func handleInlineStruct(st *ast.StructType) {
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
			handleSignal(f, name)
		case "slot":
		case "property":
		default:
			continue
		}
	}
}

func handleSignal(f *ast.Field, name string) {
	ft, ok := f.Type.(*ast.FuncType)
	if !ok {
		return
	}

	fmt.Println("signal:", name, ft.Params.List[0].Names[0].Name)

	for _, p := range ft.Params.List {
		i, ok := p.Type.(*ast.Ident)
		if !ok {
			// TODO: error
			return
		}

		fmt.Println(i.Name)
	}
}
