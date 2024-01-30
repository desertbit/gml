#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "build/go/lib.h"

int main(int argc, char *argv[]) {
    // Test call to our Go library.
    Test();

    // Include the virtual keyboard plugin.
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    // Create the application from the args.
    QGuiApplication app(argc, argv);

    // Create the engine.
    QQmlApplicationEngine engine;

    // Connect to the object creaton failed signal.
    // Quit, if such an error occurs.
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
    );

    // Load our main qml file.
    engine.loadFromModule("nVision", "Main");

    // Run the app.
    return app.exec();
}
