/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package utils

import (
	"os"
	"os/exec"
)

// Exists returns whether the given file or directory exists.
func Exists(path string) (bool, error) {
	_, err := os.Lstat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}

func RunCommand(env []string, dir, cmd string, args ...string) (err error) {
	c := exec.Command(cmd, args...)
	c.Dir = dir
	c.Env = env

	// TODO: also log to a log file.
	c.Stderr = os.Stderr
	if Verbose {
		c.Stdout = os.Stdout
	}

	return c.Run()
}