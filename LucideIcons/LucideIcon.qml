import QtQuick
import LucideIcons

Text {
    id: root
    property string icon: ""
    property real size: 24
    
    renderType: Text.NativeRendering

    font.pixelSize: size
    font.family: LucideIcons.defaultFont.name
    
    text: icon
    color: "black"
}
