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

GmlApp* GmlApp::globalApp = NULL;

//#############//
//### C API ###//
//#############//

void gml_app_run_main_cb_register(gml_app_run_main_cb_t cb) {
    gml_app_run_main_cb = cb;
}

gml_app gml_app_new(int argc, char** argv, gml_error err) {
    try {
        // Initialize the Qt resources and plugins.
        Q_INIT_RESOURCE(gml_gen_resources);

        GmlApp* a = new GmlApp(argc, argv);
        return (gml_app)a;
    }
    catch (std::exception& e) {
        gml_error_set_msg(err, e.what());
        return NULL;
    }
    catch (...) {
        gml_error_set_catched_exception_msg(err);
        return NULL;
    }
}

void gml_app_free(gml_app app) {
    if (app == NULL) {
        return;
    }
    GmlApp* a = (GmlApp*)app;
    delete a;
    app = NULL;
}

int gml_app_exec(gml_app app, gml_error err) {
    try {
        GmlApp* a = (GmlApp*)app;
        return a->app.exec();
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

void gml_app_quit(gml_app app) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->app.quit();
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

int gml_app_run_main(gml_app app, void* go_ptr) {
    try {
        GmlApp* a = (GmlApp*)app;
        emit a->requestRunMain(go_ptr);
        return 0;
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

int gml_app_load(gml_app app, const char* url, gml_error err) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->engine.load(QUrl(url));
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

int gml_app_load_data(gml_app app, const char* data, gml_error err) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->engine.loadData(data);
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

void gml_app_add_import_path(gml_app app, const char* path) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->engine.addImportPath(path);
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

int gml_app_add_imageprovider(gml_app app, const char* id, gml_image_provider ip, gml_error err) {
    try {
        GmlApp* a = (GmlApp*)app;
        GmlImageProvider* gip = (GmlImageProvider*)ip;
        a->engine.addImageProvider(id, gip);
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

int gml_app_set_root_context_property_object(gml_app app, const char* name, gml_object obj, gml_error err) {
    try {
        GmlApp* a  = (GmlApp*)app;
        QObject* o = (QObject*)obj;
        a->engine.rootContext()->setContextProperty(name, o);
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

int gml_app_set_root_context_property_variant(gml_app app, const char* name, gml_variant gml_v, gml_error err) {
    try {
        GmlApp* a  = (GmlApp*)app;

        // Create a copy.
        QVariant v(*((QVariant*)gml_v));

        a->engine.rootContext()->setContextProperty(name, v);
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

void gml_app_set_application_name(gml_app app, const char* name) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->app.setApplicationName(QString(name));
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_app_set_organization_name(gml_app app, const char* name) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->app.setOrganizationName(QString(name));
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_app_set_application_version(gml_app app, const char* version) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->app.setApplicationVersion(QString(version));
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

void gml_app_set_window_icon(gml_app app, const char* name) {
    try {
        GmlApp* a = (GmlApp*)app;
        a->app.setWindowIcon(QIcon(name));
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

int gml_app_switch_language(gml_app app, const char* language, gml_error err) {
    try {
        GmlApp* a  = (GmlApp*)app;
        
        // If this language is already installed, do nothing.
        string lang = language;
        if (a->language == lang) {
            return 0;
        }

        // Remove current translator.
        if (!a->translator.isEmpty()) {
            a->app.removeTranslator(&a->translator);
        }

        a->translator.load(QStringLiteral(":/resources/languages/app_") + QString(language));
        a->app.installTranslator(&a->translator);
        a->engine.retranslate();

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

double gml_app_get_dp(gml_app app, gml_error err) {
    try {
        GmlApp* a  = (GmlApp*)app;
        QScreen* qs = a->app.primaryScreen();
        return qs->devicePixelRatio() * qs->logicalDotsPerInch();
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

//#################//
//### App Class ###//
//#################//

GmlApp::GmlApp(int& argc, char** argv) :
    argc(argc),
    app(this->argc, argv) // use this->argc, because QGuiApplication uses an int reference. https://bugreports.qt.io/browse/QTBUG-59510
{
    QObject::connect(this, &GmlApp::requestRunMain,
                     this, &GmlApp::runMain);

    // Register custom QML types.
    qmlRegisterType<GmlImageItem>("Gml", 1, 0, "ImageItem");

    // Set the global app pointer.
    globalApp = this;
}

GmlApp* GmlApp::App() {
    return globalApp;
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