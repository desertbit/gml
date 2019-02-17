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
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/desertbit/gml/internal/utils"
)

var (
	inputBin       string
	objdumpBin     string
	destDir        string
	srcDir         string
	enforceDirsStr string
	enforceDirs    []string

	allDeps = make(map[string]string)
	deps    = make(map[string]string)
)

func main() {
	err := prepareFlags()
	if err != nil {
		log.Fatalln(err)
	}

	err = prepareAllDeps()
	if err != nil {
		log.Fatalln(err)
	}

	err = findDeps()
	if err != nil {
		log.Fatalln(err)
	}

	err = copyDeps()
	if err != nil {
		log.Fatalln(err)
	}

	err = copyEnforcedDirs()
	if err != nil {
		log.Fatalln(err)
	}
}

func prepareFlags() (err error) {
	flag.StringVar(&inputBin, "input", "", "input binary")
	flag.StringVar(&destDir, "dest", "", "destination output directory")
	flag.StringVar(&srcDir, "src", "", "source directory (recursively searched)")
	flag.StringVar(&enforceDirsStr, "enforce", "", "add additional directories (flat copy; comma separated)")
	flag.StringVar(&objdumpBin, "objdump", "objdump", "objdump binary")
	flag.Parse()

	// Input Binary.
	if inputBin == "" {
		return fmt.Errorf("no input binary specified")
	}
	e, err := utils.Exists(inputBin)
	if err != nil {
		return
	} else if !e {
		return fmt.Errorf("input binary does not exists")
	}

	// Dest Dir.
	destDir, err = filepath.Abs(destDir)
	if err != nil {
		return
	}
	err = os.MkdirAll(destDir, 0755)
	if err != nil {
		return
	}

	// Source Dir.
	srcDir, err = filepath.Abs(srcDir)
	if err != nil {
		return
	}
	e, err = utils.Exists(srcDir)
	if err != nil {
		return
	} else if !e {
		return fmt.Errorf("source directory does not exists")
	}

	// Enforce dirs.
	enforceDirs = strings.Split(enforceDirsStr, ",")

	return
}

func prepareAllDeps() (err error) {
	err = filepath.Walk(srcDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		} else if info.IsDir() || !strings.HasSuffix(strings.ToLower(info.Name()), ".dll") {
			return nil
		}
		dep := strings.ToLower(info.Name())
		allDeps[dep] = path
		return nil
	})
	return
}

func findDeps() (err error) {
	inputs := []string{inputBin}

	for _, d := range enforceDirs {
		err = filepath.Walk(d, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			} else if info.IsDir() || !strings.HasSuffix(strings.ToLower(info.Name()), ".dll") {
				return nil
			}
			inputs = append(inputs, path)
			return nil
		})
		if err != nil {
			return
		}
	}

	for _, input := range inputs {
		err = findRecursiveDeps(input)
		if err != nil {
			return
		}
	}
	return
}

func findRecursiveDeps(path string) (err error) {
	out, err := exec.Command(objdumpBin, "-p", path).Output()
	if err != nil {
		return
	}

	lines := strings.Split(string(out), "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if !strings.HasPrefix(line, "DLL Name:") {
			continue
		}

		line = strings.ToLower(strings.TrimSpace(strings.TrimPrefix(line, "DLL Name:")))
		if _, ok := deps[line]; ok {
			continue
		}

		depPath := allDeps[line]
		deps[line] = depPath

		if depPath == "" {
			continue
		}

		err = findRecursiveDeps(depPath)
		if err != nil {
			return
		}
	}

	return
}

func copyDeps() (err error) {
	for _, path := range deps {
		if path == "" {
			continue
		}

		err = utils.CopyFile(path, filepath.Join(destDir, filepath.Base(path)))
		if err != nil {
			return
		}
	}
	return
}

func copyEnforcedDirs() error {
	for _, src := range enforceDirs {
		dest := filepath.Join(destDir, filepath.Base(src))
		e, err := utils.Exists(dest)
		if err != nil {
			return err
		} else if e {
			err = os.RemoveAll(dest)
			if err != nil {
				return err
			}
		}

		err = utils.CopyDir(src, dest)
		if err != nil {
			return err
		}
	}
	return nil
}
