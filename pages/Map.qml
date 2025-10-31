import QtQuick
import QtQuick.Controls

Item {
    id: mapPage

    // ScrollView pour la carte avec zoom/pan
    ScrollView {
        id: mapScrollView
        anchors.fill: parent
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
                sourceSize.width: 1200
                sourceSize.height: 1200
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
                        text: "❌ Erreur de chargement de la carte SVG"
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
}
