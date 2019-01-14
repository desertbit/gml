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

/*
  #include <stdlib.h>

  static char** makeCharArray(int size) {
	  return (char**)(malloc(size * sizeof(char*)));
  }

  static void setCharArrayString(char **a, char *s, int n) {
	  a[n] = s;
  }

  static void freeCharArray(char **a, int size) {
	  int i;
	  for (i = 0; i < size; i++) {
		  free(a[i]);
	  }
	  free(a);
  }
*/
import "C"

//###############//
//### Private ###//
//###############//

func toCharArray(ss []string) **C.char {
	a := C.makeCharArray(C.int(len(ss)))
	for i, s := range ss {
		C.setCharArrayString(a, C.CString(s), C.int(i))
	}
	return a
}

func freeCharArray(a **C.char, size int) {
	C.freeCharArray(a, C.int(size))
}
