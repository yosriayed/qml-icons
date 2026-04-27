cmake_minimum_required(VERSION 3.21)

project(FontAwesomeIcons LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)
qt_standard_project_setup(REQUIRES 6.8)

option(FONTAWESOME_STYLE_SOLID "Download and include Font Awesome Solid" ON)
option(FONTAWESOME_STYLE_REGULAR "Download and include Font Awesome Regular" OFF)
option(FONTAWESOME_STYLE_BRANDS "Download and include Font Awesome Brands" OFF)
option(FONTAWESOME_BUILD_EXAMPLE "Build the example application" OFF)

set(FONTAWESOME_BASE_URL "https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x")

set(GENERATED_QML_PATH "${CMAKE_CURRENT_SOURCE_DIR}/FontAwesomeIcons.qml")
set(QML_CONTENT "pragma Singleton\nimport QtQuick\n\nQtObject {\n")

set(DEFAULT_FONT_SET FALSE)
set(DOWNLOADED_FONTS "")
set(VARIABLES_FILE "${CMAKE_CURRENT_SOURCE_DIR}/_variables.scss")

# Helper to download and prepare style
macro(prepare_fontawesome_style style_name font_file)
    set(target_font "${CMAKE_CURRENT_SOURCE_DIR}/${font_file}")
    
    set(download_needed TRUE)
    if(EXISTS "${target_font}")
        file(SIZE "${target_font}" font_size)
        if(font_size GREATER 0)
            set(download_needed FALSE)
        endif()
    endif()

    if(download_needed)
        message(STATUS "Downloading Font Awesome ${style_name} font: ${font_file}...")
        file(DOWNLOAD "${FONTAWESOME_BASE_URL}/webfonts/${font_file}" "${target_font}" 
             SHOW_PROGRESS STATUS download_status)
        list(GET download_status 0 status_code)
        if(NOT status_code EQUAL 0)
            message(FATAL_ERROR "Failed to download font: ${font_file}. Status: ${download_status}")
        endif()
    endif()
    
    string(TOLOWER ${style_name} style_lower)
    
    if(NOT DEFAULT_FONT_SET)
        set(QML_CONTENT "${QML_CONTENT}    readonly property alias defaultFont: ${style_lower}Font\n")
        set(QML_CONTENT "${QML_CONTENT}    readonly property alias awesomeFont: ${style_lower}Font\n")
        set(DEFAULT_FONT_SET TRUE)
    endif()
    
    set(QML_CONTENT "${QML_CONTENT}    readonly property FontLoader ${style_lower}Font: FontLoader { id: ${style_lower}Font; source: \"${font_file}\" }\n")
    
    list(APPEND DOWNLOADED_FONTS "${font_file}")
endmacro()

if(FONTAWESOME_STYLE_SOLID)
    prepare_fontawesome_style("Solid" "fa-solid-900.ttf")
endif()

if(FONTAWESOME_STYLE_REGULAR)
    prepare_fontawesome_style("Regular" "fa-regular-400.ttf")
endif()

if(FONTAWESOME_STYLE_BRANDS)
    prepare_fontawesome_style("Brands" "fa-brands-400.ttf")
endif()

# Download variables file if needed
set(download_vars_needed TRUE)
if(EXISTS "${VARIABLES_FILE}")
    file(SIZE "${VARIABLES_FILE}" vars_size)
    if(vars_size GREATER 0)
        set(download_vars_needed FALSE)
    endif()
endif()

if(download_vars_needed)
    message(STATUS "Downloading Font Awesome variables...")
    file(DOWNLOAD "${FONTAWESOME_BASE_URL}/scss/_variables.scss" "${VARIABLES_FILE}" 
         SHOW_PROGRESS STATUS download_status)
    list(GET download_status 0 status_code)
    if(NOT status_code EQUAL 0)
        message(FATAL_ERROR "Failed to download variables. Status: ${download_status}")
    endif()
endif()

# Parse variables into QML properties
if(EXISTS "${VARIABLES_FILE}")
    message(STATUS "Generating FontAwesomeIcons.qml from ${VARIABLES_FILE}...")
    file(STRINGS "${VARIABLES_FILE}" VAR_LINES)
    foreach(line ${VAR_LINES})
        # Regex to match: $fa-var-icon-name: \f000;
        if(line MATCHES "\\$fa-var-([a-zA-Z0-9_-]+):[ \t]*\\\\([a-fA-F0-9]+);")
            set(icon_name ${CMAKE_MATCH_1})
            set(codepoint ${CMAKE_MATCH_2})
            # Prefix all icons with i_ to avoid collisions with reserved keywords
            string(REPLACE "-" "_" icon_name_safe ${icon_name})
            set(icon_name_safe "i_${icon_name_safe}")
            
            # Pad codepoint to 4 digits for valid QML unicode escapes (\uHHHH)
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

qt_add_library(font_awesome STATIC)

# Define the generated file as a singleton
set_source_files_properties("FontAwesomeIcons.qml" PROPERTIES 
    QT_QML_SINGLETON_TYPE TRUE
    QT_RESOURCE_ALIAS "FontAwesomeIcons.qml"
)

# Set aliases for fonts
foreach(font_path ${DOWNLOADED_FONTS})
    set_source_files_properties("${font_path}" PROPERTIES QT_RESOURCE_ALIAS "${font_path}")
endforeach()

qt_add_qml_module(font_awesome
    URI "FontAwesomeIcons"
    VERSION 1.0
    QML_FILES
        FontAwesomeIcon.qml
        FontAwesomeIcons.qml
    RESOURCES
        ${DOWNLOADED_FONTS}
)

target_link_libraries(font_awesome PRIVATE Qt6::Core Qt6::Quick)

# Add an alias for easier consumption
add_library(FontAwesomeIcons_plugin ALIAS font_awesomeplugin)

if(FONTAWESOME_BUILD_EXAMPLE)
    add_subdirectory(example)
endif()
