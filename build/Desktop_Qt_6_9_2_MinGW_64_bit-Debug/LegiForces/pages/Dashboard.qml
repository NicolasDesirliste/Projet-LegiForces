import QtQuick

Item {
    // Composant vide pour l'instant
}
/*
import QtQuick
import QtQuick.Controls

ScrollView {
    id: dashboardPage

    contentWidth: -1
    clip: true

    Rectangle {
        width: dashboardPage.width
        height: Math.max(dashboardPage.height, column.implicitHeight + 60)
        color: "transparent"

        Column {
            id: column
            width: parent.width - 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 30
            topPadding: 40

            // Titre de bienvenue
            Text {
                text: "🏛️ Tableau de Bord LegiForces"
                color: "#ffffff"
                font.family: "Segoe UI"
                font.pixelSize: 32
                font.weight: Font.Bold
                anchors.horizontalCenter: parent.horizontalCenter

                layer.enabled: true
                layer.effect: ShaderEffect {
                    fragmentShader: "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.31, 0.53, 1.0, 0.5);
                        }
                    "
                }
            }

            // Cartes de statistiques
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20

                Repeater {
                    model: [
                        { title: "Affaires Actives", value: "47", color: "#37afe5" },
                        { title: "Utilisateurs", value: "12", color: "#2de72d" },
                        { title: "Documents", value: "234", color: "#ff9c9c" },
                        { title: "Rendez-vous", value: "8", color: "#8b47f8" }
                    ]

                    delegate: Rectangle {
                        width: 160
                        height: 120
                        radius: 8
                        color: "transparent"
                        border.width: 1
                        border.color: modelData.color + "66"

                        gradient: Gradient {
                            orientation: Gradient.Vertical
                            GradientStop { position: 0.0; color: "#001a2e66" }
                            GradientStop { position: 1.0; color: "#00051066" }
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: modelData.value
                                color: modelData.color
                                font.family: "Segoe UI"
                                font.pixelSize: 28
                                font.weight: Font.Bold
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: modelData.title
                                color: "#c8e6ff"
                                font.family: "Segoe UI"
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }

            // Message de test
            Rectangle {
                width: parent.width
                height: 100
                radius: 5
                color: "transparent"
                border.width: 1
                border.color: "#37afe533"

                Text {
                    text: "✅ Interface LegiForces chargée avec succès !\n\nTous les composants sont opérationnels. Vous pouvez tester la navigation avec la sidebar gauche."
                    color: "#d8e8f0"
                    font.family: "Segoe UI"
                    font.pixelSize: 14
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
