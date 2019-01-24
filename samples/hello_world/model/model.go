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

package model

import (
	"strconv"

	"github.com/desertbit/gml"
	"github.com/rs/zerolog/log"
)

var M *model

type model struct {
	*gml.ListModel

	_ struct {
		get func(row int) string `gml:"slot"`
	}
}

func (m *model) RowCount() int {
	return 3
}

func (m *model) Data(row int) interface{} {
	return "row: " + strconv.Itoa(row)
}

func init() {
	M = &model{}
	M.ListModel = gml.NewListModel(M)
	M.GMLInit()

	err := gml.SetContextProperty("m", M)
	if err != nil {
		log.Fatal().Err(err).Msg("init")
	}
}

//#############//
//### Slots ###//
//#############//

func (m *model) get(row int) string {
	return "this is a test, lol"
}
