QT       += qml quick

TEMPLATE = app

SOURCES += main.cpp
RESOURCES += resources.qrc
LIBS += -L./ -lbridge

OBJECTS_DIR = ./objects
MOC_DIR = ./moc
UI_DIR = ./ui
TARGET = ./bin/app