import QtQuick

Text {
    id: root
    property string icon: ""
    property real size: 24
    property bool fill: false
    property int weight: 400
    property int grade: 0
    property int opticalSize: 24
    
    // Variant selection: "outlined", "rounded", "sharp"
    property string variant: "outlined" 

    renderType: Text.NativeRendering

    font.pixelSize: size
    font.family: {
        if (variant === "rounded" && typeof MaterialIcons.roundedFont !== "undefined") return MaterialIcons.roundedFont.name;
        if (variant === "sharp" && typeof MaterialIcons.sharpFont !== "undefined") return MaterialIcons.sharpFont.name;
        if (variant === "outlined" && typeof MaterialIcons.outlinedFont !== "undefined") return MaterialIcons.outlinedFont.name;
        return MaterialIcons.materialFont.name;
    }
    
    font.weight: weight
    
    // Variable axes support (requires Qt 6.7+)
    font.variableAxes: { 
        "FILL": fill ? 1 : 0, 
        "GRAD": grade, 
        "opsz": opticalSize, 
        "wght": weight 
    }
    
    text: icon
    color: "black"
}