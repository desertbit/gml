QT       += core qml quick

TEMPLATE = lib
CONFIG += staticlib

HEADERS += headers/*.h
SOURCES += sources/*.cpp

OBJECTS_DIR = ./build
MOC_DIR = ./build
UI_DIR = ./build
TARGET = ./build/binding