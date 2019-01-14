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

#ifndef GML_HEADER_APP_H
#define GML_HEADER_APP_H

#ifdef __cplusplus
extern "C" {
#endif

#include "gml_object.h"

typedef void* gml_app;

typedef void (*gml_app_run_main_cb_t)(void* _go_ptr);
void gml_app_run_main_cb_register(gml_app_run_main_cb_t cb);

gml_app gml_app_new (int argv, char** argc);
void    gml_app_free(gml_app app);
int     gml_app_exec(gml_app app);
int     gml_app_quit(gml_app app);
int     gml_app_run_main(gml_app app, void* goPtr);

int     gml_app_load     (gml_app app, const char* url);
int     gml_app_load_data(gml_app app, const char* data);

int     gml_app_set_root_context_property(gml_app app, const char* name, gml_object obj);

#ifdef __cplusplus
}
#endif

#endif
