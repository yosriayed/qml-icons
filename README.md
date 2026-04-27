# QML Icon Suite

A collection of modern, high-performance Qt 6.8+ QML icon modules bundled in a single repository. Each module is automatically kept up-to-date with its official source.

## Included Modules

- **MaterialIcons**: Google Material Symbols (Variable Font support)
- **FontAwesomeIcons**: Font Awesome Free 6.x (Solid, Regular, Brands)
- **LucideIcons**: Lucide Icons

## Features

- **Single Repository**: Fetch the entire suite once and use any or all modules.
- **Automated Setup**: Fonts and metadata are downloaded and QML code is generated at CMake configuration time.
- **Consistent API**: Harmonized component naming and property patterns across all modules.
- **Efficient**: Singletons provide typed access to icon codepoints.

## Installation (FetchContent)

Add the entire suite to your `CMakeLists.txt`:

```cmake
include(FetchContent)

FetchContent_Declare(
    qml_icons
    GIT_REPOSITORY https://github.com/yosriayed/qml-icons.git
    GIT_TAG main
)
FetchContent_MakeAvailable(qml_icons)

# Link to the modules you need
target_link_libraries(your_app PRIVATE 
    MaterialIcons_plugin
    FontAwesomeIcons_plugin
    LucideIcons_plugin
)
```

### Selective Building
You can disable specific modules to speed up configuration:
```cmake
set(QML_ICONS_BUILD_MATERIAL OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(qml_icons)
```

## Usage

```qml
import LucideIcons
import FontAwesomeIcons
import MaterialIcons

Column {
    LucideIcon {
        icon: LucideIcons.i_house
        size: 32
    }
    
    FontAwesomeIcon {
        icon: FontAwesomeIcons.i_gear
        style: "solid"
    }
    
    MaterialIcon {
        icon: MaterialIcons.i_favorite
        fill: true
    }
}
```

## Harmonized API Pattern

All modules follow a consistent naming pattern:

- **URI:** `<Brand>Icons` (e.g., `LucideIcons`)
- **Singleton:** `<Brand>Icons`
- **Component:** `<Brand>Icon`
- **Icon Prefix:** `i_` (e.g., `i_home`)
- **Default Font:** `LucideIcons.defaultFont.name`

## License

Each module is licensed under the MIT License. The underlying fonts are licensed under their respective open-source licenses (Apache 2.0, SIL OFL, ISC).
