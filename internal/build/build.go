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
	"go/build"
	"os"
	"strings"

	"github.com/desertbit/gml/internal/utils"
)

const (
	PostHookName = "GML_BUILD_POST_HOOKS"
)

func Build(sourceDir, buildDir, destDir, qtModules string, clean, noStrip, debugBuild, race bool, tags, buildvcs string) (err error) {
	// Force no strip if this is a debug build.
	if debugBuild {
		noStrip = true
	}

	// Convert the comma separated qt modules list to a whitespace separated one.
	qtModules = strings.Join(strings.Split(qtModules, ","), " ")

	ctx, err := newContext(sourceDir, buildDir, destDir, qtModules, clean, debugBuild)
	if err != nil {
		return
	}

	// Prepare the qt project.
	utils.PrintColorln("> preparing project")
	err = prepareQtProject(ctx)
	if err != nil {
		return
	}

	// Prepare the resources.
	utils.PrintColorln("> preparing resources")
	err = prepareResources(ctx)
	if err != nil {
		return
	}

	// Generate C, C++ and go files.
	utils.PrintColorln("> generating source files")
	err = generate(ctx)
	if err != nil {
		return
	}

	// Build the static C lib.
	utils.PrintColorln("> building C source")
	err = buildCLib(ctx)
	if err != nil {
		return
	}

	// Run go build.
	utils.PrintColorln("> building Go source")
	err = buildGo(ctx, tags, clean, noStrip, race, buildvcs)
	if err != nil {
		return
	}

	// Run post hooks if available.
	err = runPostHooks(ctx)
	if err != nil {
		return
	}

	return
}

func buildCLib(ctx *Context) (err error) {
	err = utils.RunCommand(ctx.Env(), ctx.BuildDir, "qmake")
	if err != nil {
		return
	}

	return utils.RunCommand(ctx.Env(), ctx.BuildDir, "make")
}

func buildGo(ctx *Context, tags string, clean, noStrip, race bool, buildvcs string) (err error) {
	// Delete the output binary to force relinking.
	// This is faster than building with the -a option.
	e, err := utils.Exists(ctx.OutputFile)
	if err != nil {
		return
	} else if e {
		err = os.Remove(ctx.OutputFile)
		if err != nil {
			return
		}
	}

	var (
		ldflags []string
		args    = []string{"build", "-o", ctx.OutputFile, "-buildvcs", buildvcs}
	)

	if clean {
		args = append(args, "-a")
	}
	if !noStrip {
		args = append(args, "-trimpath")
		ldflags = append(ldflags, "-s", "-w")
	}
	if ctx.DebugBuild {
		ldflags = append(ldflags, "-compressdwarf=false")
	}
	if race {
		args = append(args, "-race")
	}
	if utils.Verbose {
		args = append(args, "-v")
	}

	// Add the go build tags if defined.
	tags = strings.TrimSpace(tags)
	if len(tags) > 0 {
		args = append(args, "-tags", tags)
	}

	// Hide the terminal window on windows bullshit systems.
	if build.Default.GOOS == "windows" {
		ldflags = append(ldflags, "-H=windowsgui")
	}

	// Combine ldflags passed by arguments.
	if len(ldflags) > 0 {
		args = append(args, "-ldflags", strings.Join(ldflags, " "))
	}

	// Don't overwrite already set cgo flags.
	// Let's extend them.
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
	cgoLDFLAGS += " " + ctx.StaticLibPath
	cgoCFLAGS += " -I" + ctx.CGenIncludeDir + " -I" + ctx.GmlBindingHeadersDir

	env := ctx.Env(cgoLDFLAGS, cgoCFLAGS)
	if utils.Verbose {
		fmt.Println("build environment variables:", env)
	}

	err = utils.RunCommand(
		env,
		ctx.SourceDir,
		"go", args...,
	)
	return
}

func runPostHooks(ctx *Context) (err error) {
	var value string

	for _, e := range os.Environ() {
		pair := strings.Split(e, "=")
		if len(pair) != 2 || pair[0] != PostHookName {
			continue
		}
		value = pair[1]
		break
	}
	if value == "" {
		return
	}

	utils.PrintColorln("> running post hooks")

	scripts := strings.Split(value, ",")
	for _, script := range scripts {
		script = strings.TrimSpace(script)
		if script == "" {
			continue
		}

		err = utils.RunCommand(
			ctx.Env(
				"GML_SOURCE_DIR="+ctx.SourceDir,
				"GML_BUILD_DIR="+ctx.BuildDir,
				"GML_DEST_DIR="+ctx.DestDir,
				"GML_DEST_BINARY="+ctx.OutputFile,
			),
			ctx.DestDir,
			script,
		)
		if err != nil {
			return
		}
	}

	return
}
