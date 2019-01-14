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

#include "gml_error.h"

//#############//
//### C API ###//
//#############//

gml_error gml_error_new() {
    try {
        GmlError* gerr = new GmlError();
        return (void*)gerr;
    }
    catch (std::exception& e) {
        gml_error_log_exception("new gml_error: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("new gml_error");
        return NULL;
    }
}

void gml_error_free(gml_error err) {
    if (err == NULL) {
        return;
    }
    GmlError* gerr = (GmlError*)err;
    delete gerr;
    err = NULL;
}

void gml_error_reset(gml_error err) {
    try {
        GmlError* gerr = (GmlError*)err;
        gerr->msg = "";
    }
    catch (std::exception& e) {
        gml_error_log_exception("reset error message: " + string(e.what()));
    }
    catch (...) {
        gml_error_log_exception("reset error message");
    }
}

const char* gml_error_get_msg(gml_error err) {
    try {
        GmlError* gerr = (GmlError*)err;
        return gerr->msg.c_str();
    }
    catch (std::exception& e) {
        gml_error_log_exception("get error message: " + string(e.what()));
        return NULL;
    }
    catch (...) {
        gml_error_log_exception("get error message");
        return NULL;
    }
}

//################//
//### Internal ###//
//################//

void gml_error_set_msg(gml_error err, const std::string& msg) {
    GmlError* gerr = (GmlError*)err;
    gerr->msg = msg;
}

void gml_error_set_catched_exception_msg(gml_error err) {
    gml_error_set_msg(err, "catched unknown exception");
}

void gml_error_log_exception(const string& msg) {
    if (msg == "") {
        cerr << "gml: catched unknown exception" << endl;
    } else {
        cerr << "gml: catched exception: " << msg << endl;
    }
}