# Define the target name.
set(MODULE_TARGET imgprovplugin)

# Create a new QML module.
file(GLOB HEADERS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.hpp)
file(GLOB SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.cpp)
qt_add_qml_module(${MODULE_TARGET}
    URI ImgProv
    PLUGIN_TARGET ${MODULE_TARGET}
    RESOURCE_PREFIX /${CMAKE_PROJECT_NAME}/qml
    NO_PLUGIN_OPTIONAL
    NO_GENERATE_PLUGIN_SOURCE
    CLASS_NAME ImgProvPlugin
    SOURCES ${HEADERS} ${SOURCES}
)

# Link dependencies.
target_link_libraries(${MODULE_TARGET} PRIVATE 
    Qt6::Core 
    Qt6::Gui 
    Qt6::Quick
    Qt6::Qml
)
