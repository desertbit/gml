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
	"io/ioutil"
	"os"
	"path/filepath"
)

const (
	genGoFilename = "gml_gen.go"
)

type genTargets struct {
	Packages []*genPackage
}

type genPackage struct {
	PackageName string
	Dir         string
	Structs     []*genStruct
}

type genStruct struct {
	Name        string
	CBaseName   string
	CPPBaseName string
	Signals     []*genSignal
	Slots       []*genSlot
}

type genSignal struct {
	Name     string
	EmitName string
	CPPName  string
	Params   []*genParam
}

type genSlot struct {
	Name    string
	CPPName string
	Params  []*genParam
}

type genParam struct {
	Name    string
	Type    string
	CType   string
	CGoType string
	CPPType string
}

// TODO: make concurrent with multiple goroutines.
func generate(ctx *Context) (err error) {
	gt, err := parseDirRecursive(ctx.SourceDir)
	if err != nil {
		return
	}

	// Create dummies if not C & C++ files will be generated.
	if len(gt.Packages) == 0 {
		return generateDummyFiles(ctx)
	}

	err = generateCMainHeader(gt, ctx.CGenIncludeDir)
	if err != nil {
		return
	}

	for _, gp := range gt.Packages {
		err = generateGoFile(gp)
		if err != nil {
			return
		}

		err = generateCHeaderFile(gp, ctx.CGenDir)
		if err != nil {
			return
		}

		err = generateCPPHeaderFile(gp, ctx.CPPGenDir)
		if err != nil {
			return
		}

		err = generateCPPSourceFile(gp, ctx.CPPGenDir)
		if err != nil {
			return
		}
	}
	return
}

// Create dummy files, because otherwise make fill fail if there are no sources files present.
// QMake is configured with a *.cpp & *.h
func generateDummyFiles(ctx *Context) (err error) {
	err = ioutil.WriteFile(filepath.Join(ctx.CGenDir, "_dummy.h"), []byte("// Dummy File"), 0755)
	if err != nil {
		return
	}

	err = ioutil.WriteFile(filepath.Join(ctx.CPPGenDir, "_dummy.h"), []byte("// Dummy File"), 0755)
	if err != nil {
		return
	}

	err = ioutil.WriteFile(filepath.Join(ctx.CPPGenDir, "_dummy.cpp"), []byte("// Dummy File"), 0755)
	return
}

// This shoult be in a separate directory, so no unnecessary files are in the global include dir.
func generateCMainHeader(gt *genTargets, genDir string) (err error) {
	filename := filepath.Join(genDir, "gml_gen.h")

	// Create the file.
	f, err := os.Create(filename)
	if err != nil {
		return
	}
	defer func() {
		derr := f.Close()
		if derr != nil && err == nil {
			err = derr
		}
	}()

	return cMainHeaderTmpl.Execute(f, gt)
}

func generateGoFile(gp *genPackage) (err error) {
	filename := filepath.Join(gp.Dir, genGoFilename)

	// Create the file.
	f, err := os.Create(filename)
	if err != nil {
		return
	}
	defer func() {
		derr := f.Close()
		if derr != nil && err == nil {
			err = derr
		}
	}()

	return goTmpl.Execute(f, gp)
}

// TODO: add package prefix!
func generateCHeaderFile(gp *genPackage, genDir string) (err error) {
	filename := filepath.Join(genDir, gp.PackageName+".h")

	// Create the file.
	f, err := os.Create(filename)
	if err != nil {
		return
	}
	defer func() {
		derr := f.Close()
		if derr != nil && err == nil {
			err = derr
		}
	}()

	return cHeaderTmpl.Execute(f, gp)
}

// TODO: add package prefix!
func generateCPPSourceFile(gp *genPackage, genDir string) (err error) {
	filename := filepath.Join(genDir, gp.PackageName+".cpp")

	// Create the file.
	f, err := os.Create(filename)
	if err != nil {
		return
	}
	defer func() {
		derr := f.Close()
		if derr != nil && err == nil {
			err = derr
		}
	}()

	return cppSourceTmpl.Execute(f, gp)
}

// TODO: add package prefix!
func generateCPPHeaderFile(gp *genPackage, genDir string) (err error) {
	filename := filepath.Join(genDir, gp.PackageName+".h")

	// Create the file.
	f, err := os.Create(filename)
	if err != nil {
		return
	}
	defer func() {
		derr := f.Close()
		if derr != nil && err == nil {
			err = derr
		}
	}()

	return cppHeaderTmpl.Execute(f, gp)
}
