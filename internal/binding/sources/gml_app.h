/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

#ifndef GML_APP_H
#define GML_APP_H

#include "gml_includes.h"

class GmlApp : public QObject
{
    Q_OBJECT
private:
    int argc;

public:
    QGuiApplication       app;
    QQmlApplicationEngine engine;

    GmlApp(int& argc, char** argv);

signals:
    void requestRunMain(void* goPtr);

private slots:
    void runMain(void* goPtr);
};

#endif
