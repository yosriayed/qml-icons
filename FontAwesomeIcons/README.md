# Font Awesome Icons QML

A modern, high-performance Qt 6.8+ QML module for [Font Awesome](https://fontawesome.com/). 

This project automatically downloads Font Awesome webfonts and generates a QML singleton with all icon codepoints during the CMake configuration phase.

## Features

- **Automated Setup:** Fonts and icon codepoints are downloaded and generated automatically.
- **Zero Maintenance:** Always uses the latest icon set from the Font Awesome 6.x repository.
- **Multiple Styles:** Supports Solid, Regular, and Brands styles.
- **Seamless Integration:** Designed to be easily consumed via CMake `FetchContent`.

## Requirements

- **Qt 6.8 or newer**.
- **CMake 3.21 or newer**.

## Installation

This module is part of the [QML Icon Suite](https://github.com/yosriayed/qml-icons). Add the suite to your `CMakeLists.txt` using `FetchContent`:

```cmake
include(FetchContent)

FetchContent_Declare(
    qml_icons
    GIT_REPOSITORY https://github.com/yosriayed/qml-icons.git
    GIT_TAG main
)

FetchContent_MakeAvailable(qml_icons)

# Link to this specific module
target_link_libraries(your_app_target PRIVATE FontAwesomeIcons_plugin)
```

## Usage

Once linked, import the module in your QML files:

```qml
import FontAwesomeIcons

FontAwesomeIcon {
    icon: FontAwesomeIcons.i_house
    size: 48
    color: "blue"
    style: "solid" // "solid", "regular", or "brands"
}
```

### Note on Icon Names
All icon names are prefixed with `i_` and hyphens are replaced with underscores (e.g., `FontAwesomeIcons.i_address_book`) to avoid collisions with QML/JS/C++ reserved keywords.

## Configuration Options

The following CMake options are available:

- `FONTAWESOME_STYLE_SOLID`: (Default: ON) Include the Solid style.
- `FONTAWESOME_STYLE_REGULAR`: (Default: OFF) Include the Regular style.
- `FONTAWESOME_STYLE_BRANDS`: (Default: OFF) Include the Brands style.
- `FONTAWESOME_BUILD_EXAMPLE`: (Default: OFF) Build the included example application.

## License

- **This Project:** MIT License
- **Fonts:** [Font Awesome Free License](https://fontawesome.com/license/free)
