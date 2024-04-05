# Define the target name.
set(MODULE_TARGET Store)

# Define a new static library target.
qt_add_library(${MODULE_TARGET} STATIC)

# Set singleton flag.
set_source_files_properties(Store.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

# Set internal flag for internal files.
file(GLOB INTERNAL_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} 
    Main.qml
    *.js
    */*.js
)
set_source_files_properties(${INTERNAL_FILES} PROPERTIES QT_QML_INTERNAL_TYPE TRUE)

# Create a new QML module.
# Add all qml source files to it.
qt_add_qml_module(${MODULE_TARGET}
    URI ${MODULE_TARGET}
    QML_FILES Store.qml
    RESOURCES ${INTERNAL_FILES}
    RESOURCE_PREFIX /${CMAKE_PROJECT_NAME}/qml
)
