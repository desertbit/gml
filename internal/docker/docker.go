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
	"os"
	"os/exec"
	"os/user"
	"path/filepath"

	"github.com/desertbit/gml/internal/utils"
	"golang.org/x/crypto/ssh/terminal"
)

const (
	containerPrefix = "desertbit/gml:"
)

var (
	containers = []string{
		"linux",
	}
)

func Containers() []string {
	return containers
}

func Build(
	container string,
	sourceDir, buildDir, destDir string,
	clean, noStrip bool,
) (err error) {
	ctx, err := newContext(sourceDir, buildDir, destDir)
	if err != nil {
		return
	}

	err = checkIfValidContainer(container)
	if err != nil {
		return
	}

	utils.PrintColorln("> docker build: " + container)

	user, err := user.Current()
	if err != nil {
		return
	}

	// Only add the -t docker flag if this is a TTY.
	var ttyArg string
	if terminal.IsTerminal(int(os.Stdout.Fd())) {
		ttyArg = "t"
	}

	args := []string{
		"run", "--rm", "-i" + ttyArg,
		"-e", "UID=" + user.Uid,
		"-e", "GID=" + user.Gid,
		"-v", ctx.GoPath + "/src:/work/src",
		"-v", ctx.BuildDir + ":/work/pkg",
		"-v", ctx.DestDir + ":/work/bin",
		containerPrefix + container,
		"gml", "build",
		"--source-dir", filepath.Join("/work", ctx.ImportPath),
		"--build-dir", "/work/pkg/gml-build",
		"--dest-dir", "/work/bin",
	}

	if clean {
		args = append(args, "--clean")
	}
	if noStrip {
		args = append(args, "--no-strip")
	}

	c := exec.Command("docker", args...)
	c.Dir = ctx.BuildDir
	c.Stderr = os.Stderr
	c.Stdout = os.Stdout
	c.Stdin = os.Stdin

	return c.Run()
}

func Pull(container string) (err error) {
	err = checkIfValidContainer(container)
	if err != nil {
		return
	}

	err = utils.RunCommand(
		os.Environ(), "",
		"docker", "pull", containerPrefix+container,
	)
	return
}

func checkIfValidContainer(container string) error {
	for _, c := range containers {
		if c == container {
			return nil
		}
	}
	return fmt.Errorf("invalid container: %s", container)
}
