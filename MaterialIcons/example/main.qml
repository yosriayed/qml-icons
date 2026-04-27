import QtQuick
import QtQuick.Controls
import MaterialIcons

Window {
    width: 640
    height: 480
    visible: true
    title: "Material Icons QML Example"

    Column {
        anchors.centerIn: parent
        spacing: 20

        Row {
            spacing: 20
            MaterialIcon {
                icon: MaterialIcons.i_home
                size: 48
                color: "blue"
            }
            MaterialIcon {
                icon: MaterialIcons.i_home
                size: 48
                fill: true
                color: "blue"
            }
            MaterialIcon {
                icon: MaterialIcons.i_home
                size: 48
                weight: 100
                color: "blue"
            }
            MaterialIcon {
                icon: MaterialIcons.i_home
                size: 48
                weight: 700
                color: "blue"
            }
        }

        Row {
            spacing: 20
            MaterialIcon {
                icon: MaterialIcons.i_settings
                size: 48
                grade: -25
            }
            MaterialIcon {
                icon: MaterialIcons.i_settings
                size: 48
                grade: 200
            }
        }

        Text {
            text: "Variable Font Properties"
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Grid {
            columns: 2
            spacing: 10
            
            Label { text: "Weight:" }
            Slider {
                id: weightSlider
                from: 100
                to: 700
                value: 400
                stepSize: 100
            }

            Label { text: "Fill:" }
            CheckBox {
                id: fillCheck
                checked: false
            }
        }

        MaterialIcon {
            anchors.horizontalCenter: parent.horizontalCenter
            icon: MaterialIcons.i_favorite
            size: 100
            weight: weightSlider.value
            fill: fillCheck.checked
            color: "red"
        }
    }
}