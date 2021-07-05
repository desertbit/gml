cmake_minimum_required(VERSION 3.1.0)

project(test)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if(CMAKE_VERSION VERSION_LESS "3.7.0")
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
endif()

# TODO:
#set(Qt5_USE_STATIC_LIBS ON)
#set(Qt5_USE_STATIC_RUNTIME ON)

find_package(Qt5 COMPONENTS Widgets Qml Quick REQUIRED)

add_executable(test
    main.cpp
    resources.qrc
)

target_link_libraries(test Qt5::Widgets Qt5::Qml Qt5::Quick )#-static)