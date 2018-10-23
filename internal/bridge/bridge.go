package main

import "C"
import "errors"

func main() {}

//export Test
func Test(i int) error {
	println("test", i)
	return errors.New("test")
}

//export Init
func Init() string {

}
