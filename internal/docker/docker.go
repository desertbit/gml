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
	"strings"

	"github.com/desertbit/gml/internal/utils"
	"github.com/desertbit/go-shlex"
	"golang.org/x/crypto/ssh/terminal"
)

const (
	containerPrefix = "desertbit/gml:"
)

var (
	containers = []string{
		"linux",
		"windows_32_static",
		"windows_64_static",
		"windows_32_shared",
		"windows_64_shared",
	}
)

func Containers() []string {
	return containers
}

func Build(
	container string,
	rootDir, sourceDir, buildDir, destDir, qtModules string,
	clean, noStrip, debugBuild, race, customContainer bool,
	tags, dockerArgs, buildvcs string,
) (err error) {
	if !customContainer {
		err = checkIfValidContainer(container)
		if err != nil {
			return
		}
		container = containerPrefix + container
	}

	// Obtain the build architecture.
	var arch string
	pos := strings.Index(container, ":")
	if pos > 0 {
		arch = strings.TrimSpace(container[pos+1:])
	}

	ctx, err := newContext(
		rootDir, sourceDir,
		filepath.Join(buildDir, arch),
		filepath.Join(destDir, arch),
	)
	if err != nil {
		return
	}

	utils.PrintColorln("> docker build: " + container)

	usr, err := user.Current()
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
		"-e", "UID=" + usr.Uid,
		"-e", "GID=" + usr.Gid,
		"-e", "GOBIN=/work/bin",
		"-e", "GOPATH=/work/go",
		"-e", "GOCACHE=/work/build/go-cache",
		"-e", ctx.CGoLDFLAGS,
		"-e", ctx.CGoCFLAGS,
		"-v", ctx.GoPath + ":/work/go",
		"-v", ctx.RootDir + ":/work",
		"-v", ctx.SourceDir + ":/work/" + ctx.BinName,
		"-v", ctx.BuildDir + ":/work/build",
		"-v", ctx.DestDir + ":/work/bin",
	}

	// Add the custom docker arguments.
	dockerArgsSplit, err := shlex.Split(dockerArgs, true)
	if err != nil {
		err = fmt.Errorf("failed to parse custom docker arguments: %w", err)
		return
	}
	args = append(args, dockerArgsSplit...)

	// Container and gml command.
	args = append(args, container, "gml")

	if utils.Verbose {
		args = append(args, "-v")
	}

	args = append(args, "build",
		"--root-dir", "/work",
		"--source-dir", ctx.BinName,
		"--build-dir", "build/gml-build",
		"--dest-dir", "/work/bin",
		"--qt-modules", qtModules,
		"--buildvcs", buildvcs)

	if clean {
		args = append(args, "--clean")
	}
	if noStrip {
		args = append(args, "--no-strip")
	}
	if debugBuild {
		args = append(args, "--debug")
	}
	if race {
		args = append(args, "--race")
	}

	// Add the tags if defined.
	tags = strings.TrimSpace(tags)
	if len(tags) > 0 {
		args = append(args, "--tags", tags)
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

	c := exec.Command("docker", "pull", containerPrefix+container)
	c.Stderr = os.Stderr
	c.Stdout = os.Stdout

	return c.Run()
}

func checkIfValidContainer(container string) error {
	for _, c := range containers {
		if c == container {
			return nil
		}
	}
	return fmt.Errorf("invalid container: %s", container)
}
