# Define the target name.
set(MODULE_TARGET ActionProduct)

# Define a new static library target.
qt_add_library(${MODULE_TARGET} STATIC)

# Create a new QML module.
# Add all qml source files to it.
file(GLOB QML_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.js)
qt_add_qml_module(${MODULE_TARGET}
    URI Action.Product
    QML_FILES ${QML_SOURCES}
    RESOURCE_PREFIX /${CMAKE_PROJECT_NAME}/qml
)
