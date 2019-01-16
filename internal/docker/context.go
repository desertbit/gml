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
	Container string
	SourceDir string
	BuildDir  string
	DestDir   string

	GoPath     string
	ImportPath string
}

func newContext(container, sourceDir, buildDir, destDir string) (ctx *Context, err error) {
	// Get absolute paths.
	sourceDir, err = filepath.Abs(sourceDir)
	if err != nil {
		return
	}
	buildDir, err = filepath.Abs(buildDir)
	if err != nil {
		return
	}
	destDir, err = filepath.Abs(destDir)
	if err != nil {
		return
	}

	// Obtain the current GOPATH.
	goPath := os.Getenv("GOPATH")
	if goPath == "" {
		goPath = build.Default.GOPATH
	}
	goPath, err = filepath.Abs(goPath)
	if err != nil {
		return
	}

	// Must be within the GoPath.
	if !strings.HasPrefix(sourceDir, goPath) {
		err = fmt.Errorf("source directory is not within the GoPath")
		return
	}
	importPath := filepath.Clean("/" + strings.TrimPrefix(sourceDir, goPath))

	ctx = &Context{
		Container:  container,
		SourceDir:  sourceDir,
		BuildDir:   buildDir,
		DestDir:    destDir,
		GoPath:     goPath,
		ImportPath: importPath,
	}

	// Check if the container name is valid.
	switch container {
	case "linux":
	default:
		err = fmt.Errorf("invalid container: %s", container)
		return
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
