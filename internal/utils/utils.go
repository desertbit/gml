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

package utils

import (
	"os"
	"os/exec"
	"unicode"
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

func FirstCharToLower(s string) string {
	if len(s) == 0 {
		return ""
	}

	// Ensure first char is lower case.
	sr := []rune(s)
	sr[0] = unicode.ToLower(rune(sr[0]))
	return string(sr)
}

func FirstCharToUpper(s string) string {
	if len(s) == 0 {
		return ""
	}

	// Ensure first char is lower case.
	sr := []rune(s)
	sr[0] = unicode.ToUpper(rune(sr[0]))
	return string(sr)
}
