/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

#ifndef GML_APP_H
#define GML_APP_H

#include <headers/app.h>

#include <QUrl>
#include <QString>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

class GmlApp {
private:
    int argc;

public:
    QGuiApplication       app;
    QQmlApplicationEngine engine;

    GmlApp(int& argc, char** argv);
};

#endif
