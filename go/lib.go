// Copyright (c) 2024 skaldesh
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

package main

import "C"
import "fmt"

//export Test
func Test() {
	fmt.Println("Go lib test! Yaaay :)")
}

func main() {}
