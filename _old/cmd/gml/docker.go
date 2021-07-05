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

	"github.com/desertbit/gml/internal/docker"
	"github.com/desertbit/grumble"
)

func init() {
	DockerCmd := &grumble.Command{
		Name:      "docker",
		Help:      "manage gml docker containers",
		AllowArgs: false,
		Run:       runDocker,
	}
	App.AddCommand(DockerCmd)

	DockerCmd.AddCommand(&grumble.Command{
		Name:      "pull",
		Help:      "pull latest docker container",
		AllowArgs: true,
		Run:       runDockerPull,
	})
}

func runDocker(c *grumble.Context) error {
	containers := docker.Containers()
	for _, c := range containers {
		fmt.Println(c)
	}
	return nil
}

func runDockerPull(c *grumble.Context) error {
	if len(c.Args) == 0 {
		return fmt.Errorf("invalid args: pass a docker container")
	} else if len(c.Args) > 1 {
		return fmt.Errorf("too many args")
	}

	return docker.Pull(c.Args[0])
}
