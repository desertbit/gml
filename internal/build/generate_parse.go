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

	"github.com/desertbit/gml/internal/utils"
)

const (
	cBasePrefix   = "gml_gen_"
	cppBasePrefix = "GMLGen"
)

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

	// Actually there should be only one package in the map,
	// if the go source is valid and correct.
	for pkgName, pkg := range pkgs {
		// Set the package name.
		gp.PackageName = pkgName

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

		structName := typeSpec.Name.Name
		gs := &genStruct{
			Name:        structName,
			CBaseName:   cBasePrefix + structName,
			CPPBaseName: cppBasePrefix + structName,
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
		if len(gs.Signals) > 0 || len(gs.Slots) > 0 { // TODO: add slots & properties
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
			err = parseSlot(gs, fset, f, name)
			if err != nil {
				return
			}
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

	for _, p := range ft.Params.List {
		typeStr := getTypeString(p.Type)

		// Ensure a parameter name is set.
		if len(p.Names) == 0 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid signal function parameter: name not set"))
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
	// Must be a function/
	ft, ok := f.Type.(*ast.FuncType)
	if !ok {
		return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot: must be a function"))
	}

	// TODO: Handle return types!

	slot := &genSlot{
		Name:    name,
		CPPName: utils.FirstCharToLower(name), // Qt slot names must be lower-case.
		Params:  make([]*genParam, 0, len(ft.Params.List)),
	}

	for _, p := range ft.Params.List {
		typeStr := getTypeString(p.Type)

		// Ensure a parameter name is set.
		if len(p.Names) == 0 {
			return newParseError(fset, f.Pos(), fmt.Errorf("invalid slot function parameter: name not set"))
		}

		for _, n := range p.Names {
			slot.Params = append(slot.Params, &genParam{
				Name:    n.Name,
				Type:    typeStr,
				CType:   goTypeToC(typeStr),
				CPPType: goTypeToCPP(typeStr),
			})
		}
	}

	gs.Slots = append(gs.Slots, slot)
	return
}

// Returns "interface{}" if unknown.
func getTypeString(t ast.Expr) string {
	// Check if basic type.
	ident, ok := t.(*ast.Ident)
	if ok {
		return ident.Name
	}

	// Not required, because QByteArray is not supported by QML.
	// check if slice
	/*a, ok := t.(*ast.ArrayType)
	if ok && a.Len == nil {
		// Check if basic type is within the slice.
		ident, ok := a.Elt.(*ast.Ident)
		if ok {
			return "[]" + ident.Name
		}
	}*/

	return "interface{}"
}

func newParseError(fset *token.FileSet, p token.Pos, err error) error {
	pos := fset.Position(p)
	return fmt.Errorf("%s: line %v: %v", pos.Filename, pos.Line, err)
}

func goTypeToC(t string) string {
	switch t {
	case "bool":
		return "uint8_t"
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
		return "uint8_t"
	case "int16":
		return "int16_t"
	case "uint16":
		return "uint16_t"
	case "int32":
		return "int32_t"
	case "uint32":
		return "uint32_t"
	case "int64":
		return "int64_t"
	case "uint64":
		return "uint64_t"

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
