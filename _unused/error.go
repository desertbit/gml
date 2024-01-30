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

package gml

// #include <gml.h>
import "C"
import "errors"

type apiError struct {
	err C.gml_error
}

func newAPIError() *apiError {
	return &apiError{
		err: C.gml_error_new(),
	}
}

func (e *apiError) Free() {
	C.gml_error_free(e.err)
}

func (e *apiError) String() string {
	return C.GoString(C.gml_error_get_msg(e.err))
}

func (e *apiError) Reset() {
	C.gml_error_reset(e.err)
}

func (e *apiError) Err(prefix ...string) error {
	s := e.String()
	if len(prefix) > 0 {
		if len(s) == 0 {
			s = prefix[0]
		} else {
			s = prefix[0] + ": " + s
		}
	} else if len(s) == 0 {
		s = "unknown error"
	}
	return errors.New(s)
}
