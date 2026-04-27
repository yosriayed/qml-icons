import QtQuick
import FontAwesomeIcons

Text {
    id: root
    property string icon: ""
    property real size: 24
    
    // Style selection: "solid", "regular", "brands"
    property string style: "solid" 

    renderType: Text.NativeRendering

    font.pixelSize: size
    font.family: {
        if (style === "regular" && typeof FontAwesomeIcons.regularFont !== "undefined") return FontAwesomeIcons.regularFont.name;
        if (style === "brands" && typeof FontAwesomeIcons.brandsFont !== "undefined") return FontAwesomeIcons.brandsFont.name;
        if (style === "solid" && typeof FontAwesomeIcons.solidFont !== "undefined") return FontAwesomeIcons.solidFont.name;
        return FontAwesomeIcons.defaultFont.name;
    }
    
    text: icon
    color: "black"
}
