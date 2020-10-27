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

#ifndef GML_APP_H
#define GML_APP_H

#include "gml_object.h"
#include "gml_includes.h"
#include "gml_error.h"
#include "gml_image_provider.h"
#include "gml_image_item.h"
#include "gml_variant.h"

//####################//
//### Go Callbacks ###//
//####################//

#ifdef __cplusplus
extern "C" {
#endif


#ifdef __cplusplus
}
#endif

//#############//
//### C API ###//
//#############//

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* gml_app;

    void gml_app_init(int argv, char** argc, gml_error err);
    int  gml_app_exec(gml_error err);
    void gml_app_quit();
    int  gml_app_run_main(void* go_ptr);

    int  gml_app_load(const char* url, gml_error err);
    int  gml_app_load_data(const char* data, gml_error err);
    void gml_app_add_import_path(const char* path);
    int  gml_app_add_imageprovider(const char* id, gml_image_provider ip, gml_error err);

    int  gml_app_set_root_context_property_object(const char* name, gml_object obj, gml_error err);
    int  gml_app_set_root_context_property_variant(const char* name, gml_variant gml_v, gml_error err);
    void gml_app_set_application_name(const char* name);
    void gml_app_set_organization_name(const char* name);
    void gml_app_set_application_version(const char* version);

    double gml_app_get_dp(gml_error err);

#ifdef __cplusplus
}
#endif

//###########//
//### C++ ###//
//###########//

#ifdef __cplusplus
    class GmlApp : public QObject {
        Q_OBJECT
    private:
        int argc_;

        static GmlApp* instance_;

        GmlApp(int& argc, char** argv);

    public:
        QGuiApplication       app;
        QQmlApplicationEngine engine;

        static void Initialize();
        static GmlApp* Instance();

    signals:
        void requestRunMain(void* goPtr);
        void imageItemChanged(const QString id);

    private slots:
        void runMain(void* goPtr);
    };
#endif

#endif
