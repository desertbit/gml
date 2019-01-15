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

#ifndef GML_HEADER_LIST_MODEL_H
#define GML_HEADER_LIST_MODEL_H

#ifdef __cplusplus
extern "C" {
#endif

#include "gml_variant.h"

typedef void* gml_list_model;

gml_list_model gml_list_model_new(void* go_ptr);
void gml_list_model_free(gml_list_model lm);

typedef int (*gml_list_model_row_count_cb_t)(
    void* go_ptr
);
typedef gml_variant (*gml_list_model_data_cb_t)(
    void* go_ptr,
    int row
);
void gml_list_model_cb_register(
    gml_list_model_row_count_cb_t rc_cb,
    gml_list_model_data_cb_t      d_cb
);

#ifdef __cplusplus
}
#endif

#endif
