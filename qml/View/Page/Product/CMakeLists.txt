# Define the target name.
set(MODULE_TARGET ViewPageProduct)

# Define a new static library target.
qt_add_library(${MODULE_TARGET} STATIC)

# Create a new QML module.
# Add all qml source files to it.
file(GLOB QML_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.qml)
qt_add_qml_module(${MODULE_TARGET}
    URI View.Page.Product
    QML_FILES ${QML_SOURCES}
    RESOURCE_PREFIX /${CMAKE_PROJECT_NAME}/qml
)
