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

package main

import (
	"github.com/desertbit/gml/internal/build"
	"github.com/desertbit/gml/internal/docker"
	"github.com/desertbit/grumble"
)

func init() {
	BuildCmd := &grumble.Command{
		Name: "build",
		Help: "build a gml project",
		Flags: func(f *grumble.Flags) {
			f.Bool("c", "clean", false, "clean build files first")
			f.BoolL("no-strip", false, "don't strip the final binary")
			f.BoolL("debug", false, "build a debug binary (disables strip)")
			f.BoolL("race", false, "enable data race detection")
			f.StringL("buildvcs", "auto", "value of go build -buildvcs flag")
			f.String("s", "source-dir", "./", "source directorty")
			f.String("b", "build-dir", "./build", "build directorty")
			f.String("d", "dest-dir", "./", "destination directorty")
			f.StringL("go-mod-file-path", "", "The path to the go.mod file. Defaults to <source-dir>/go.mod")
			f.String("t", "tags", "", "go build tags")
			f.String("m", "qt-modules", "", "comma separated list of qt modules added to the project")
		},
		Run: runBuild,
	}
	App.AddCommand(BuildCmd)

	BuildCmd.AddCommand(&grumble.Command{
		Name: "docker",
		Help: "build a gml project with docker",
		Flags: func(f *grumble.Flags) {
			// TODO: Copied from parent command because of grumble change with flag handling
			f.Bool("c", "clean", false, "clean build files first")
			f.BoolL("no-strip", false, "don't strip the final binary")
			f.BoolL("debug", false, "build a debug binary (disables strip)")
			f.BoolL("race", false, "enable data race detection")
			f.StringL("buildvcs", "auto", "value of go build -buildvcs flag")
			f.String("s", "source-dir", "./", "source directorty")
			f.String("b", "build-dir", "./build", "build directorty")
			f.String("d", "dest-dir", "./", "destination directorty")
			f.StringL("go-mod-file-path", "", "The path to the go.mod file. Defaults to <source-dir>/go.mod")
			f.String("t", "tags", "", "go build tags")
			f.String("m", "qt-modules", "", "comma separated list of qt modules added to the project")

			f.BoolL("custom", false, "use a custom docker image")
			f.StringL("args", "", "pass additional arguments to docker")
		},
		Args: func(a *grumble.Args) {
			a.String("container", "the name of the container used for building")
		},
		Run: runBuildDocker,
	})
}

func runBuild(c *grumble.Context) error {
	return build.Build(
		c.Flags.String("source-dir"),
		c.Flags.String("build-dir"),
		c.Flags.String("dest-dir"),
		c.Flags.String("go-mod-file-path"),
		c.Flags.String("qt-modules"),
		c.Flags.Bool("clean"),
		c.Flags.Bool("no-strip"),
		c.Flags.Bool("debug"),
		c.Flags.Bool("race"),
		c.Flags.String("tags"),
		c.Flags.String("buildvcs"),
	)
}

func runBuildDocker(c *grumble.Context) error {
	return docker.Build(
		c.Args.String("container"),
		c.Flags.String("source-dir"),
		c.Flags.String("build-dir"),
		c.Flags.String("dest-dir"),
		c.Flags.String("go-mod-file-path"),
		c.Flags.String("qt-modules"),
		c.Flags.Bool("clean"),
		c.Flags.Bool("no-strip"),
		c.Flags.Bool("debug"),
		c.Flags.Bool("race"),
		c.Flags.Bool("custom"),
		c.Flags.String("tags"),
		c.Flags.String("args"),
		c.Flags.String("buildvcs"),
	)
}
