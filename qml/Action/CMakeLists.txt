# Define the target name.
set(MODULE_TARGET Action)

# Define a new static library target.
qt_add_library(${MODULE_TARGET} STATIC)

# We want to set custom source type names for our js modules.
# These names are the type identifiers used in the generated qmldir.
file(GLOB JS_MODULES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} */*.js)
foreach(item ${JS_MODULES})
    # Get directory name of module.
    cmake_path(GET item PARENT_PATH moduleName)
    # Get name of js file.
    cmake_path(GET item STEM jsFile)

    if(moduleName STREQUAL jsFile)
        # If the js file has the module name, make it accesible under the module name.
        set_source_files_properties(${item} PROPERTIES QT_QML_SOURCE_TYPENAME ${moduleName})
    else()
        # Prepend the name of the js file with the module name.
        set_source_files_properties(${item} PROPERTIES QT_QML_SOURCE_TYPENAME "${moduleName}${jsFile}")
    endif()
endforeach()

# Create a new QML module.
qt_add_qml_module(${MODULE_TARGET}
    URI Action
    QML_FILES ${JS_MODULES}
    RESOURCE_PREFIX /${CMAKE_PROJECT_NAME}/qml
)
