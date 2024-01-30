# 3.21.1 is the minimum required version for static Qt builds.
cmake_minimum_required(VERSION 3.21.1)

# Define the projects and its version.
project(nVision VERSION 0.6.4 LANGUAGES CXX)

# Define custom vars.
set(QT_MIN_VERSION 6.5)
set(APP_NAME ${CMAKE_PROJECT_NAME}-app)

# Set C++20 as minimum that must be supported by the compiler.
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Define which components to load.
find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS 
    Gui
    Quick
)

# Sets project-wide defaults for a typical Qt application.
# See https://doc.qt.io/qt-6/qt-standard-project-setup.html for further information.
qt_standard_project_setup(REQUIRES ${QT_MIN_VERSION})

# Tell CMake that we want to build an executable, not a library.
# It is a wrapper around the built-in add_executable() command, and provides additional logic 
# to automatically handle things like linking of Qt plugins in static Qt builds, 
# platform-specific customization of library names, and so on.
qt_add_executable(${APP_NAME}
    main.cpp
)

# qt_add_qml_module passes the target of the executable, a URI, module version, and a list of 
# QML files to ensure that ${APP_NAME} becomes a QML module. 
# This places the QML files into qrc:/${RESOURCE_PREFIX}/${URI} in the resource file system. 
# Moreover, qt_add_qml_module ensures that qmlcachegen runs. 
# Additionally, it creates a ${APP_NAME}_qmllint target, which runs qmllint on the files in QML_FILES.
qt_add_qml_module(${APP_NAME}
    URI ${CMAKE_PROJECT_NAME}
    RESOURCE_PREFIX /
    QML_FILES
        Main.qml
    RESOURCES
        res/app-icon.png
)

target_include_directories(${APP_NAME} PRIVATE
    ${CMAKE_BINARY_DIR}/lib
)

# Tell CMake which libraries our executable will use.
target_link_libraries(${APP_NAME} PRIVATE 
    Qt6::Gui 
    Qt6::Quick
    ${CMAKE_BINARY_DIR}/lib/go/lib.a
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${APP_NAME} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apptest-qml
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    # Create an application bundle on macOS.
    MACOSX_BUNDLE TRUE
    # Prevent the creation of a console window on Windows.
    WIN32_EXECUTABLE TRUE
)

# Install the application.
include(GNUInstallDirs)
install(TARGETS ${APP_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_generate_deploy_app_script(
    TARGET ${APP_NAME}
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT ${deploy_script})