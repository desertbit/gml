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
	"runtime"

	"github.com/desertbit/gml/internal/utils"
)

const (
	staticLibName      = "libgml.a"
	proFileName        = "gml.pro"
	cGenDirName        = "gen_c"
	cGenIncludeDirName = "include"
	cppGenDirName      = "gen_cpp"
)

type Context struct {
	SourceDir string
	BuildDir  string
	DestDir   string

	GMLBindingDir        string
	GMLBindingHeadersDir string
	GMLBindingSourcesDir string

	CGenDir        string
	CGenIncludeDir string
	CPPGenDir      string

	OutputFile    string
	StaticLibPath string
	QtProFile     string
}

func newContext(sourceDir, buildDir, destDir string, clean bool) (ctx *Context, err error) {
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

	cGenDir := filepath.Join(buildDir, cGenDirName)

	ctx = &Context{
		SourceDir:      sourceDir,
		BuildDir:       buildDir,
		DestDir:        destDir,
		CGenDir:        cGenDir,
		CGenIncludeDir: filepath.Join(cGenDir, cGenIncludeDirName),
		CPPGenDir:      filepath.Join(buildDir, cppGenDirName),
		OutputFile:     filepath.Join(destDir, filepath.Base(sourceDir)),
		StaticLibPath:  filepath.Join(buildDir, staticLibName),
		QtProFile:      filepath.Join(buildDir, proFileName),
	}

	// Obtain the current GOPATH.
	gopath := os.Getenv("GOPATH")
	if gopath == "" {
		gopath = build.Default.GOPATH
	}

	// Obtain the current import path.
	ctx.GMLBindingDir = filepath.Join(gopath, "src", filepath.Dir(reflect.TypeOf(*ctx).PkgPath()), "binding")
	ctx.GMLBindingHeadersDir = filepath.Join(ctx.GMLBindingDir, "headers")
	ctx.GMLBindingSourcesDir = filepath.Join(ctx.GMLBindingDir, "sources")

	// Clean if set.
	if clean {
		err = ctx.cleanDirs()
		if err != nil {
			return
		}

	}

	err = ctx.cleanupDirs()
	if err != nil {
		return
	}

	err = ctx.checkForRequiredDirs()
	if err != nil {
		return
	}

	err = ctx.createDirsIfNotExists()
	return
}

func (c *Context) Env(optsEnv ...string) (env []string) {
	// Use current context environment variables.
	env = os.Environ()

	// Our default variables.
	env = append(env, []string{
		fmt.Sprintf("MAKEFLAGS=-j%v", runtime.NumCPU()+1),
		"CPPFLAGS=-D_FORTIFY_SOURCE=2",
		"CFLAGS=-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong -fno-plt",
		"CXXFLAGS=-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong -fno-plt",
		"LDFLAGS=-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now",
	}...)

	// Add the optional ones.
	if len(optsEnv) > 0 {
		env = append(env, optsEnv...)
	}

	return
}

func (c *Context) cleanDirs() (err error) {
	dirs := []string{
		c.BuildDir,
	}

	for _, d := range dirs {
		e, err := utils.Exists(d)
		if err != nil {
			return err
		} else if e {
			err = os.RemoveAll(c.BuildDir)
			if err != nil {
				return err
			}
		}
	}
	return
}

func (c *Context) cleanupDirs() (err error) {
	dirs := []string{
		c.CGenDir,
		c.CGenIncludeDir,
		c.CPPGenDir,
	}

	for _, d := range dirs {
		e, err := utils.Exists(d)
		if err != nil {
			return err
		} else if e {
			err = os.RemoveAll(c.BuildDir)
			if err != nil {
				return err
			}
		}
	}
	return
}

func (c *Context) createDirsIfNotExists() (err error) {
	dirs := []string{
		c.BuildDir,
		c.DestDir,
		c.CGenDir,
		c.CGenIncludeDir,
		c.CPPGenDir,
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
