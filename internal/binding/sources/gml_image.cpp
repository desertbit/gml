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

//#############//
//### C API ###//
//#############//

gml_image gml_image_new() {
    try {
        QImage* qImg = new QImage();
        return (void*)qImg;
    }
    catch (std::exception& e) {
        cerr << "gml: catched variant exception: " << e.what() << endl;
        return NULL;
    }
    catch (...) {
        cerr << "gml: catched variant exception" << endl;
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

int gml_image_load_from_data(gml_image img, char* data, int size) {
    try {
        QImage* qImg = (QImage*)img;
        qImg->loadFromData((const unsigned char*)(data), size);
        return 0; // TODO:
    }
    catch (std::exception& e) {
        cerr << "gml: catched variant exception: " << e.what() << endl;
        return -1; // TODO:
    }
    catch (...) {
        cerr << "gml: catched variant exception" << endl;
        return -1; // TODO:
    }
}
