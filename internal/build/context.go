/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package build

import (
	"fmt"
	"go/build"
	"os"
	"path/filepath"
	"reflect"

	"github.com/desertbit/gml/internal/utils"
)

const (
	staticLibName = "libgml.a"
	proFileName   = "gml.pro"
)

type Context struct {
	SourceDir string
	BuildDir  string
	DestDir   string

	GMLBindingDir string

	OutputFile    string
	StaticLibPath string
	QtProFile     string
}

func newContext(sourceDir, buildDir, destDir string) (ctx *Context, err error) {
	// Get absolute paths.
	sourceDir, err = filepath.Abs(sourceDir)
	if err != nil {
		return nil, err
	}
	buildDir, err = filepath.Abs(buildDir)
	if err != nil {
		return nil, err
	}
	destDir, err = filepath.Abs(destDir)
	if err != nil {
		return nil, err
	}

	ctx = &Context{
		SourceDir:     sourceDir,
		BuildDir:      buildDir,
		DestDir:       destDir,
		OutputFile:    filepath.Join(destDir, filepath.Base(sourceDir)),
		StaticLibPath: filepath.Join(buildDir, staticLibName),
		QtProFile:     filepath.Join(buildDir, proFileName),
	}

	// Obtain the current GOPATH.
	gopath := os.Getenv("GOPATH")
	if gopath == "" {
		gopath = build.Default.GOPATH
	}

	// Obtain the current import path.
	ctx.GMLBindingDir = filepath.Join(gopath, "src", filepath.Dir(reflect.TypeOf(*ctx).PkgPath()), "binding")

	err = ctx.checkForRequiredDirs()
	if err != nil {
		return
	}

	err = ctx.createDirsIfNotExists()
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
