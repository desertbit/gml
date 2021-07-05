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
#define GML_HEADER_VARIANT_H

#include "gml_includes.h"
#include "gml_bytes.h"

//#############//
//### C API ###//
//#############//

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* gml_variant;

    gml_variant gml_variant_new();
    void        gml_variant_free(gml_variant v);

    // #############################//
    // ### To variant from value ###//
    // #############################//

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

    gml_variant gml_variant_new_from_string(char* s);
    gml_variant gml_variant_new_from_bytes (char* b, int size);

    // ########################//
    // ### Variant to value ###//
    // ########################//

    u_int8_t gml_variant_to_bool(gml_variant v);

    float     gml_variant_to_float (gml_variant v);
    double    gml_variant_to_double(gml_variant v);

    int       gml_variant_to_int   (gml_variant v);
    int8_t    gml_variant_to_int8  (gml_variant v);
    u_int8_t  gml_variant_to_uint8 (gml_variant v);
    int16_t   gml_variant_to_int16 (gml_variant v);
    u_int16_t gml_variant_to_uint16(gml_variant v);
    int32_t   gml_variant_to_int32 (gml_variant v);
    u_int32_t gml_variant_to_uint32(gml_variant v);
    int64_t   gml_variant_to_int64 (gml_variant v);
    u_int64_t gml_variant_to_uint64(gml_variant v);

    void    gml_variant_to_string(gml_variant v, gml_bytes b);
    void    gml_variant_to_bytes (gml_variant v, gml_bytes b);

#ifdef __cplusplus
}
#endif

#endif
