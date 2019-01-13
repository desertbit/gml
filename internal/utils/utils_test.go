/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package utils

import (
	"runtime"
	"sync"
	"testing"
)

func TestGetThreadID(t *testing.T) {
	var wg sync.WaitGroup
	n := 10
	idChan := make(chan int, n)

	runtime.GOMAXPROCS(n)
	runtime.LockOSThread()

	wg.Add(n)
	for i := 0; i < n; i++ {
		go func() {
			defer wg.Done()
			runtime.LockOSThread()
			idChan <- GetThreadID()
		}()
	}

	wg.Wait()

	lastID := -1
	for i := 0; i < n; i++ {
		nextID := <-idChan
		if lastID == nextID {
			t.Error(lastID, nextID)
		}
		lastID = nextID
	}
}
