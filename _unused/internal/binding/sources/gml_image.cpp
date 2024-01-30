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

#include "gml_includes.h"
#include "gml_error.h"

//###############//
//### Private ###//
//###############//

void gml_image_cleanup(void *data) {
    free(data);
}

//#############//
//### C API ###//
//#############//

gml_image gml_image_new() {
    try {
        QImage* qImg = new QImage();
        return (gml_image)qImg;
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

void gml_image_free(gml_image img) {
    if (img == NULL) {
        return;
    }
    QImage* qImg = (QImage*)img;
    delete qImg;
    img = NULL;
}

void gml_image_reset(gml_image img) {
    try {
        QImage* qImg = (QImage*)img;
        *qImg = QImage();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_image_copy(gml_image img, gml_image dst, int x, int y, int width, int height) {
    try {
        QImage* qImg = (QImage*)img;
        QImage* qDst = (QImage*)dst;
        *qDst = qImg->copy(x, y, width, height);
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_image_set_to(gml_image img, gml_image other) {
    try {
        QImage* qImg = (QImage*)img;
        QImage* qImgOther = (QImage*)other;
        *qImg = *qImgOther;
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

int gml_image_load_from_file(gml_image img, const char* filename, gml_error err) {
    try {
        QImage* qImg = (QImage*)img;
        *qImg = QImage(QString(filename));
        if (qImg->isNull()) {
            gml_error_set_msg(err, "failed to load image from file");
            return -1;
        }
        return 0;
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
        return -1;
    }
    catch (...) {
         gml_error_set_catched_exception_msg(err);
        return -1;
    }
}

int gml_image_load_from_rgba(gml_image img, const char* cdata, int size, int width, int height, int stride, gml_error err) {
    try {
        QImage* qImg = (QImage*)img;

        // Create a copy of the data.
        uchar* data = (uchar*)(malloc(size));
        if (data == NULL) {
            throw std::runtime_error("failed to malloc image memory");
        }
        memcpy(data, cdata, size);

        *qImg = QImage(data, width, height, stride, QImage::Format_RGBA8888, &gml_image_cleanup, data);
        return 0;
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
        return -1;
    }
    catch (...) {
         gml_error_set_catched_exception_msg(err);
        return -1;
    }
}

int gml_image_load_from_data(gml_image img, const char* data, int size, gml_error err) {
    try {
        QImage* qImg = (QImage*)img;
        qImg->loadFromData((const unsigned char*)(data), size);
        if (qImg->isNull()) {
            gml_error_set_msg(err, "failed to load image from data");
            return -1;
        }
        return 0;
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
        return -1;
    }
    catch (...) {
         gml_error_set_catched_exception_msg(err);
        return -1;
    }
}

int gml_image_height(gml_image img) {
    try {
        return ((QImage*)img)->height();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
        return -1;
    }
    catch (...) {
        gml_error_log_exception();
        return -1;
    }
}

int gml_image_width(gml_image img) {
    try {
        return ((QImage*)img)->width();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
        return -1;
    }
    catch (...) {
        gml_error_log_exception();
        return -1;
    }
}

int gml_image_is_empty(gml_image img) {
    try {
        if (((QImage*)img)->isNull()) {
            return 1;
        } else {
            return 0;
        }
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
        return -1;
    }
    catch (...) {
        gml_error_log_exception();
        return -1;
    }
}