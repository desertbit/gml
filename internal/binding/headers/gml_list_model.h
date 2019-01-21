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
typedef void (*gml_list_model_insert_rows_cb_t)(
    void* go_ptr,
    int row,
    int count
);
void gml_list_model_cb_register(
    gml_list_model_row_count_cb_t   rc_cb,
    gml_list_model_data_cb_t        d_cb
);

// Reset model.
void gml_list_model_begin_reset_model();
void gml_list_model_end_reset_model();

// Insert rows.
void gml_list_model_begin_insert_rows(gml_list_model lm, int row, int count);
void gml_list_model_end_insert_rows(gml_list_model lm);

// Move rows.
void gml_list_model_begin_move_rows(gml_list_model lm, int row, int count, int dst_row);
void gml_list_model_end_move_rows(gml_list_model lm);

// Rows' data changed.
void gml_list_model_rows_data_changed(gml_list_model lm, int row, int count);

// Remove rows.
void gml_list_model_begin_remove_rows(gml_list_model lm, int row, int count);
void gml_list_model_end_remove_rows(gml_list_model lm);


#ifdef __cplusplus
}
#endif

#endif
