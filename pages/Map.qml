import QtQuick
import QtQuick.Controls

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
                    text: "Carte des départements français"
                    color: "#37afe5"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // Zone de la carte avec ScrollView pour zoom/pan
        ScrollView {
            id: mapScrollView
            anchors.top: titleBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: infoBar.top
            anchors.margins: 10
            clip: true

            // Conteneur de la carte
            Rectangle {
                width: Math.max(mapScrollView.width, mapImage.width * mapImage.scale)
                height: Math.max(mapScrollView.height, mapImage.height * mapImage.scale)
                color: "transparent"

                // Image SVG de la carte
                Image {
                    id: mapImage
                    anchors.centerIn: parent
                    source: "qrc:/qt/qml/LegiForces/HTML/carte-france.svg"
                    sourceSize.width: 800
                    sourceSize.height: 800
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: true

                    // Propriété pour le zoom
                    property real zoomLevel: 1.0
                    scale: zoomLevel

                    // Message de chargement
                    BusyIndicator {
                        anchors.centerIn: parent
                        running: mapImage.status === Image.Loading
                        visible: mapImage.status === Image.Loading

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
                        visible: mapImage.status === Image.Error

                        Text {
                            anchors.centerIn: parent
                            text: "❌ Erreur de chargement de la carte SVG\n\nVérifiez que le fichier existe dans HTML/"
                            color: "#ffaaaa"
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    // Gestion du zoom avec la molette de souris
                    MouseArea {
                        anchors.fill: parent
                        propagateComposedEvents: true

                        onWheel: function(wheel) {
                            if (wheel.modifiers & Qt.ControlModifier) {
                                var delta = wheel.angleDelta.y / 120
                                var newZoom = mapImage.zoomLevel + (delta * 0.1)
                                mapImage.zoomLevel = Math.max(0.5, Math.min(3.0, newZoom))
                                wheel.accepted = true
                            }
                        }
                    }
                }
            }
        }

        // Barre d'informations en bas avec contrôles de zoom
        Rectangle {
            id: infoBar
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            color: "#0c0226"
            border.color: "#0288f5"
            border.width: 1

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
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
                    text: "ℹ️ Maintenez Ctrl + Molette pour zoomer"
                    color: "#8899aa"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // Contrôles de zoom à droite
            Row {
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                // Bouton Zoom -
                Rectangle {
                    width: 30
                    height: 30
                    radius: 4
                    color: zoomOutMouse.containsMouse ? "#004678" : "#001122"
                    border.color: "#37afe5"
                    border.width: 1

                    Text {
                        text: "-"
                        anchors.centerIn: parent
                        color: "#37afe5"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        id: zoomOutMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            mapImage.zoomLevel = Math.max(0.5, mapImage.zoomLevel - 0.2)
                        }
                    }
                }

                // Indicateur de zoom
                Text {
                    text: Math.round(mapImage.zoomLevel * 100) + "%"
                    color: "#37afe5"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                }

                // Bouton Zoom +
                Rectangle {
                    width: 30
                    height: 30
                    radius: 4
                    color: zoomInMouse.containsMouse ? "#004678" : "#001122"
                    border.color: "#37afe5"
                    border.width: 1

                    Text {
                        text: "+"
                        anchors.centerIn: parent
                        color: "#37afe5"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        id: zoomInMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            mapImage.zoomLevel = Math.min(3.0, mapImage.zoomLevel + 0.2)
                        }
                    }
                }

                // Bouton Reset
                Rectangle {
                    width: 50
                    height: 30
                    radius: 4
                    color: resetMouse.containsMouse ? "#004678" : "#001122"
                    border.color: "#37afe5"
                    border.width: 1

                    Text {
                        text: "Reset"
                        anchors.centerIn: parent
                        color: "#37afe5"
                        font.pixelSize: 10
                    }

                    MouseArea {
                        id: resetMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            mapImage.zoomLevel = 1.0
                        }
                    }
                }
            }
        }
    }
}
