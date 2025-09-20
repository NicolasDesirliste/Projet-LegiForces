
import QtQuick
import QtQuick.Controls

Button {
    id: control

    property string buttonText: ""

    implicitWidth: Math.max(textItem.implicitWidth + 60, 120)
    implicitHeight: 35

    background: Rectangle {
        radius: 3
        border.width: 1
        border.color: "#2784c3"

        color: {
            if (control.pressed) return "#0d2b40"
            else if (control.hovered) return "#265d86"
            else return "#1c4c6e"
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    contentItem: Text {
        id: textItem
        text: control.buttonText
        font.family: "Segoe UI"
        font.pixelSize: 13
        color: control.hovered ? "#ffffff" : "#c5e2ff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}
