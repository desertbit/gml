QT += core qml quick

TEMPLATE = app

CONFIG += release staticlib c++11


HEADERS += ./*.h
SOURCES += ./*.cpp
RESOURCES += ./*.qrc

#OBJECTS_DIR = /home/r0l1/projects/github/desertbit/gml-samples/gallery/build
#MOC_DIR = /home/r0l1/projects/github/desertbit/gml-samples/gallery/build
#UI_DIR = /home/r0l1/projects/github/desertbit/gml-samples/gallery/build
#DESTDIR = /home/r0l1/projects/github/desertbit/gml-samples/gallery/build

TARGET = test
