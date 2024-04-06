# 3.21.1 is the minimum required version for static Qt builds.
cmake_minimum_required(VERSION 3.21.1)

# Include debugging helpers.
# -> cmake_print_variables(MY_VARIABLE)
include(CMakePrintHelpers)

# Define the projects and its version.
project(nVision VERSION 0.6.4 LANGUAGES CXX)

# Configuration options.
add_compile_definitions("DEBUG=$<CONFIG:Debug>")

# Define custom vars.
set(QT_MIN_VERSION 6.5)
set(APP_TARGET ${CMAKE_PROJECT_NAME}-app)
set(ORGANIZATION_URL nline.ai)

# Set C++20 as minimum that must be supported by the compiler.
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Generate compile_commands.json for clangd in the build directory.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set the qml directory as qml output dir.
# This makes it possible to group the qml modules under a common prefix.
# Otherwise, the modules would have to be all in the root directory.
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)

# Define which components to load.
find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS 
    Gui
    Qml
    Quick
    LinguistTools
)

# Sets project-wide defaults for a typical Qt application.
# See https://doc.qt.io/qt-6/qt-standard-project-setup.html for further information.
qt_standard_project_setup(REQUIRES ${QT_MIN_VERSION})

# Tell CMake that we want to build an executable, not a library.
# It is a wrapper around the built-in add_executable() command, and provides additional logic 
# to automatically handle things like linking of Qt plugins in static Qt builds, 
# platform-specific customization of library names, and so on.
qt_add_executable(${APP_TARGET}
    main.cpp
    imgprov.hpp
    imgprov.cpp
)

# The main QML module which gets added as an executable.
qt_add_qml_module(${APP_TARGET}
    URI ${CMAKE_PROJECT_NAME}
    QML_FILES qml/Main.qml qml/main.js
)

# Add source directories containing cpp libraries.
add_subdirectory(cpp/backend)

# Add QML modules.
# Later we need to link against the static plugins of each module.
# The name of a plugin is "<qml-module-uri>plugin" (e.g. qml/View/Component/Text -> ViewComponentTextplugin).
file(GLOB QML_MODULES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} LIST_DIRECTORIES true 
    "qml/Action"
    "qml/Dispatcher"
    "qml/Lib"
    "qml/Middleware"
    "qml/Store"
    "qml/Store/Model"
    "qml/Theme"
    "qml/View/Component/*"
    "qml/View/Page/*"
)
set(QML_MODULES_PLUGINS "")
foreach(item ${QML_MODULES})
	if(IS_DIRECTORY ${item})
		add_subdirectory(${item})

        # Add its plugin.
        string(REPLACE "qml" "" item_plugin ${item})
        string(REPLACE "/" "" item_plugin ${item_plugin})
        string(APPEND item_plugin "plugin")
        list(APPEND QML_MODULES_PLUGINS ${item_plugin})
	endif()
endforeach()

# Add resources.
file(GLOB RESOURCES_IMAGES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} resources/images/*)
qt_add_resources(${APP_TARGET} resourcesimages
    PREFIX /images
    BASE resources/images
    FILES ${RESOURCES_IMAGES}
)

# Add translations.
# We generate the .ts files manually via lupdate using a grml command,
# since qt_add_translations can not merge all .ts files of all submodules into
# one file, requiring a lot of manual labour to keep everything in sync.
file(GLOB TS_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} resources/translations/*.ts)
qt_add_translations(${APP_TARGET}
    TS_FILES ${TS_FILES}
    RESOURCE_PREFIX /translations
)

# Include our source directory for convenient header import.
# This allows to use e.g. "#include <go/go.h>".
target_include_directories(${APP_TARGET} PRIVATE ${CMAKE_BINARY_DIR})

# Tell CMake which libraries our executable will use.
target_link_libraries(${APP_TARGET} PRIVATE 
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    ${CMAKE_BINARY_DIR}/go/go.a
    backendplugin
    ${QML_MODULES_PLUGINS}
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${APP_TARGET} PROPERTIES
    #MACOSX_BUNDLE_GUI_IDENTIFIER company.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    # Create an application bundle on macOS.
    MACOSX_BUNDLE TRUE
    # Prevent the creation of a console window on Windows.
    WIN32_EXECUTABLE TRUE
)

# Install the application.
include(GNUInstallDirs)
install(TARGETS ${APP_TARGET}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Generate an install script.
qt_generate_deploy_app_script(
    TARGET ${APP_TARGET}
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT ${deploy_script})