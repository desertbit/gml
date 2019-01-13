/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

#include "gml_includes.h"

//#############//
//### C API ###//
//#############//

gml_variant gml_variant_new() {
    try {
        QVariant* v = new QVariant();
        return (void*)v;
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

void gml_variant_free(gml_variant vv) {
    QVariant* v = (QVariant*)vv;
    delete v;
}