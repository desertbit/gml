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

package build

import (
	"fmt"
	"io/ioutil"

	"gopkg.in/yaml.v2"
)

type ProjectType string

const (
	ProjectTypeApp    ProjectType = "app"
	ProjectTypeModule ProjectType = "module"
)

type ProjectManifest struct {
	// Required fields:
	Name string  `yaml:"name"`
	Type ProType `yaml:"type"`

	// Optional:
	BuildDir string `yaml:"build-dir"`
	BinDir   string `yaml:"bin-dir"`

	Resources []string `yaml:"resources"`  // resource directories.
	Modules   []string `yaml:"modules"`    // gml modules.
	QtModules []string `yaml:"qt-modules"` // additional qt modules.
}

func (m *ProjectManifest) Load(path string) (err error) {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return
	}
	err = yaml.UnmarshalStrict(data, m)
	if err != nil {
		return
	}
	return m.Prepare()
}

func (m *ProjectManifest) Prepare() (err error) {
	if m.Name == "" {
		return fmt.Errorf("no project name defined")
	} else if m.Type != ProjectTypeApp && m.Type != ProjectTypeModule {
		return fmt.Errorf("invalid project type")
	}

	if m.BuildDir == "" {
		m.BuildDir = "build"
	}
	if m.BinDir == "" {
		m.BinDir = "bin"
	}
	return
}
