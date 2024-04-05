# Define the target name.
set(MODULE_TARGET Theme)

# Define a new static library target.
qt_add_library(${MODULE_TARGET} STATIC)

# Set singleton flag.
set_source_files_properties(Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

# Create a new QML module.
# Add all qml source files to it.
qt_add_qml_module(${MODULE_TARGET}
    URI ${MODULE_TARGET}
    QML_FILES Theme.qml
    RESOURCE_PREFIX /${CMAKE_PROJECT_NAME}/qml
)
