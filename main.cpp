// Qt imports.
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStringLiteral>
#include <QDirIterator>

// Add qml module plugins.
#include <QtQml/QQmlExtensionPlugin>
Q_IMPORT_QML_PLUGIN(BackendPlugin)
Q_IMPORT_QML_PLUGIN(ExternalPlugin)
Q_IMPORT_QML_PLUGIN(ImgProvPlugin)

// Import libs.
#include <go/go.h>

// A debug function to print all files contained within the Qt resource system.
// Sometimes, it is just not clear where certain files are added, so this can help.
void printQtResources(bool ignoreQtProject=false) {
    QDirIterator it(":", QDirIterator::Subdirectories);
    while (it.hasNext()) {
        QFileInfo next = it.nextFileInfo();
        if (next.isDir() || (ignoreQtProject && next.filePath().startsWith(":/qt-project.org"))) {
            continue;
        }
        qDebug() << next.filePath();
    }
}

int main(int argc, char *argv[]) {
#if (DEBUG)
    std::cout << "DEBUG MODE" << std::endl;
#endif

    // TODO: Debug
    printQtResources(true);

    // Include the virtual keyboard plugin.
    //qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    // Create the application from the args.
    QGuiApplication app(argc, argv);

    // Set meta data.
    app.setApplicationName(QStringLiteral("nVision"));
    app.setApplicationVersion(QStringLiteral("v0.6.4"));
    app.setOrganizationName(QStringLiteral("nLine GmbH"));
    app.setOrganizationDomain(QStringLiteral("nline.ai"));

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

    // Add the custom paths to the imports.
    engine.addImportPath(QStringLiteral(":/nVision/cpp"));
    engine.addImportPath(QStringLiteral(":/nVision/qml"));

    // Load the main qml file.
#if (DEBUG)
    engine.load("./Main.qml");
#else
    engine.loadFromModule("nVision", "Main");
#endif

    // Run the app.
    return app.exec();
}
