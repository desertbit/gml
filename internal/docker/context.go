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

package docker

import (
	"fmt"
	"go/build"
	"os"
	"path/filepath"
	"strings"

	"github.com/desertbit/gml/internal/utils"
)

type Context struct {
	RootDir   string
	SourceDir string
	BuildDir  string
	DestDir   string

	BinName string
	GoPath  string

	CGoLDFLAGS string
	CGoCFLAGS  string
}

func newContext(rootDir, sourceDir, buildDir, destDir string) (ctx *Context, err error) {
	// Get absolute paths.
	rootDir, err = filepath.Abs(rootDir)
	if err != nil {
		return
	}
	destDir, err = filepath.Abs(destDir)
	if err != nil {
		return
	}

	// Source and build dir are relative to the root dir.
	// Construct the absolute paths now.
	sourceDir, err = filepath.Abs(filepath.Join(rootDir, sourceDir))
	if err != nil {
		return
	}
	buildDir, err = filepath.Abs(filepath.Join(rootDir, buildDir))
	if err != nil {
		return
	}

	// Obtain the current GOPATH.
	goPathEnv := os.Getenv("GOPATH")
	if goPathEnv == "" {
		goPathEnv = build.Default.GOPATH
	}
	goPaths := strings.Split(goPathEnv, ":")
	if len(goPaths) == 0 {
		err = fmt.Errorf("invalid GOPATH")
		return
	}
	goPath := goPaths[0]

	// Set the bin name.
	binName := filepath.Base(sourceDir)
	if binName == "" || binName == "." {
		binName = "gml-app"
	}

	// Obtain the cgo flags from the current environment.
	osEnv := os.Environ()
	cgoLDFLAGS := "CGO_LDFLAGS="
	cgoCFLAGS := "CGO_CFLAGS="
	for _, e := range osEnv {
		if strings.HasPrefix(e, "CGO_LDFLAGS=") {
			cgoLDFLAGS = e
		} else if strings.HasPrefix(e, "CGO_CFLAGS=") {
			cgoCFLAGS = e
		}
	}

	ctx = &Context{
		RootDir:    rootDir,
		SourceDir:  sourceDir,
		BuildDir:   buildDir,
		DestDir:    destDir,
		BinName:    binName,
		GoPath:     goPath,
		CGoLDFLAGS: cgoLDFLAGS,
		CGoCFLAGS:  cgoCFLAGS,
	}

	err = ctx.createDirsIfNotExists()
	if err != nil {
		return
	}

	err = ctx.checkForRequiredDirs()
	return
}

func (c *Context) createDirsIfNotExists() (err error) {
	dirs := []string{
		c.BuildDir,
		c.DestDir,
		c.GoPath,
	}

	for _, d := range dirs {
		err = os.MkdirAll(d, 0755)
		if err != nil {
			return
		}
	}
	return
}

func (c *Context) checkForRequiredDirs() (err error) {
	dirs := []string{
		c.SourceDir,
	}

	for _, d := range dirs {
		e, err := utils.Exists(d)
		if err != nil {
			return err
		} else if !e {
			return fmt.Errorf("required directory does not exists: '%s'", d)
		}
	}
	return
}
