# Lucide Icons QML

A modern, high-performance Qt 6.8+ QML module for [Lucide Icons](https://lucide.dev/). 

This project automatically downloads the Lucide webfont and generates a QML singleton with all icon codepoints during the CMake configuration phase.

## Features

- **Automated Setup:** Font and icon codepoints are downloaded and generated automatically.
- **Zero Maintenance:** Always uses the latest icon set from `lucide-static`.
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
target_link_libraries(your_app_target PRIVATE LucideIcons_plugin)
```

## Usage

Once linked, import the module in your QML files:

```qml
import LucideIcons

LucideIcon {
    icon: LucideIcons.i_house
    size: 48
    color: "blue"
}
```

### Note on Icon Names
All icon names are prefixed with `i_` and hyphens are replaced with underscores (e.g., `LucideIcons.i_air_vent`) to avoid collisions with QML/JS/C++ reserved keywords.

## Configuration Options

The following CMake options are available:

- `LUCIDE_ICONS_BUILD_EXAMPLE`: (Default: OFF) Build the included example application.

## License

- **This Project:** MIT License
- **Fonts:** [ISC License](https://github.com/lucide-icons/lucide/blob/main/LICENSE) (Lucide)
