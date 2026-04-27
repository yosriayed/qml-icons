cmake_minimum_required(VERSION 3.21)

project(material_icons_qml LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)
qt_standard_project_setup(REQUIRES 6.8)

option(MATERIAL_ICONS_STYLE_OUTLINED "Download and include Material Icons Outlined" ON)
option(MATERIAL_ICONS_STYLE_ROUNDED "Download and include Material Icons Rounded" ON)
option(MATERIAL_ICONS_STYLE_SHARP "Download and include Material Icons Sharp" ON)
option(MATERIAL_ICONS_BUILD_EXAMPLE "Build the example application" ON)

set(MATERIAL_ICONS_BASE_URL "https://github.com/google/material-design-icons/raw/master/variablefont")

set(GENERATED_QML_PATH "${CMAKE_CURRENT_SOURCE_DIR}/MaterialIcons.qml")
set(QML_CONTENT "pragma Singleton\nimport QtQuick\n\nQtObject {\n")

set(DEFAULT_FONT_SET FALSE)
set(DOWNLOADED_FONTS "")
set(LATEST_CODEPOINTS_FILE "")

# Helper to download and prepare style
macro(prepare_material_style style_name font_file codepoints_file)
    # Sanitize filenames for local storage and QML compatibility
    string(REPLACE "[" "_" font_file_safe "${font_file}")
    string(REPLACE "]" "_" font_file_safe "${font_file_safe}")
    string(REPLACE "," "_" font_file_safe "${font_file_safe}")
    
    string(REPLACE "[" "_" codepoints_file_safe "${codepoints_file}")
    string(REPLACE "]" "_" codepoints_file_safe "${codepoints_file_safe}")
    string(REPLACE "," "_" codepoints_file_safe "${codepoints_file_safe}")

    set(target_font "${CMAKE_CURRENT_SOURCE_DIR}/${font_file_safe}")
    set(target_codepoints "${CMAKE_CURRENT_SOURCE_DIR}/${codepoints_file_safe}")
    
    # Escape brackets for the URL
    string(REPLACE "[" "%5B" font_url_part "${font_file}")
    string(REPLACE "]" "%5D" font_url "${font_url_part}")
    string(REPLACE "[" "%5B" codepoints_url_part "${codepoints_file}")
    string(REPLACE "]" "%5D" codepoints_url "${codepoints_url_part}")

    set(download_needed TRUE)
    if(EXISTS "${target_font}")
        file(SIZE "${target_font}" font_size)
        if(font_size GREATER 0)
            set(download_needed FALSE)
        endif()
    endif()

    if(download_needed)
        message(STATUS "Downloading Material Icons ${style_name} font: ${font_file}...")
        file(DOWNLOAD "${MATERIAL_ICONS_BASE_URL}/${font_url}" "${target_font}" 
             SHOW_PROGRESS STATUS download_status)
        list(GET download_status 0 status_code)
        if(NOT status_code EQUAL 0)
            message(FATAL_ERROR "Failed to download font: ${font_file}. Status: ${download_status}")
        endif()
    endif()
    
    set(download_codepoints_needed TRUE)
    if(EXISTS "${target_codepoints}")
        file(SIZE "${target_codepoints}" codepoints_size)
        if(codepoints_size GREATER 0)
            set(download_codepoints_needed FALSE)
        endif()
    endif()

    if(download_codepoints_needed)
        message(STATUS "Downloading Material Icons ${style_name} codepoints: ${codepoints_file}...")
        file(DOWNLOAD "${MATERIAL_ICONS_BASE_URL}/${codepoints_url}" "${target_codepoints}" 
             SHOW_PROGRESS STATUS download_status)
        list(GET download_status 0 status_code)
        if(NOT status_code EQUAL 0)
            message(FATAL_ERROR "Failed to download codepoints: ${codepoints_file}. Status: ${download_status}")
        endif()
    endif()
    
    string(TOLOWER ${style_name} style_lower)
    
    if(NOT DEFAULT_FONT_SET)
        set(QML_CONTENT "${QML_CONTENT}    readonly property alias materialFont: ${style_lower}Font\n")
        set(DEFAULT_FONT_SET TRUE)
    endif()
    
    set(QML_CONTENT "${QML_CONTENT}    readonly property FontLoader ${style_lower}Font: FontLoader { id: ${style_lower}Font; source: \"${font_file_safe}\" }\n")
    
    list(APPEND DOWNLOADED_FONTS "${font_file_safe}")
    set(LATEST_CODEPOINTS_FILE "${target_codepoints}")
endmacro()

if(MATERIAL_ICONS_STYLE_OUTLINED)
    prepare_material_style("Outlined" "MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf" "MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].codepoints")
endif()

if(MATERIAL_ICONS_STYLE_ROUNDED)
    prepare_material_style("Rounded" "MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf" "MaterialSymbolsRounded[FILL,GRAD,opsz,wght].codepoints")
endif()

if(MATERIAL_ICONS_STYLE_SHARP)
    prepare_material_style("Sharp" "MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf" "MaterialSymbolsSharp[FILL,GRAD,opsz,wght].codepoints")
endif()

# Parse codepoints into QML properties
if(LATEST_CODEPOINTS_FILE)
    message(STATUS "Generating MaterialIcons.qml from ${LATEST_CODEPOINTS_FILE}...")
    file(STRINGS "${LATEST_CODEPOINTS_FILE}" CODEPOINT_LINES)
    foreach(line ${CODEPOINT_LINES})
        if(line MATCHES "^([a-zA-Z0-9_]+) ([a-f0-9]+)$")
            set(icon_name ${CMAKE_MATCH_1})
            set(codepoint ${CMAKE_MATCH_2})
            # Prefix all icons with i_ to avoid collisions with reserved keywords (e.g. case, switch, default)
            set(icon_name "i_${icon_name}")
            set(QML_CONTENT "${QML_CONTENT}    readonly property string ${icon_name}: \"\\u${codepoint}\"\n")
        endif()
    endforeach()
endif()

set(QML_CONTENT "${QML_CONTENT}}\n")
file(WRITE "${GENERATED_QML_PATH}" "${QML_CONTENT}")

qt_add_library(material_icons STATIC)

# Define the generated file as a singleton and set alias for resource system
set_source_files_properties("MaterialIcons.qml" PROPERTIES 
    QT_QML_SINGLETON_TYPE TRUE
    QT_RESOURCE_ALIAS "MaterialIcons.qml"
)

# Set aliases for downloaded fonts so they are accessible via their filename in the resource system
foreach(font_path ${DOWNLOADED_FONTS})
    get_filename_component(font_name "${font_path}" NAME)
    set_source_files_properties("${font_path}" PROPERTIES QT_RESOURCE_ALIAS "${font_name}")
endforeach()

qt_add_qml_module(material_icons
    URI "MaterialIcons"
    VERSION 1.0
    QML_FILES
        MaterialIcon.qml
        MaterialIcons.qml
    RESOURCES
        ${DOWNLOADED_FONTS}
)

target_link_libraries(material_icons PRIVATE Qt6::Core Qt6::Quick)

# Add an alias for easier consumption
add_library(MaterialIcons_plugin ALIAS material_iconsplugin)

if(MATERIAL_ICONS_BUILD_EXAMPLE)
    add_subdirectory(example)
endif()