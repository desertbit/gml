/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

#include "app.h"

//#############//
//### C API ###//
//#############//

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

//#################//
//### App Class ###//
//#################//

GmlApp::GmlApp(int& argc, char** argv) :
    argc(argc),
    app(this->argc, argv) // use this->argc, because QGuiApplication uses an int reference. https://bugreports.qt.io/browse/QTBUG-59510
{}