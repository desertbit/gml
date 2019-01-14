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

#ifndef GML_HEADER_VARIANT_H
#define GML_HEADER_OBJECGML_HEADER_VARIANT_HT_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void* gml_variant;

void        gml_variant_free(gml_variant v);
gml_variant gml_variant_new();

gml_variant gml_variant_new_from_bool(u_int8_t b);

gml_variant gml_variant_new_from_float (float f);
gml_variant gml_variant_new_from_double(double d);

gml_variant gml_variant_new_from_int   (int i);
gml_variant gml_variant_new_from_int8  (int8_t i);
gml_variant gml_variant_new_from_uint8 (u_int8_t i);
gml_variant gml_variant_new_from_int16 (int16_t i);
gml_variant gml_variant_new_from_uint16(u_int16_t i);
gml_variant gml_variant_new_from_int32 (int32_t i);
gml_variant gml_variant_new_from_uint32(u_int32_t i);
gml_variant gml_variant_new_from_int64 (int64_t i);
gml_variant gml_variant_new_from_uint64(u_int64_t i);

gml_variant gml_variant_new_from_qchar (int32_t r);
gml_variant gml_variant_new_from_string(char* s);

#ifdef __cplusplus
}
#endif

#endif
