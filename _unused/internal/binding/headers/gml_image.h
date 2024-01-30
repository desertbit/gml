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

#ifndef GML_HEADER_IMAGE_H
#define GML_HEADER_IMAGE_H

#ifdef __cplusplus
extern "C" {
#endif

#include "gml_error.h"

typedef void* gml_image;

gml_image gml_image_new();
void      gml_image_free(gml_image img);
void      gml_image_reset(gml_image img);
void      gml_image_copy(gml_image img, gml_image dst, int x, int y, int width, int height);
void      gml_image_set_to(gml_image img, gml_image other);
int       gml_image_load_from_file(gml_image img, const char* filename, gml_error err);
int       gml_image_load_from_rgba(gml_image img, const char* data, int size, int width, int height, int stride, gml_error err);
int       gml_image_load_from_data(gml_image img, const char* data, int size, gml_error err);
int       gml_image_height(gml_image img);
int       gml_image_width(gml_image img);
int       gml_image_is_empty(gml_image img);

#ifdef __cplusplus
}
#endif

#endif