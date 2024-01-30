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
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/desertbit/gml/internal/utils"
)

const (
	ImportPrefix = "#import"
)

func main() {
	// Prepare the base dir.
	baseDir, err := os.Getwd()
	if err != nil {
		log.Fatalln("failed to get current working dir:", err)
	}

	// Generate all Dockerfiles from Dockerfile.in files.
	err = generate(baseDir)
	if err != nil {
		log.Fatalln("failed to generate Dockerfiles:", err)
	}
}

func generate(baseDir string) (err error) {
	var (
		e    bool
		data []byte
	)

	entries, err := ioutil.ReadDir(baseDir)
	if err != nil {
		return
	}

	for _, fi := range entries {
		if !fi.IsDir() {
			continue
		}
		t := filepath.Base(fi.Name())

		dockerFile := filepath.Join(baseDir, t, "Dockerfile")
		dockerFileIn := dockerFile + ".in"

		e, err = utils.Exists(dockerFileIn)
		if err != nil {
			return
		} else if !e {
			continue
		}

		fmt.Println("> generating:", t)

		data, err = ioutil.ReadFile(dockerFileIn)
		if err != nil {
			return
		}

		var out *os.File
		out, err = os.Create(dockerFile)
		if err != nil {
			return
		}
		defer out.Close()

		lines := strings.Split(string(data), "\n")
		for _, line := range lines {
			if !strings.HasPrefix(strings.TrimSpace(line), ImportPrefix) {
				_, err = out.WriteString(line + "\n")
				if err != nil {
					return
				}
				continue
			}

			line = strings.TrimSpace(strings.TrimPrefix(strings.TrimSpace(line), ImportPrefix))
			if len(line) == 0 {
				return fmt.Errorf("invalid import command: %s", line)
			}

			importFile := filepath.Join(baseDir, line)
			e, err = utils.Exists(importFile)
			if err != nil {
				return
			} else if !e {
				return fmt.Errorf("invalid import command: %s", line)
			}

			data, err = ioutil.ReadFile(importFile)
			if err != nil {
				return
			}

			_, err = out.WriteString(string(data) + "\n")
			if err != nil {
				return
			}
		}

	}
	return
}
