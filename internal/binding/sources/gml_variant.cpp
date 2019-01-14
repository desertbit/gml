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

//#############//
//### C API ###//
//#############//

void gml_variant_free(gml_variant vv) {
    if (vv == NULL) {
        return;
    }
    QVariant* v = (QVariant*)vv;
    delete v;
    vv = NULL;
}

gml_variant gml_variant_new() {
    try {
        QVariant* v = new QVariant();
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_bool(u_int8_t b) {
    try {
        QVariant* v = new QVariant(bool(b));
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_float(float f) {
    try {
        QVariant* v = new QVariant(f);
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_double(double d) {
    try {
        QVariant* v = new QVariant(d);
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_int(int i) {
    try {
        QVariant* v = new QVariant(i);
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_int8(int8_t i) {
    try {
        QVariant* v = new QVariant(i);
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_uint8(u_int8_t i) {
    try {
        QVariant* v = new QVariant(i);
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_int16(int16_t i) {
    try {
        QVariant* v = new QVariant(i);
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_uint16(u_int16_t i) {
    try {
        QVariant* v = new QVariant(i);
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_int32(int32_t i) {
    try {
        QVariant* v = new QVariant(i);
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_uint32(u_int32_t i) {
    try {
        QVariant* v = new QVariant(i);
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_int64(int64_t i) {
    try {
        QVariant* v = new QVariant((long long)(i));
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_uint64(u_int64_t i) {
    try {
        QVariant* v = new QVariant((unsigned long long)(i));
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_qchar(int32_t r) {
    try {
        QVariant* v = new QVariant(QChar(r));
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_string(char* s) {
    try {
        QVariant* v = new QVariant(QString(s));
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}

gml_variant gml_variant_new_from_bytes(char* b, int size) {
    try {
        QVariant* v = new QVariant(QByteArray(b, size));
        return (void*)v;
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return NULL;
    }
}