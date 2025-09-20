import QtQuick

Item {
    // Composant vide pour l'instant
}

/*
import QtQuick
import QtQuick.Controls

Rectangle {
    id: tooltip

    property string title: ""
    property var linksData: []

    width: 250
    height: Math.max(120, column.implicitHeight + 24)
    z: 99

    // Gradient de fond identique au CSS
    gradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#052840f2" }
        GradientStop { position: 1.0; color: "#020c14e6" }
    }

    border.width: 1
    border.color: "#37aee5a3"
    radius: 3

    // Ombre et glow
    layer.enabled: true
    layer.effect: ShaderEffect {
        fragmentShader: "
            uniform lowp sampler2D source;
            varying highp vec2 qt_TexCoord0;
            void main() {
                lowp vec4 tex = texture2D(source, qt_TexCoord0);
                gl_FragColor = tex + vec4(0.0, 0.0, 0.0, 0.5) + vec4(0.22, 0.69, 0.9, 0.2);
            }
        "
    }

    // Petite flèche pointant vers la gauche
    Canvas {
        id: arrow
        width: 12
        height: 12
        anchors.left: parent.left
        anchors.leftMargin: -6
        anchors.top: parent.top
        anchors.topMargin: 15

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            // Flèche triangle
            ctx.beginPath()
            ctx.moveTo(6, 0)
            ctx.lineTo(12, 6)
            ctx.lineTo(6, 12)
            ctx.closePath()

            // Remplissage avec la couleur de bordure
            ctx.fillStyle = "#37aee5a3"
            ctx.fill()
        }
    }

    Column {
        id: column
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // En-tête du tooltip
        Rectangle {
            width: parent.width
            height: headerText.implicitHeight + 10
            color: "transparent"
            border.width: 0
            border.color: "#37afe54d"

            // Bordure du bas
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "#37afe54d"
            }

            Text {
                id: headerText
                text: tooltip.title
                color: "#6ab1d8"
                font.family: "Segoe UI"
                font.pixelSize: 12
                font.weight: Font.Bold
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // Liste des liens
        Column {
            width: parent.width
            spacing: 5

            Repeater {
                model: tooltip.linksData
                delegate: Rectangle {
                    width: parent.width
                    height: linkText.implicitHeight + 16
                    color: linkMouseArea.containsMouse ? "#37afe520" : "transparent"
                    radius: 2
                    border.width: 0

                    // Animation de survol
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    Text {
                        id: linkText
                        text: modelData.text || ""
                        color: linkMouseArea.containsMouse ? "#ffffff" : "#c8e6ff"
                        font.family: "Segoe UI"
                        font.pixelSize: 13
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter

                        // Transition de couleur
                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    MouseArea {
                        id: linkMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            console.log("Lien cliqué:", modelData.href)
                            // Ici vous pouvez émettre un signal ou naviguer
                            // tooltip.linkClicked(modelData.href)
                        }
                    }
                }
            }
        }
    }

    // Animation d'apparition/disparition
    opacity: visible ? 1 : 0
    scale: visible ? 1 : 0.9

    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutBack
        }
    }
}
