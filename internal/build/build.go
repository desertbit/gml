/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package build

import (
	"os"
	"os/exec"

	"github.com/desertbit/gml/internal/utils"
)

func Build(sourceDir, buildDir, destDir string) (err error) {
	ctx, err := newContext(sourceDir, buildDir, destDir)
	if err != nil {
		return
	}

	// TODO: add clean flag or command.

	// Prepare the qt project.
	err = prepareQtProject(ctx)
	if err != nil {
		return
	}

	// Prepare the c source files.
	err = prepareCSource(ctx)
	if err != nil {
		return
	}

	// Build the static C lib.
	err = buildCLib(ctx)
	if err != nil {
		return
	}

	// Run go build.
	err = buildGo(ctx)
	if err != nil {
		return
	}

	// TODO: make this optional.
	// Finally strip the binary.
	err = stripBinary(ctx)
	if err != nil {
		return
	}

	return
}

func prepareCSource(ctx *Context) (err error) {
	// TODO: generate all files

	return
}

func buildCLib(ctx *Context) (err error) {
	err = utils.RunCommand(ctx.BuildDir, "qmake")
	if err != nil {
		return
	}

	return utils.RunCommand(ctx.BuildDir, "make")
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

	cmd := exec.Command("go", "build", "-o", ctx.OutputFile)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Dir = ctx.SourceDir
	cmd.Env = []string{
		"CGO_LDFLAGS=" + ctx.StaticLibPath,
	}

	// Append the current environment variables.
	cmd.Env = append(cmd.Env, os.Environ()...)

	return cmd.Run()
}

func stripBinary(ctx *Context) (err error) {
	return utils.RunCommand(ctx.DestDir, "strip", ctx.OutputFile)
}
