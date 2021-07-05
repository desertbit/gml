/*
 * docker - nLab
 * Copyright (c) 2020 Wahtari GmbH
 */

package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"
)

const (
	FileSuffix      = ".dockerfile"
	GenSuffix       = ".gen"
	ImportPrefix    = "#import"
	VersionVariable = "{{{VERSION}}}"
)

func main() {
	if len(os.Args) != 3 {
		log.Fatalln("usage: [DIR] [VERSION]")
	}

	// Prepare the base dir.
	dir, err := filepath.Abs(os.Args[1])
	if err != nil {
		log.Fatalln("failed to prepare dir path:", err)
	}

	// Obtain the version tag.
	version := strings.TrimSpace(os.Args[2])
	if version == "" {
		log.Fatalln("no version passed")
	}

	// Generate all Dockerfiles from Dockerfile.in files.
	err = generate(dir, version)
	if err != nil {
		log.Fatalln("failed to generate Dockerfiles:", err)
	}
}

func generate(dir, version string) (err error) {
	var (
		e    bool
		data []byte
	)

	entries, err := ioutil.ReadDir(dir)
	if err != nil {
		return
	}

	for _, fi := range entries {
		if fi.IsDir() {
			continue
		}

		base := filepath.Base(fi.Name())
		if !strings.HasSuffix(base, FileSuffix) {
			continue
		}

		dockerFileIn := filepath.Join(dir, base)
		dockerFile := filepath.Join(dir, "."+base+GenSuffix)

		e, err = exists(dockerFileIn)
		if err != nil {
			return
		} else if !e {
			continue
		}

		fmt.Println("> generating:", filepath.Base(dockerFile))

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
			// Replace the variable with the actual value.
			line = strings.ReplaceAll(line, VersionVariable, version)

			// Check for the import prefix.
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

			importFile := filepath.Join(dir, line)
			e, err = exists(importFile)
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

// exists returns whether the given file or directory exists.
func exists(path string) (bool, error) {
	_, err := os.Lstat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}
