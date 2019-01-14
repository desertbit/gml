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

#include "gml_imageprovider.h"

//########################//
//### Static Variables ###//
//########################//

gml_imageprovider_request_cb_t gml_imageprovider_request_cb = NULL;

//#############//
//### C API ###//
//#############//

void gml_imageprovider_request_cb_register(gml_imageprovider_request_cb_t cb) {
    gml_imageprovider_request_cb = cb;
}

gml_imageprovider gml_imageprovider_new(void* go_ptr) {
    try {
        GmlImageProvider* gip = new GmlImageProvider(go_ptr);
        return (void*)gip;
    }
    catch (std::exception& e) {
        //api_error_set_msg(err, e.what()); TODO:
        return NULL;
    }
    catch (...) {
        //api_error_set_unknown_msg(err); TODO:
        return NULL;
    }
}

void gml_imageprovider_free(gml_imageprovider ip) {
    if (ip == NULL) {
        return;
    }
    GmlImageProvider* gip = (GmlImageProvider*)ip;
    delete gip;
    ip = NULL;
}

//###################################//
//### GmlAsyncImageResponse Class ###//
//###################################//

GmlAsyncImageResponse::GmlAsyncImageResponse(
    void*         ipGoPtr,
    const QString &id,
    const QSize   &requestedSize
) : ipGoPtr(ipGoPtr) {
    // Call to go.
    try {
        gml_imageprovider_request_cb(ipGoPtr, id.toLocal8Bit().data());
    }
    catch (std::exception& e) {
        cerr << "gml: catched GmlAsyncImageResponse exception: " << e.what() << endl;
    }
    catch (...) {
        cerr << "gml: catched GmlAsyncImageResponse exception: " << endl;
    }
}

QQuickTextureFactory* GmlAsyncImageResponse::textureFactory() const {
    return QQuickTextureFactory::textureFactoryForImage(img);
}

//###########################//
//### ImageProvider Class ###//
//###########################//

GmlImageProvider::GmlImageProvider(void* goPtr) :
    goPtr(goPtr) {}

QQuickImageResponse* GmlImageProvider::requestImageResponse(
    const QString &id,
    const QSize   &requestedSize
) {
   return new GmlAsyncImageResponse(goPtr, id, requestedSize);
};
