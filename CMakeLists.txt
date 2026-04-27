cmake_minimum_required(VERSION 3.21)

project(qml_icons LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)
qt_standard_project_setup(REQUIRES 6.8)

option(QML_ICONS_BUILD_MATERIAL "Build MaterialIcons module" ON)
option(QML_ICONS_BUILD_FONTAWESOME "Build FontAwesomeIcons module" ON)
option(QML_ICONS_BUILD_LUCIDE "Build LucideIcons module" ON)

if(QML_ICONS_BUILD_MATERIAL)
    add_subdirectory(MaterialIcons)
endif()

if(QML_ICONS_BUILD_FONTAWESOME)
    add_subdirectory(FontAwesomeIcons)
endif()

if(QML_ICONS_BUILD_LUCIDE)
    add_subdirectory(LucideIcons)
endif()
