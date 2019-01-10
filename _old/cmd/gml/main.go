package main

import (
	"github.com/gobuffalo/packr"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"runtime"
	"strconv"
)

var (
	buildDir = "./build"
	// TODO:
	goSrcDir = "./src"
	qmlDir = "./qml"
)

func main() {
	var err error
	buildDir, err = filepath.Abs(buildDir)
	if err != nil {
		log.Fatal(err)
	}

	// TODO: delete only necessary files
	err = os.RemoveAll(buildDir)
	if err != nil {
		log.Fatal(err)
	}

	err = os.MkdirAll(buildDir, 0755)
	if err != nil {
		log.Fatal(err)
	}

	goSrcDir, err = filepath.Abs(goSrcDir)
	if err != nil {
		log.Fatal(err)
	}

	qmlDir = filepath.Join(goSrcDir, qmlDir)

	// set up a new box by giving it a (relative) path to a folder on disk:
	box := packr.NewBox("../../internal/templates")
	maincpp := box.Bytes("main.cpp")
	err = ioutil.WriteFile(filepath.Join(buildDir, "main.cpp"), maincpp, 0644)
	if err != nil {
		log.Fatal(err)
	}

	pro := box.Bytes("project.pro")
	err = ioutil.WriteFile(filepath.Join(buildDir, "project.pro"), pro, 0644)
	if err != nil {
		log.Fatal(err)
	}

	res := box.Bytes("resources.qrc")
	err = ioutil.WriteFile(filepath.Join(buildDir, "resources.qrc"), res, 0644)
	if err != nil {
		log.Fatal(err)
	}

	init := box.Bytes("initializer.go")
	err = ioutil.WriteFile(filepath.Join(buildDir, "initializer.go"), init, 0644)
	if err != nil {
		log.Fatal(err)
	}

	err = runCommand(buildDir, "go", "build", "-buildmode=c-archive", "-o", "libbridge.a", "initializer.go")
	if err != nil {
		log.Fatal(err)
	}

	err = runCommand(buildDir, "qmake")
	if err != nil {
		log.Fatal(err)
	}

	cpuNum := strconv.Itoa(runtime.NumCPU())
	err = runCommand(buildDir, "make", "-j", cpuNum, "all")
	if err != nil {
		log.Fatal(err)
	}
}
