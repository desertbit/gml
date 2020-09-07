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

#include "gml_error.h"
#include "gml_object.h"
#include "gml_image_provider.h"
#include "gml_variant.h"

typedef void* gml_app;

typedef void (*gml_app_run_main_cb_t)(void* go_ptr);
void gml_app_run_main_cb_register(gml_app_run_main_cb_t cb);

gml_app gml_app_new (int argv, char** argc, gml_error err);
void    gml_app_free(gml_app app);
int     gml_app_exec(gml_app app, gml_error err);
void    gml_app_quit(gml_app app);
int     gml_app_run_main(gml_app app, void* go_ptr);

int     gml_app_load     (gml_app app, const char* url, gml_error err);
int     gml_app_load_data(gml_app app, const char* data, gml_error err);
void    gml_app_add_import_path(gml_app app, const char* path);
int     gml_app_add_imageprovider(gml_app app, const char* id, gml_image_provider ip, gml_error err);

int     gml_app_set_root_context_property_object(gml_app app, const char* name, gml_object obj, gml_error err);
int     gml_app_set_root_context_property_variant(gml_app app, const char* name, gml_variant gml_v, gml_error err);
void    gml_app_set_application_name(gml_app app, const char* name);
void    gml_app_set_organization_name(gml_app app, const char* name);
void    gml_app_set_application_version(gml_app app, const char* version);
int     gml_get_top_level_window_state(gml_error err);
int     gml_set_top_level_window_state(int visibility, gml_error err);

double  gml_app_get_dp(gml_app app, gml_error err);

#ifdef __cplusplus
}
#endif

#endif
