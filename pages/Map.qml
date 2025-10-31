import QtQuick
import QtQuick.Controls
import QtWebEngine

Item {
    id: mapPage

    // Fond transparent pour s'intégrer dans LegiMainContent
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Titre de la page
        Rectangle {
            id: titleBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60
            color: "#0c0226"
            border.color: "#0288f5"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 5

                Text {
                    text: "🗺️ Carte Interactive de France"
                    color: "#ffffff"
                    font.family: "Segoe UI"
                    font.pixelSize: 24
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

                Text {
                    text: "Survolez les départements pour voir leurs noms"
                    color: "#37afe5"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // Zone de la carte avec WebEngineView
        WebEngineView {
            id: mapWebView
            anchors.top: titleBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10

            // Charger le fichier HTML depuis les ressources
            url: "qrc:/HTML/carte-france-metropolitaine-svg.html"

            // Fond transparent pour s'intégrer au style LegiForces
            backgroundColor: "transparent"

            // Paramètres de chargement
            settings.javascriptEnabled: true
            settings.javascriptCanAccessClipboard: false
            settings.localContentCanAccessRemoteUrls: false
            settings.localContentCanAccessFileUrls: true

            // Message pendant le chargement
            BusyIndicator {
                anchors.centerIn: parent
                running: mapWebView.loading
                visible: mapWebView.loading

                contentItem: Item {
                    Rectangle {
                        width: 50
                        height: 50
                        radius: 25
                        anchors.centerIn: parent
                        color: "transparent"
                        border.color: "#37afe5"
                        border.width: 3

                        RotationAnimation on rotation {
                            loops: Animation.Infinite
                            from: 0
                            to: 360
                            duration: 2000
                        }
                    }
                }
            }

            // Message d'erreur si le chargement échoue
            Rectangle {
                anchors.centerIn: parent
                width: 400
                height: 100
                radius: 8
                color: "#331a1a"
                border.color: "#ff5555"
                border.width: 2
                visible: mapWebView.loadProgress === 100 && !mapWebView.loading && mapWebView.url.toString() === ""

                Text {
                    anchors.centerIn: parent
                    text: "❌ Erreur de chargement de la carte\n\nVérifiez que le fichier HTML existe dans le dossier HTML/"
                    color: "#ffaaaa"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // Barre d'informations en bas
        Rectangle {
            id: infoBar
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40
            color: "#0c0226"
            border.color: "#0288f5"
            border.width: 1

            Row {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "📍 Départements français"
                    color: "#37afe5"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    width: 1
                    height: 20
                    color: "#37afe5"
                    opacity: 0.3
                }

                Text {
                    text: "ℹ️ Cliquez sur un département (fonctionnalité à venir)"
                    color: "#8899aa"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
