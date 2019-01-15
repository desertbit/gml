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

#ifndef GML_HEADER_IMAGEPROVIDER_H
#define GML_HEADER_IMAGEPROVIDER_H

#define GML_IGNORE_ASPECT_RATIO            0
#define GML_KEEP_ASPECT_RATIO              1
#define GML_KEEP_ASPECT_RATIO_BY_EXPANDING 2

#define GML_FAST_TRANSFORMATION   0
#define GML_SMOOTH_TRANSFORMATION 1

#ifdef __cplusplus
extern "C" {
#endif

#include "gml_image.h"

typedef void* gml_image_provider;
typedef void* gml_image_response;

typedef void (*gml_image_provider_request_cb_t)(
    void*              go_ptr,
    gml_image_response img_resp,
    char*              id,
    gml_image          img
);
void gml_image_provider_request_cb_register(gml_image_provider_request_cb_t cb);

gml_image_provider gml_image_provider_new(
    void* go_ptr,
    int   aspect_ratio_mode,
    int   transformation_mode
);
void gml_image_provider_free(gml_image_provider ip);

void gml_image_response_emit_finished(
    gml_image_response img_resp,
    char* error_string
);

#ifdef __cplusplus
}
#endif

#endif
