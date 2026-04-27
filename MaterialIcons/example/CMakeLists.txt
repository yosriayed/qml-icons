cmake_minimum_required(VERSION 3.21)

project(material_example LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(material_example_app main.cpp)

qt_add_qml_module(material_example_app
    URI "Main"
    VERSION 1.0
    QML_FILES main.qml
)

target_link_libraries(material_example_app PRIVATE
    Qt6::Core
    Qt6::Quick
    MaterialIcons_plugin
)
