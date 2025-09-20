import QtQuick

Item {
    // Composant vide pour l'instant
}

/*
import QtQuick
import QtQuick.Controls

Rectangle {
    id: newsBox

    property string title: ""
    property alias content: contentLoader.sourceComponent

    height: Math.max(150, headerRect.height + contentLoader.height + 30)

    // Gradient de fond identique au CSS
    gradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#052840f2" }
        GradientStop { position: 1.0; color: "#020c14e6" }
    }

    border.width: 1
    border.color: "#37afe54d"
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

    Column {
        anchors.fill: parent
        spacing: 0

        // Header avec gradient
        Rectangle {
            id: headerRect
            width: parent.width
            height: 40

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#1c4c6e" }
                GradientStop { position: 1.0; color: "#0d2b40" }
            }

            // Bordure du bas du header
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "#37afe54d"
            }

            Text {
                text: newsBox.title
                color: "#d8e8f0"
                font.family: "Segoe UI"
                font.pixelSize: 14
                font.weight: Font.Bold
                anchors.centerIn: parent

                // Effet text-shadow
                layer.enabled: true
                layer.effect: ShaderEffect {
                    fragmentShader: "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.39, 0.78, 1.0, 0.5);
                        }
                    "
                }
            }
        }

        // Contenu dynamique
        Item {
            width: parent.width
            height: contentLoader.height

            Loader {
                id: contentLoader
                anchors.fill: parent
                anchors.margins: 15
            }
        }
    }
}
