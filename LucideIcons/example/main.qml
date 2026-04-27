import QtQuick
import QtQuick.Controls
import LucideIcons

Window {
    width: 640
    height: 480
    visible: true
    title: "Lucide Icons QML Example"

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "Lucide Icons"
            font.pixelSize: 24
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            
            LucideIcon {
                icon: LucideIcons.i_house
                size: 48
                color: "steelblue"
            }
            LucideIcon {
                icon: LucideIcons.i_search
                size: 48
                color: "darkorange"
            }
            LucideIcon {
                icon: LucideIcons.i_settings
                size: 48
                color: "gray"
            }
            LucideIcon {
                icon: LucideIcons.i_user
                size: 48
                color: "green"
            }
        }

        Grid {
            columns: 4
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter

            LucideIcon { icon: LucideIcons.i_heart; size: 32; color: "red" }
            LucideIcon { icon: LucideIcons.i_camera; size: 32; color: "black" }
            LucideIcon { icon: LucideIcons.i_mail; size: 32; color: "blue" }
            LucideIcon { icon: LucideIcons.i_bell; size: 32; color: "goldenrod" }
            
            LucideIcon { icon: LucideIcons.i_activity; size: 32; color: "black" }
            LucideIcon { icon: LucideIcons.i_airplay; size: 32; color: "blue" }
            LucideIcon { icon: LucideIcons.i_archive; size: 32; color: "brown" }
            LucideIcon { icon: LucideIcons.i_anchor; size: 32; color: "darkblue" }
        }
    }
}
