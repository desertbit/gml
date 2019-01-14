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

#include "gml_app.h"

//########################//
//### Static Variables ###//
//########################//

gml_app_run_main_cb_t gml_app_run_main_cb = NULL;

//#############//
//### C API ###//
//#############//

void gml_app_run_main_cb_register(gml_app_run_main_cb_t cb) {
    gml_app_run_main_cb = cb;
}

gml_app gml_app_new(int argc, char** argv) {
    try {
        GmlApp* a = new GmlApp(argc, argv);
        return (void*)a;
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

void gml_app_free(gml_app app) {
    GmlApp* a = (GmlApp*)app;
    delete a;
}

int gml_app_exec(gml_app app) {
    try {
        GmlApp* a = (GmlApp*)app;
        return a->app.exec();
    }
    catch (std::exception& e) {
        //api_error_set_msg(err, e.what()); TODO:
        return -1; // TODO:
    }
    catch (...) {
        //api_error_set_unknown_msg(err); TODO:
        return -1; // TODO:
    }
}

int gml_app_quit(gml_app app) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->app.quit();
        return 0; // TODO:
    }
    catch (std::exception& e) {
        //api_error_set_msg(err, e.what()); TODO:
        return -1; // TODO:
    }
    catch (...) {
        //api_error_set_unknown_msg(err); TODO:
        return -1; // TODO:
    }
}

int gml_app_run_main(gml_app app, void* goPtr) {
    try {
        GmlApp* a = (GmlApp*)app;
        emit a->requestRunMain(goPtr);
        return 0; // TODO:
    }
    catch (std::exception& e) {
        //api_error_set_msg(err, e.what()); TODO:
        return -1; // TODO:
    }
    catch (...) {
        //api_error_set_unknown_msg(err); TODO:
        return -1; // TODO:
    }
}

int gml_app_load(gml_app app, const char* url) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->engine.load(QUrl(url));
        return 0; // TODO:
    }
    catch (std::exception& e) {
        //api_error_set_msg(err, e.what()); TODO:
        return -1; // TODO:
    }
    catch (...) {
        //api_error_set_unknown_msg(err); TODO:
        return -1; // TODO:
    }
}

int gml_app_load_data(gml_app app, const char* data) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->engine.loadData(data);
        return 0; // TODO:
    }
    catch (std::exception& e) {
        //api_error_set_msg(err, e.what()); TODO:
        return -1; // TODO:
    }
    catch (...) {
        //api_error_set_unknown_msg(err); TODO:
        return -1; // TODO:
    }
}

int gml_app_set_root_context_property(gml_app app, const char* name, gml_object obj) {
    try {
        GmlApp* a  = (GmlApp*)app;
        QObject* o = (QObject*)obj;
        a->engine.rootContext()->setContextProperty(name, o);
        return 0; // TODO:
    }
    catch (std::exception& e) {
        //api_error_set_msg(err, e.what()); TODO:
        return -1; // TODO:
    }
    catch (...) {
        //api_error_set_unknown_msg(err); TODO:
        return -1; // TODO:
    }
}

//#################//
//### App Class ###//
//#################//

GmlApp::GmlApp(int& argc, char** argv) :
    argc(argc),
    app(this->argc, argv) // use this->argc, because QGuiApplication uses an int reference. https://bugreports.qt.io/browse/QTBUG-59510
{
    QObject::connect(this, &GmlApp::requestRunMain,
                     this, &GmlApp::runMain);
}

void GmlApp::runMain(void* goPtr) {
    try {
        gml_app_run_main_cb(goPtr);
    }
    catch (std::exception& e) {
        cerr << "gml: catched app exception: runMain: " << e.what() << endl;
    }
    catch (...) {
        cerr << "gml: catched app exception: runMain" << endl;
    }
}