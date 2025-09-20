import QtQuick

Item {
    // Composant vide pour l'instant
}

/*
import QtQuick
import QtQuick.Controls

Button {
    id: control

    property string socialType: "default"
    property alias text: buttonText.text

    height: 35

    background: Rectangle {
        radius: 3
        border.width: 1

        // Couleurs selon le type de réseau social
        gradient: {
            switch(control.socialType) {
                case "youtube":
                    return control.pressed ? pressedYoutubeGradient :
                           (control.hovered ? hoveredYoutubeGradient : normalYoutubeGradient)
                case "twitter":
                    return control.pressed ? pressedTwitterGradient :
                           (control.hovered ? hoveredTwitterGradient : normalTwitterGradient)
                case "discord":
                    return control.pressed ? pressedDiscordGradient :
                           (control.hovered ? hoveredDiscordGradient : normalDiscordGradient)
                case "reddit":
                    return control.pressed ? pressedRedditGradient :
                           (control.hovered ? hoveredRedditGradient : normalRedditGradient)
                default:
                    return control.pressed ? pressedDefaultGradient :
                           (control.hovered ? hoveredDefaultGradient : normalDefaultGradient)
            }
        }

        border.color: {
            switch(control.socialType) {
                case "youtube": return control.hovered ? "#c90707cc" : "#c907077f"
                case "twitter": return control.hovered ? "#1a73e8cc" : "#1a73e87f"
                case "discord": return control.hovered ? "#7289dacc" : "#7289da7f"
                case "reddit": return control.hovered ? "#ff4500cc" : "#ff45007f"
                default: return control.hovered ? "#64646466" : "#6464644d"
            }
        }

        // Ombre et glow selon le type
        layer.enabled: true
        layer.effect: ShaderEffect {
            fragmentShader: {
                switch(control.socialType) {
                    case "youtube": return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.0, 0.0, 0.0, 0.5) + vec4(0.79, 0.03, 0.03, 0.3);
                        }
                    "
                    case "twitter": return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.0, 0.0, 0.0, 0.5) + vec4(0.1, 0.45, 0.91, 0.3);
                        }
                    "
                    case "discord": return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.0, 0.0, 0.0, 0.5) + vec4(0.45, 0.54, 0.85, 0.3);
                        }
                    "
                    case "reddit": return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.0, 0.0, 0.0, 0.5) + vec4(1.0, 0.27, 0.0, 0.3);
                        }
                    "
                    default: return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.0, 0.0, 0.0, 0.5);
                        }
                    "
                }
            }
        }

        // Transitions
        Behavior on border.color {
            ColorAnimation { duration: 200 }
        }
    }

    contentItem: Text {
        id: buttonText
        text: control.text
        font.family: "Segoe UI"
        font.pixelSize: 13
        color: control.hovered ? "#ffffff" : "#dcf0ffE6"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        // Effet text-shadow au survol
        layer.enabled: control.hovered
        layer.effect: ShaderEffect {
            fragmentShader: {
                switch(control.socialType) {
                    case "youtube": return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(1.0, 0.59, 0.59, 0.5);
                        }
                    "
                    case "twitter": return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.59, 0.78, 1.0, 0.5);
                        }
                    "
                    case "discord": return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.71, 0.78, 1.0, 0.5);
                        }
                    "
                    case "reddit": return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(1.0, 0.78, 0.59, 0.5);
                        }
                    "
                    default: return "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.59, 0.86, 1.0, 0.5);
                        }
                    "
                }
            }
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    // Animation de pression
    transform: Scale {
        origin.x: control.width / 2
        origin.y: control.height / 2
        xScale: control.pressed ? 0.98 : 1.0
        yScale: control.pressed ? 0.98 : 1.0

        Behavior on xScale { NumberAnimation { duration: 100 } }
        Behavior on yScale { NumberAnimation { duration: 100 } }
    }

    // Effet de brillance au clic
    Rectangle {
        id: clickGlare
        anchors.fill: parent
        radius: parent.background.radius
        opacity: 0

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: "#ffffff1a" }
            GradientStop { position: 1.0; color: "transparent" }
        }

        SequentialAnimation on opacity {
            id: clickAnimation
            running: false
            NumberAnimation { to: 1; duration: 100 }
            NumberAnimation { to: 0; duration: 400 }
        }
    }

    onClicked: clickAnimation.start()

    // Définition des gradients pour chaque type et état
    property var normalYoutubeGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#c92b077f" }
        GradientStop { position: 1.0; color: "#520202" }
    }
    property var hoveredYoutubeGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#e40808" }
        GradientStop { position: 1.0; color: "#a30606" }
    }
    property var pressedYoutubeGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#8f0505" }
        GradientStop { position: 1.0; color: "#c90707" }
    }

    property var normalTwitterGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#104892" }
        GradientStop { position: 1.0; color: "#000103" }
    }
    property var hoveredTwitterGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#2080ff" }
        GradientStop { position: 1.0; color: "#1259bd" }
    }
    property var pressedTwitterGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#0f4da1" }
        GradientStop { position: 1.0; color: "#1a73e8" }
    }

    property var normalDiscordGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#5f247b" }
        GradientStop { position: 1.0; color: "#15255f" }
    }
    property var hoveredDiscordGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#bc87e4" }
        GradientStop { position: 1.0; color: "#5869a6" }
    }
    property var pressedDiscordGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#4e5d94" }
        GradientStop { position: 1.0; color: "#7289da" }
    }

    property var normalRedditGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#ff440054" }
        GradientStop { position: 1.0; color: "#f041018a" }
    }
    property var hoveredRedditGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#ff5c1c" }
        GradientStop { position: 1.0; color: "#e33e00" }
    }
    property var pressedRedditGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#c73600" }
        GradientStop { position: 1.0; color: "#ff4500" }
    }

    property var normalDefaultGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#1c4c6e" }
        GradientStop { position: 1.0; color: "#0d2b40" }
    }
    property var hoveredDefaultGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#265d86" }
        GradientStop { position: 1.0; color: "#123551" }
    }
    property var pressedDefaultGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#0d2b40" }
        GradientStop { position: 1.0; color: "#1c4c6e" }
    }
}
