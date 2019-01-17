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
#include "gml_bytes.h"

//#############//
//### C API ###//
//#############//

gml_variant gml_variant_new() {
    try {
        QVariant* v = new QVariant();
        return (gml_variant)v;
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

void gml_variant_free(gml_variant vv) {
    if (vv == NULL) {
        return;
    }
    QVariant* v = (QVariant*)vv;
    delete v;
    vv = NULL;
}

// #############################//
// ### To variant from value ###//
// #############################//

gml_variant gml_variant_new_from_bool(u_int8_t b) {
    try {
        QVariant* v = new QVariant(bool(b));
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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

gml_variant gml_variant_new_from_rune(int32_t r) {
    try {
        QVariant* v = new QVariant(QChar(r));
        return (gml_variant)v;
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
        return (gml_variant)v;
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
        return (gml_variant)v;
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

// ########################//
// ### Variant to value ###//
// ########################//

u_int8_t gml_variant_to_bool(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (u_int8_t)(qv->toBool());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

float gml_variant_to_float(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return qv->toFloat();
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

double gml_variant_to_double(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return qv->toDouble();
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

int gml_variant_to_int(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return qv->toInt();
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

int8_t gml_variant_to_int8(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (int8_t)(qv->toInt());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

u_int8_t gml_variant_to_uint8(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (u_int8_t)(qv->toInt());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

int16_t gml_variant_to_int16(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (int16_t)(qv->toInt());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

u_int16_t gml_variant_to_uint16(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (u_int16_t)(qv->toInt());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

int32_t gml_variant_to_int32(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (int32_t)(qv->toInt());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

u_int32_t gml_variant_to_uint32(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (u_int32_t)(qv->toInt());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

int64_t gml_variant_to_int64(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (int64_t)(qv->toLongLong());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

u_int64_t gml_variant_to_uint64(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (u_int64_t)(qv->toLongLong());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

int32_t gml_variant_to_rune(gml_variant v) {
    try {
        QVariant* qv = (QVariant*)v;
        return (int32_t)(qv->toInt());
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
        return 0;
    }
    catch (...) {
        gml_error_log_exception("variant");
        return 0;
    }
}

void gml_variant_to_string(gml_variant v, gml_bytes b)  {
    try {
        QVariant* qv = (QVariant*)v;
        QByteArray* qb = (QByteArray*)b;
        *qb = qv->toString().toLocal8Bit(); // TODO: can we use toByteArray instead?
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
    }
    catch (...) {
        gml_error_log_exception("variant");
    }
}

void gml_variant_to_bytes(gml_variant v, gml_bytes b) {
    try {
        QVariant* qv = (QVariant*)v;
        QByteArray* qb = (QByteArray*)b;
        *qb = qv->toByteArray();
    }
    catch (std::exception& e) {
        gml_error_log_exception("variant: " + string(e.what()));
    }
    catch (...) {
        gml_error_log_exception("variant");
    }
}