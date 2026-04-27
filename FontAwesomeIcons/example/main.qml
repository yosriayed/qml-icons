import QtQuick
import QtQuick.Controls
import FontAwesomeIcons

Window {
    width: 640
    height: 480
    visible: true
    title: "Font Awesome Icons QML Example"

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "Font Awesome Icons"
            font.pixelSize: 24
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            
            Column {
                spacing: 10
                Label { text: "Solid"; anchors.horizontalCenter: parent.horizontalCenter }
                FontAwesomeIcon {
                    icon: FontAwesomeIcons.i_house
                    size: 48
                    color: "steelblue"
                    style: "solid"
                }
            }

            Column {
                spacing: 10
                Label { text: "Regular"; anchors.horizontalCenter: parent.horizontalCenter }
                FontAwesomeIcon {
                    icon: FontAwesomeIcons.i_user
                    size: 48
                    color: "darkorange"
                    style: "regular"
                }
            }

            Column {
                spacing: 10
                Label { text: "Brands"; anchors.horizontalCenter: parent.horizontalCenter }
                FontAwesomeIcon {
                    icon: FontAwesomeIcons.i_github
                    size: 48
                    color: "black"
                    style: "brands"
                }
            }
        }

        Grid {
            columns: 4
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter

            FontAwesomeIcon { icon: FontAwesomeIcons.i_heart; size: 32; color: "red" }
            FontAwesomeIcon { icon: FontAwesomeIcons.i_gear; size: 32; color: "gray" }
            FontAwesomeIcon { icon: FontAwesomeIcons.i_camera; size: 32; color: "green" }
            FontAwesomeIcon { icon: FontAwesomeIcons.i_envelope; size: 32; color: "blue" }
            
            FontAwesomeIcon { icon: FontAwesomeIcons.i_twitter; size: 32; color: "#1DA1F2"; style: "brands" }
            FontAwesomeIcon { icon: FontAwesomeIcons.i_facebook; size: 32; color: "#1877F2"; style: "brands" }
            FontAwesomeIcon { icon: FontAwesomeIcons.i_linux; size: 32; color: "black"; style: "brands" }
            FontAwesomeIcon { icon: FontAwesomeIcons.i_apple; size: 32; color: "gray"; style: "brands" }
        }
    }
}
