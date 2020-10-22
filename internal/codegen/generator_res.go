// Copyright (c) 2020 Roland Singer, Sebastian Borchers
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package codegen

func (g *generator) resFile(path, prefix string) {
	g.writefLn("<!-- %s -->\n", header)
	g.writeLn(`<!DOCTYPE RCC><RCC version="1.0">`)
	g.writefLn(`<qresource prefix="%s">`, path)
	

{{- range .}}
    <file{{if ne .Alias ""}} alias="{{.Alias}}"{{end}}>{{.FilePath}}</file>
{{- end}}
</qresource>
</RCC>
}
