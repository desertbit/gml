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

package utils

import (
	"errors"
	"fmt"
	"go/build"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

const (
	// TODO: maybe use reflect.TypeOf(*ctx).PkgPath() ?
	goImportPath = "github.com/desertbit/gml"
)

func FindModPath(dir string) (path string, err error) {
	for {
		path = filepath.Join(dir, "go.mod")
		if fi, err := os.Stat(path); err == nil && !fi.IsDir() {
			return path, nil
		}

		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
		dir = parent
	}

	return "", errors.New("go.mod not found")
}

func FindBindingPath(projectRootDir string) (path string, err error) {
	projectRootDir, err = filepath.Abs(projectRootDir)
	if err != nil {
		return
	}

	modPath, err := FindModPath(projectRootDir)
	if err != nil {
		return
	}

	// Obtain the import path including the version from the go.mod file.
	data, err := ioutil.ReadFile(modPath)
	if err != nil {
		return
	}

	lines := strings.Split(string(data), "\n")
	for _, line := range lines {
		if !strings.Contains(line, goImportPath) {
			continue
		}

		// Remove comments from the line first.
		pos := strings.Index(line, "//")
		if pos >= 0 {
			line = line[:pos]
		}

		fields := strings.Fields(strings.TrimPrefix(strings.TrimSpace(line), "require"))
		if len(fields) != 2 || fields[0] != goImportPath {
			continue
		}

		path = fields[0] + "@" + fields[1]
		break
	}

	if path == "" {
		err = fmt.Errorf("failed to find gml import in go.mod file")
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

	// Our final binding path.
	path = filepath.Join(goPath, "pkg", "mod", path, "internal", "binding")

	// Ensure it exists.
	e, err := Exists(path)
	if err != nil {
		return
	} else if !e {
		err = fmt.Errorf("gml binding path does not exists: '%s'", path)
		return
	}

	return
}
