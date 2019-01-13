/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
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
import "syscall"

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

func getThreadID() int {
	// TODO: check if this is supported in MaxOSX and Windows. Also create a unit test!
	return syscall.Gettid()
}
