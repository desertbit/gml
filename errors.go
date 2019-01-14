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

const (
	errorPoolSize = 50
)

var (
	errorPool = newAPIErrorPool(errorPoolSize)
)

type apiErrorPool struct {
	pool chan *apiError
}

func newAPIErrorPool(poolSize int) *apiErrorPool {
	return &apiErrorPool{
		pool: make(chan *apiError, poolSize),
	}
}

// Get an error from the pool.
// Allocates new memory if the pool is empty.
func (p *apiErrorPool) Get() (e *apiError) {
	select {
	case e = <-p.pool:
	default:
		e = newAPIError()
	}
	return
}

// Put an error back to the pool.
func (p *apiErrorPool) Put(e *apiError) {
	// Reset the error message.
	e.Reset()

	select {
	case p.pool <- e:
	default:
		// Just let it go. The pool is full.
		e.Free()
	}
}

// Reset empties the pool.
func (p *apiErrorPool) Reset() {
	var e *apiError
	for {
		select {
		case e = <-p.pool:
			e.Free()
		default:
			return
		}
	}
}
