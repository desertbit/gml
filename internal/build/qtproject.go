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
	"os"
	"text/template"
)

var qtProTmpl = template.Must(template.New("t").Parse(qtProData))

func prepareQtProject(ctx *Context) (err error) {
	// Create or open the config file.
	f, err := os.Create(ctx.QtProFile)
	if err != nil {
		return
	}
	defer func() {
		derr := f.Close()
		if derr != nil && err == nil {
			err = derr
		}
	}()

	return qtProTmpl.Execute(f, &ctx)
}

const qtProData = `
QT += core qml quick

TEMPLATE = lib
CONFIG += staticlib

win32|win64 {
	CONFIG += release
	Release:DESTDIR = 
}

INCLUDEPATH += {{.GmlBindingDir}}/headers

HEADERS += {{.GmlBindingHeadersDir}}/*.h {{.GmlBindingSourcesDir}}/*.h {{.CGenDir}}/*.h {{.CPPGenDir}}/*.h
SOURCES += {{.GmlBindingSourcesDir}}/*.cpp {{.CPPGenDir}}/*.cpp
RESOURCES += {{.QMLResFile}}

OBJECTS_DIR = {{.BuildDir}}
MOC_DIR = {{.BuildDir}}
UI_DIR = {{.BuildDir}}
TARGET = {{.BuildDir}}/gml
DESTDIR = 
`
