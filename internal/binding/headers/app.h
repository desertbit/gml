/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

#ifndef GML_HEADER_APP_H
#define GML_HEADER_APP_H

#ifdef __cplusplus
extern "C" {
#endif

#include "object.h"

typedef void* gml_app;

gml_app gml_app_new (int argv, char** argc);
void    gml_app_free(gml_app app);
int     gml_app_exec(gml_app app);
int     gml_app_quit(gml_app app);

int     gml_app_load     (gml_app app, const char* url);
int     gml_app_load_data(gml_app app, const char* data);

int     gml_app_set_root_context_property(gml_app app, const char* name, gml_object obj);

#ifdef __cplusplus
}
#endif

#endif
