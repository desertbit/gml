// Copyright (c) 2024 skaldesh
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package main

import "C"
import "fmt"

// Do not remove.
func main() {}

//export Slot
func Slot(typee, argsJSON *C.char) (callID C.int) {
	fmt.Printf("typee %s and args %s\n", C.GoString(typee), C.GoString(argsJSON))
	return 5
}

//export Test
func Test() {
	fmt.Println("Go lib test! Yaaay :)")
}
