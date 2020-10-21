// Copyright (c) 2020 Roland Singer, Sebastian Borchers
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package codegen

import (
	"io/ioutil"
	"path/filepath"

	"github.com/desertbit/closer/v3"
)

const (
	filePerm      = 0755
	genGoFilename = "gml_gen.go"
)

func Generate(cl closer.Closer, srcDir, cGenDir, cGenIncludeDir, cppGenDir string) (err error) {
	// Parse the source directory.
	pkgs, err := parseDir(cl, srcDir)
	if err != nil {
		return
	}

	// Create dummies if no C & C++ files will be generated.
	if len(pkgs) == 0 {
		return generateDummyFiles(cGenDir, cppGenDir)
	}

	gen := newGenerator()

	err = gen.cMainHeaderFile(pkgs, cGenIncludeDir)
	if err != nil {
		return
	}

	for _, pkg := range pkgs {
		err = gen.goFile(filepath.Join(pkg.Dir, genGoFilename), pkg)
		if err != nil {
			return
		}

		err = gen.cHeaderFile(filepath.Join(cGenDir, pkg.PackageName+".h"), pkg)
		if err != nil {
			return
		}

		err = gen.cppHeaderFile(filepath.Join(cppGenDir, pkg.PackageName+".h"), pkg)
		if err != nil {
			return
		}

		err = gen.cppSourceFile(filepath.Join(cppGenDir, pkg.PackageName+".cpp"), pkg)
		if err != nil {
			return
		}
	}
	return
}

// Create dummy files, because otherwise make fill fail if there are no sources files present.
// QMake is configured with a *.cpp & *.h
// TODO: Does something change here with cmake?
func generateDummyFiles(cGenDir, cppGenDir string) (err error) {
	err = ioutil.WriteFile(filepath.Join(cGenDir, "_dummy.h"), []byte("// Dummy File"), filePerm)
	if err != nil {
		return
	}

	err = ioutil.WriteFile(filepath.Join(cppGenDir, "_dummy.h"), []byte("// Dummy File"), filePerm)
	if err != nil {
		return
	}

	return ioutil.WriteFile(filepath.Join(cppGenDir, "_dummy.cpp"), []byte("// Dummy File"), filePerm)
}
