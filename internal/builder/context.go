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
	"fmt"
	"path/filepath"
	"strings"
)

const (
	projectManifestName = "gml.yaml"
	buildManifestName   = "gml-build.yaml"

	staticLibName = "libgml.a"
)

type Context struct {
	Opts *Options
	PM   *ProjectManifest
	BM   *BuildManifest

	SourceDir string
	BuildDir  string
	BinDir    string

	// TODO:
	StaticLibPath string
	QtProFile     string
}

func newContext(sourceDir string, o Options) (ctx *Context, err error) {
	sourceDir, err := filepath.Abs(sourceDir)
	if err != nil {
		return
	}

	// Load the project manifest.
	pm := &ProjectManifest{}
	err = pm.Load(filepath.Join(sourceDir, projectManifestName))
	if err != nil {
		return
	}

	// Load the

	// Ensure required paths are set.
	// If left empty, they will be set to the current dir,
	// which is dangerous during a clean build.
	buildDir := strings.TrimSpace(o.BuildDir)
	if buildDir == "" {
		err = fmt.Errorf("build dir not set")
		return
	}
	binDir := strings.TrimSpace(o.BinDir)
	if binDir == "" {
		err = fmt.Errorf("bin dir not set")
		return
	}

	// Get absolute paths.
	sourceDir, err := filepath.Abs(o.SourceDir)
	if err != nil {
		return
	}
	buildDir, err = filepath.Abs(buildDir)
	if err != nil {
		return
	}
	binDir, err = filepath.Abs(binDir)
	if err != nil {
		return
	}

	// Our main builder context.
	ctx = &Context{
		Opts: o,

		SourceDir: o.SourceDir,
		BuildDir:  buildDir,
		BinDir:    o.BinDir,

		StaticLibPath: filepath.Join(o.BuildDir, staticLibName),
		QtProFile:     filepath.Join(o.BuildDir, proFileName),
	}

	// Force no strip if this is a debug build.
	if ctx.DebugBuild {
		ctx.NoStrip = true
	}
}
