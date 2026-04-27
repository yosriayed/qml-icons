cmake_minimum_required(VERSION 3.21)

project(LucideIcons LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)
qt_standard_project_setup(REQUIRES 6.8)

option(LUCIDE_ICONS_BUILD_EXAMPLE "Build the example application" OFF)

set(LUCIDE_ICONS_BASE_URL "https://unpkg.com/lucide-static@latest/font")

set(GENERATED_QML_PATH "${CMAKE_CURRENT_SOURCE_DIR}/LucideIcons.qml")
set(QML_CONTENT "pragma Singleton\nimport QtQuick\n\nQtObject {\n")

set(FONT_FILE "lucide.ttf")
set(CSS_FILE "lucide.css")

set(target_font "${CMAKE_CURRENT_SOURCE_DIR}/${FONT_FILE}")
set(target_css "${CMAKE_CURRENT_SOURCE_DIR}/${CSS_FILE}")

# Download font
set(download_needed TRUE)
if(EXISTS "${target_font}")
    file(SIZE "${target_font}" font_size)
    if(font_size GREATER 0)
        set(download_needed FALSE)
    endif()
endif()

if(download_needed)
    message(STATUS "Downloading Lucide font...")
    file(DOWNLOAD "${LUCIDE_ICONS_BASE_URL}/${FONT_FILE}" "${target_font}" 
         SHOW_PROGRESS STATUS download_status)
    list(GET download_status 0 status_code)
    if(NOT status_code EQUAL 0)
        message(FATAL_ERROR "Failed to download Lucide font. Status: ${download_status}")
    endif()
endif()

# Download CSS
set(download_css_needed TRUE)
if(EXISTS "${target_css}")
    file(SIZE "${target_css}" css_size)
    if(css_size GREATER 0)
        set(download_css_needed FALSE)
    endif()
endif()

if(download_css_needed)
    message(STATUS "Downloading Lucide CSS metadata...")
    file(DOWNLOAD "${LUCIDE_ICONS_BASE_URL}/${CSS_FILE}" "${target_css}" 
         SHOW_PROGRESS STATUS download_status)
    list(GET download_status 0 status_code)
    if(NOT status_code EQUAL 0)
        message(FATAL_ERROR "Failed to download Lucide CSS. Status: ${download_status}")
    endif()
endif()

# Setup FontLoader
set(QML_CONTENT "${QML_CONTENT}    readonly property alias defaultFont: lucideFont\n")
set(QML_CONTENT "${QML_CONTENT}    readonly property FontLoader lucideFont: FontLoader { id: lucideFont; source: \"${FONT_FILE}\" }\n")

# Parse CSS into QML properties
if(EXISTS "${target_css}")
    message(STATUS "Generating LucideIcons.qml from ${target_css}...")
    file(STRINGS "${target_css}" CSS_LINES)
    foreach(line ${CSS_LINES})
        # Regex to match: .icon-house::before { content: "\ea01"; }
        if(line MATCHES "\\.icon-([a-zA-Z0-9_-]+)::before[ \t]*{[ \t]*content:[ \t]*\"\\\\([a-fA-F0-9]+)\";[ \t]*}")
            set(icon_name ${CMAKE_MATCH_1})
            set(codepoint ${CMAKE_MATCH_2})
            
            # Prefix all icons with i_ and replace hyphens
            string(REPLACE "-" "_" icon_name_safe ${icon_name})
            set(icon_name_safe "i_${icon_name_safe}")
            
            # Pad codepoint to 4 digits
            string(LENGTH "${codepoint}" cp_len)
            if(cp_len EQUAL 1)
                set(codepoint "000${codepoint}")
            elseif(cp_len EQUAL 2)
                set(codepoint "00${codepoint}")
            elseif(cp_len EQUAL 3)
                set(codepoint "0${codepoint}")
            endif()
            
            set(QML_CONTENT "${QML_CONTENT}    readonly property string ${icon_name_safe}: \"\\u${codepoint}\"\n")
        endif()
    endforeach()
endif()

set(QML_CONTENT "${QML_CONTENT}}\n")
file(WRITE "${GENERATED_QML_PATH}" "${QML_CONTENT}")

qt_add_library(lucide_icons STATIC)

# Define the generated file as a singleton
set_source_files_properties("LucideIcons.qml" PROPERTIES 
    QT_QML_SINGLETON_TYPE TRUE
    QT_RESOURCE_ALIAS "LucideIcons.qml"
)

# Set alias for font
set_source_files_properties("${FONT_FILE}" PROPERTIES QT_RESOURCE_ALIAS "${FONT_FILE}")

qt_add_qml_module(lucide_icons
    URI "LucideIcons"
    VERSION 1.0
    QML_FILES
        LucideIcon.qml
        LucideIcons.qml
    RESOURCES
        ${FONT_FILE}
)

target_link_libraries(lucide_icons PRIVATE Qt6::Core Qt6::Quick)

# Add an alias for easier consumption
add_library(LucideIcons_plugin ALIAS lucide_iconsplugin)

if(LUCIDE_ICONS_BUILD_EXAMPLE)
    add_subdirectory(example)
endif()
