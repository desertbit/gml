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

import "text/template"

var goTmpl = template.Must(template.New("t").Funcs(tmplFuncMap).Parse(goTmplText))

const goTmplText = `// This file is auto-generated by gml.
package {{.PackageName}}

/*
#cgo pkg-config: Qt5Core Qt5Qml Qt5Quick
#cgo LDFLAGS: -lstdc++
#include <gml.h>
#include <gml_gen.h>

{{- /* Register with go functions */}}
{{range $struct := .Structs}}
 
{{- range $slot := $struct.Slots }}
extern {{$slot.CRetType}} {{$struct.CBaseName}}_{{$slot.Name}}_go_slot(void* _goPtr{{cParams $slot.Params true false}});
{{end -}}
{{- range $prop := $struct.Properties }}{{if not $prop.Silent}}
extern void {{$struct.CBaseName}}_{{$prop.Name}}_go_prop_changed(void* _goPtr);
{{end}}{{end}}
static void {{$struct.CBaseName}}_register() {
{{- range $slot := $struct.Slots }}
    {{$struct.CBaseName}}_{{$slot.Name}}_cb_register({{$struct.CBaseName}}_{{$slot.Name}}_go_slot);
{{end -}}
{{- range $prop := $struct.Properties }}{{if not $prop.Silent}}
	{{$struct.CBaseName}}_{{$prop.Name}}_cb_register({{$struct.CBaseName}}_{{$prop.Name}}_go_prop_changed);
{{end}}{{end -}}
}

{{- end}}
*/
import "C"
import (
    "unsafe"
    "runtime"

	"github.com/desertbit/gml"
	"github.com/desertbit/gml/pointer"
)

// Force to use the gml package. The import is not always required...
var _ = gml.Object{}

{{/* Struct loop */ -}}
{{range $struct := .Structs}}
//###
//### {{$struct.Name}}
//###

{{/* Init */ -}}
func init() {
    C.{{$struct.CBaseName}}_register()
}

func (_v *{{$struct.Name}}) GmlInit() {
    goPtr := pointer.Save(_v)
    _v.GmlObject_SetGoPointer(goPtr)
    _v.GmlObject_SetPointer(unsafe.Pointer(C.{{$struct.CBaseName}}_new(goPtr)))
    runtime.SetFinalizer(_v, func(_v *{{$struct.Name}}) {
        C.{{$struct.CBaseName}}_free((C.{{$struct.CBaseName}})(_v.GmlObject_Pointer()))
        pointer.Unref(goPtr)
    })
}

{{- /* Signals */}}
{{range $signal := $struct.Signals }}
func (_v *{{$struct.Name}}) {{$signal.EmitName}}({{goParams $signal.Params true true}}) {
    _ptr := (C.{{$struct.CBaseName}})(_v.GmlObject_Pointer())
    {{- goToCParams $signal.Params "_c_" true 4}}
    C.{{$struct.CBaseName}}_{{$signal.Name}}(_ptr{{goParams $signal.Params false false "_c_"}})
}
{{end}}

{{- /* Slots */ -}}
{{range $slot := $struct.Slots }}
//export {{$struct.CBaseName}}_{{$slot.Name}}_go_slot
func {{$struct.CBaseName}}_{{$slot.Name}}_go_slot(_goPtr unsafe.Pointer{{goCParams $slot.Params true false}}) {{$slot.CGoRetType}} {
    _v := (pointer.Restore(_goPtr)).(*{{$struct.Name}})
    {{- cToGoParams $slot.Params "_go_" 4}}
    
    {{ if $slot.NoRet -}}
    _v.{{$slot.Name}}({{goParams $slot.Params false true "_go_"}})
    {{- else -}}
    _r := _v.{{$slot.Name}}({{goParams $slot.Params false true "_go_"}})
    {{- goToCValue $slot.RetType "_r" "_rc" false 4}}
    return _rc
    {{- end}}
}
{{end}}

{{- /* Properties */ -}}
{{range $prop := $struct.Properties }}
func (_v *{{$struct.Name}}) {{$prop.SetName}}(v {{$prop.Type}}) {
    _ptr := (C.{{$struct.CBaseName}})(_v.GmlObject_Pointer())
    {{- goToCValue $prop.Type "v" "vc" true 4}}
    gml.RunMain(func() {
        C.{{$struct.CBaseName}}_{{$prop.Name}}_set(_ptr, vc)
    })
}

func (_v *{{$struct.Name}}) {{$prop.Name}}() (r {{$prop.Type}}) {
    _ptr := (C.{{$struct.CBaseName}})(_v.GmlObject_Pointer())
    gml.RunMain(func() {
        v := C.{{$struct.CBaseName}}_{{$prop.Name}}_get(_ptr)
        {{- cToGoValue $prop.Type "vg" "v" 8}}
        r = vg
    })
    return
}

{{if not $prop.Silent}}
//export {{$struct.CBaseName}}_{{$prop.Name}}_go_prop_changed
func {{$struct.CBaseName}}_{{$prop.Name}}_go_prop_changed(_goPtr unsafe.Pointer) {
	_v := (pointer.Restore(_goPtr)).(*{{$struct.Name}})
    _v.on{{$prop.PublicName}}Changed()
}
{{end}}
{{- end}}

{{- /* End of struct loop */ -}}
{{- end}}
`
