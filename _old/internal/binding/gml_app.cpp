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

//#############//
//### C API ###//
//#############//

void gml_app_init(int argc, char** argv, gml_error err) {
    try {
        // Initialize the Qt resources and plugins.
        Q_INIT_RESOURCE(gml_gen_resources);

        GmlApp::Initialize(argc, argv);
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
    }
    catch (...) {
        gml_error_set_catched_exception_msg(err);
    }
}

int gml_app_exec(gml_error err) {
    try {
        GmlApp* a = GmlApp::Instance();
        return a->app.exec();
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
    }
    catch (...) {
        gml_error_set_catched_exception_msg(err);
    }
    return -1;
}

void gml_app_quit() {
    try {
        GmlApp* a = GmlApp::Instance();
        a->app.quit();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

int gml_app_run_main(void* go_ptr) {
    try {
        GmlApp* a = GmlApp::Instance();
        emit a->requestRunMain(go_ptr);
        return 0;
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
    return -1;
}

int gml_app_load(const char* url, gml_error err) {
    try {
        GmlApp* a = GmlApp::Instance();
        a->engine.load(QUrl(url));
        return 0;
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
    }
    catch (...) {
        gml_error_set_catched_exception_msg(err);
    }
    return -1;
}

int gml_app_load_data(const char* data, gml_error err) {
    try {
        GmlApp* a = GmlApp::Instance();
        a->engine.loadData(data);
        return 0;
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
    }
    catch (...) {
        gml_error_set_catched_exception_msg(err);
    }
    return -1;
}

void gml_app_add_import_path(const char* path) {
    try {
        GmlApp* a = GmlApp::Instance();
        a->engine.addImportPath(path);
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

int gml_app_add_imageprovider(const char* id, gml_image_provider ip, gml_error err) {
    try {
        GmlApp* a = GmlApp::Instance();
        GmlImageProvider* gip = (GmlImageProvider*)ip;
        a->engine.addImageProvider(id, gip);
        return 0; 
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
    }
    catch (...) {
        gml_error_set_catched_exception_msg(err);
    }
    return -1;
}

int gml_app_set_root_context_property_object(const char* name, gml_object obj, gml_error err) {
    try {
        GmlApp* a  = GmlApp::Instance();
        QObject* o = (QObject*)obj;
        a->engine.rootContext()->setContextProperty(name, o);
        return 0;
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
    }
    catch (...) {
        gml_error_set_catched_exception_msg(err);
    }
    return -1;
}

int gml_app_set_root_context_property_variant(const char* name, gml_variant gml_v, gml_error err) {
    try {
        GmlApp* a  = GmlApp::Instance();

        // Create a copy.
        QVariant v(*((QVariant*)gml_v));

        a->engine.rootContext()->setContextProperty(name, v);
        return 0;
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
    }
    catch (...) {
        gml_error_set_catched_exception_msg(err);
    }
    return -1;
}

void gml_app_set_application_name(const char* name) {
    try {
        GmlApp* a = GmlApp::Instance();
        a->app.setApplicationName(QString(name));
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_app_set_organization_name(const char* name) {
    try {
        GmlApp* a = GmlApp::Instance();
        a->app.setOrganizationName(QString(name));
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_app_set_application_version(const char* version) {
    try {
        GmlApp* a = GmlApp::Instance();
        a->app.setApplicationVersion(QString(version));
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

double gml_app_get_dp(gml_error err) {
    try {
        GmlApp* a  = GmlApp::Instance();
        QScreen* qs = a->app.primaryScreen();
        return qs->devicePixelRatio() * qs->logicalDotsPerInch();
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
    }
    catch (...) {
        gml_error_set_catched_exception_msg(err);
    }
    return -1;
}

//###########//
//### C++ ###//
//###########//

// Static members.
GmlApp* GmlApp::instance = NULL;

GmlApp::GmlApp(int& argc, char** argv) :
    argc(argc),
    app(this->argc, argv) // use this->argc, because QGuiApplication uses an int reference. https://bugreports.qt.io/browse/QTBUG-59510
{
    QObject::connect(this, &GmlApp::requestRunMain, this, &GmlApp::runMain);

    // Register custom QML types.
    qmlRegisterType<GmlImageItem>("Gml", 1, 0, "ImageItem");
}

void GmlApp::Initialize(int& argc, char** argv) {
    instance = new GmlApp(argc, argv)
}

GmlApp* GmlApp::Instance() {
    return instance;
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