#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngine/qtwebengineglobal.h>
#include <QQuickWindow>
#include <QStringList>
#include <iostream>

#include "libbridge.h"

int main(int argc, char **argv)
{
    // init QtWebEngine
    QGuiApplication app(argc, argv);

    // defaults
    QString title = "Photon";
    int width = 1000;
    int height = 1000;
    bool highDPI = true;
    bool fullscreenMode = false;

    // handle highDPI attribute
    if (highDPI) {
        app.setAttribute(Qt::AA_EnableHighDpiScaling);
    }

    // setup engine
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("windowTitle", title);
    engine.rootContext()->setContextProperty("windowWidth", width);
    engine.rootContext()->setContextProperty("windowHeight", height);

    // load QML
    engine.load(QUrl("qrc:/qml/main.qml"));

    // connect engine
    QObject::connect(&engine, SIGNAL(quit()), qApp, SLOT(quit()));

    // handle fullscreen mode
    if (fullscreenMode) {
        QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());
        window->showFullScreen();
    }

    // let's go
    return app.exec();
}