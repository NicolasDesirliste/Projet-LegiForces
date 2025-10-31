import QtQuick
import QtQuick.Controls

Item {
    id: mapPage

    // Image SVG de la carte - centrée et adaptée
    Image {
        id: mapImage
        anchors.fill: parent
        anchors.margins: 20
        source: "qrc:/qt/qml/LegiForces/HTML/carte-france.svg"
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: true

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

        // Zone cliquable sur toute la carte
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onClicked: function(mouse) {
                // Coordonnées relatives dans l'image
                var relX = mouse.x / mapImage.width
                var relY = mouse.y / mapImage.height

                console.log("Clic sur la carte à:", relX, relY)

                // TODO: Détecter quel département a été cliqué
                // Pour l'instant, on affiche juste les coordonnées
            }

            onPositionChanged: function(mouse) {
                // Optionnel: changer le curseur sur hover
                cursorShape = Qt.PointingHandCursor
            }
        }
    }
}
