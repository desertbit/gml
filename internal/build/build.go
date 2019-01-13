/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package build

import (
	"os"

	"github.com/desertbit/gml/internal/utils"
)

func Build(sourceDir, buildDir, destDir string, clean, noStrip bool) (err error) {
	ctx, err := newContext(sourceDir, buildDir, destDir, clean)
	if err != nil {
		return
	}

	// Prepare the qt project.
	utils.PrintColorln("> preparing project")
	err = prepareQtProject(ctx)
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
	err = buildGo(ctx)
	if err != nil {
		return
	}

	// Finally strip the binary.
	if !noStrip {
		utils.PrintColorln("> stripping binary")
		err = stripBinary(ctx)
		if err != nil {
			return
		}
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

func buildGo(ctx *Context) (err error) {
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

	err = utils.RunCommand(
		ctx.Env(
			"CGO_LDFLAGS="+ctx.StaticLibPath,
			"CGO_CFLAGS=-I"+ctx.CGenIncludeDir+" -I"+ctx.GMLBindingHeadersDir,
		),
		ctx.SourceDir,
		"go", "build", "-o", ctx.OutputFile,
	)
	return
}

func stripBinary(ctx *Context) (err error) {
	return utils.RunCommand(ctx.Env(), ctx.DestDir, "strip", ctx.OutputFile)
}
