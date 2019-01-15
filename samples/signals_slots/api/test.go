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

package api

//easyjson:json
type Test struct {
	Row    int     `json:"row"`
	Text   string  `json:"text"`
	Data1  float32 `json:"data_1"`
	Data2  uint16  `json:"data_2"`
	Data3  uint32  `json:"data_3"`
	Data4  float64 `json:"data_4"`
	Data5  float32 `json:"data_5"`
	Data6  uint16  `json:"data_6"`
	Data7  uint32  `json:"data_7"`
	Data8  float64 `json:"data_8"`
	Data9  float32 `json:"data_9"`
	Data10 uint16  `json:"data_10"`
	Data11 uint32  `json:"data_11"`
	Data12 float64 `json:"data_12"`
	Hello  []int32 `json:"hello"`
}
