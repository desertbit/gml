// Copyright (c) 2020 Roland Singer, Sebastian Borchers
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package codegen

type Package struct {
	PackageName string
	Dir         string
	Structs     []*Struct
}

type Struct struct {
	Name           string
	CBaseName      string
	CPPBaseName    string
	Signals        []*Signal
	Slots          []*Slot
	Properties     []*Property
	AdditionalType string
}

type Signal struct {
	Name     string
	EmitName string
	CPPName  string
	Params   []*Param
}

type Slot struct {
	Name    string
	CPPName string
	Params  []*Param
	NoRet   bool
	RetType TypeConverter
}

type Property struct {
	Name       string
	PublicName string
	CPPName    string
	SetName    string
	Type       TypeConverter
	Silent     bool
}

type Param struct {
	Name string
	Type TypeConverter
}
