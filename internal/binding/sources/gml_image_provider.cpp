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

#include "gml_image_provider.h"
#include "gml_error.h"

//########################//
//### Static Variables ###//
//########################//

gml_image_provider_request_cb_t gml_image_provider_request_cb = NULL;

//#############//
//### C API ###//
//#############//

void gml_image_provider_request_cb_register(gml_image_provider_request_cb_t cb) {
    gml_image_provider_request_cb = cb;
}

gml_image_provider gml_image_provider_new(
    void* go_ptr,
    int   aspect_ratio_mode,
    int   transformation_mode
) {
    try {
        GmlImageProvider* gip = new GmlImageProvider(
            go_ptr,
            static_cast<Qt::AspectRatioMode>(aspect_ratio_mode),
            static_cast<Qt::TransformationMode>(transformation_mode)
        );
        return (gml_image_provider)gip;
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
        return NULL;
    }
    catch (...) {
        gml_error_log_exception();
        return NULL;
    }
}

void gml_image_provider_free(gml_image_provider ip) {
    if (ip == NULL) {
        return;
    }
    GmlImageProvider* gip = (GmlImageProvider*)ip;
    delete gip;
    ip = NULL;
}

void gml_image_response_emit_finished(gml_image_response img_resp, char* error_string) {
    try {
        GmlAsyncImageResponse* gimg_resp = (GmlAsyncImageResponse*)img_resp;
        gimg_resp->finalize(QString(error_string));
    }
    catch (std::exception& e) {
        gml_error_log_exception("image response: emit finished: " + string(e.what()));
    }
    catch (...) {
        gml_error_log_exception("image response: emit finished");
    }
}

//###################################//
//### GmlAsyncImageResponse Class ###//
//###################################//

GmlAsyncImageResponse::GmlAsyncImageResponse(
    void*                  ipGoPtr,
    const QString          &id,
    const QSize            &requestedSize,
    Qt::AspectRatioMode    aspectRatioMode,
    Qt::TransformationMode transformMode
) :
    ipGoPtr(ipGoPtr),
    requestedSize(requestedSize),
    aspectRatioMode(aspectRatioMode),
    transformMode(transformMode)
{
    // Call to go.
    try {
        gml_image_provider_request_cb(
            ipGoPtr,
            (gml_image_response)(this),
            id.toLocal8Bit().data(),
            (gml_image)(&img)
        );
    }
    catch (std::exception& e) {
        gml_error_log_exception("image async response: request: " + string(e.what()));
    }
    catch (...) {
        gml_error_log_exception("image async response: request");
    }
}

QString GmlAsyncImageResponse::errorString() const {
    return errorStr;
}

QQuickTextureFactory* GmlAsyncImageResponse::textureFactory() const {
    return QQuickTextureFactory::textureFactoryForImage(img);
}

void GmlAsyncImageResponse::finalize(const QString& errorString) {
    // Check for an error.
    if (!errorString.isEmpty()) {
        errorStr = errorString;
    } else if (!requestedSize.isNull() && requestedSize.isValid()) {
        // Resize the image to the requested size
        img = img.scaled(requestedSize, Qt::IgnoreAspectRatio, transformMode);
    }

    // Emit the finished signal.
    emit finished();
}

//###########################//
//### ImageProvider Class ###//
//###########################//

GmlImageProvider::GmlImageProvider(
    void*                  goPtr,
    Qt::AspectRatioMode    aspectRatioMode,
    Qt::TransformationMode transformMode
) :
    goPtr(goPtr),
    aspectRatioMode(aspectRatioMode),
    transformMode(transformMode)
{}

QQuickImageResponse* GmlImageProvider::requestImageResponse(
    const QString &id,
    const QSize   &requestedSize
) {
    return new GmlAsyncImageResponse(goPtr, id, requestedSize, aspectRatioMode, transformMode);
}
