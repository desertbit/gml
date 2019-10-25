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
	"fmt"

	"github.com/desertbit/gml/internal/build"
	"github.com/desertbit/gml/internal/docker"
	"github.com/desertbit/grumble"
)

func init() {
	BuildCmd := &grumble.Command{
		Name:      "build",
		Help:      "build a gml project",
		AllowArgs: false,
		Flags: func(f *grumble.Flags) {
			f.Bool("c", "clean", false, "clean build files first")
			f.BoolL("no-strip", false, "don't strip the final binary")
			f.String("s", "source-dir", "./", "source directorty")
			f.String("b", "build-dir", "./build", "build directorty")
			f.String("d", "dest-dir", "./", "destination directorty")
			f.String("t", "tags", "", "go build tags")
		},
		Run: runBuild,
	}
	App.AddCommand(BuildCmd)

	BuildCmd.AddCommand(&grumble.Command{
		Name:      "docker",
		Help:      "build a gml project with docker",
		AllowArgs: true,
		Flags: func(f *grumble.Flags) {
			f.BoolL("custom", false, "use a custom docker image")
		},
		Run: runBuildDocker,
	})
}

func runBuild(c *grumble.Context) error {
	return build.Build(
		c.Flags.String("source-dir"),
		c.Flags.String("build-dir"),
		c.Flags.String("dest-dir"),
		c.Flags.Bool("clean"),
		c.Flags.Bool("no-strip"),
		c.Flags.String("tags"),
	)
}

func runBuildDocker(c *grumble.Context) error {
	if len(c.Args) == 0 {
		return fmt.Errorf("invalid args: pass a docker container")
	} else if len(c.Args) > 1 {
		return fmt.Errorf("too many args")
	}

	return docker.Build(
		c.Args[0],
		c.Flags.String("source-dir"),
		c.Flags.String("build-dir"),
		c.Flags.String("dest-dir"),
		c.Flags.Bool("clean"),
		c.Flags.Bool("no-strip"),
		c.Flags.Bool("custom"),
		c.Flags.String("tags"),
	)
}
