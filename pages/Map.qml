import QtQuick
import QtQuick.Controls
import "../js/DepartmentDetector.js" as Detector

Item {
    id: mapPage

    // Données des départements (chargées depuis le SVG)
    property var departmentData: []
    property var viewBox: {
        "x": 105,
        "y": 18,
        "width": 568,
        "height": 567
    }

    // Charger les données du SVG au démarrage
    Component.onCompleted: {
        loadSvgData()
    }

    // Fonction pour charger et parser le SVG
    function loadSvgData() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "qrc:/qt/qml/LegiForces/HTML/carte-france.svg")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    parseSvgData(xhr.responseText)
                } else {
                    console.error("Erreur de chargement du SVG:", xhr.status)
                }
            }
        }
        xhr.send()
    }

    // Parser le SVG pour extraire les données des départements
    function parseSvgData(svgContent) {
        var parser = new DOMParser()
        var pathRegex = /<path[^>]*data-nom="([^"]*)"[^>]*data-numerodepartement="([^"]*)"[^>]*d="([^"]*)"[^>]*>/g
        var matches
        var departments = []

        while ((matches = pathRegex.exec(svgContent)) !== null) {
            var name = matches[1]
            var number = matches[2]
            var pathData = matches[3]

            // Parser le path pour obtenir les coordonnées du polygone
            var polygon = Detector.parseSvgPath(pathData)

            if (polygon.length > 0) {
                departments.push({
                    name: name,
                    number: number,
                    polygon: polygon
                })
            }
        }

        departmentData = departments
        console.log("Départements chargés:", departments.length)
    }

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
                if (departmentData.length === 0) {
                    console.log("Données des départements non encore chargées")
                    return
                }

                // Calculer les dimensions réelles de l'image affichée (avec PreserveAspectFit)
                var imageAspect = mapImage.sourceSize.width / mapImage.sourceSize.height
                var containerAspect = mapImage.width / mapImage.height

                var displayWidth, displayHeight, offsetX, offsetY

                if (containerAspect > imageAspect) {
                    // L'image est limitée par la hauteur
                    displayHeight = mapImage.height
                    displayWidth = displayHeight * imageAspect
                    offsetX = (mapImage.width - displayWidth) / 2
                    offsetY = 0
                } else {
                    // L'image est limitée par la largeur
                    displayWidth = mapImage.width
                    displayHeight = displayWidth / imageAspect
                    offsetX = 0
                    offsetY = (mapImage.height - displayHeight) / 2
                }

                // Coordonnées relatives dans l'image réelle
                var imageX = mouse.x - offsetX
                var imageY = mouse.y - offsetY

                // Convertir en coordonnées SVG viewBox
                var svgCoords = Detector.mouseToSvgCoordinates(
                    imageX, imageY, displayWidth, displayHeight, viewBox
                )

                console.log("Clic SVG:", svgCoords.x, svgCoords.y)

                // Trouver le département cliqué
                var department = Detector.findDepartmentAtPoint(
                    svgCoords.x, svgCoords.y, departmentData
                )

                if (department) {
                    console.log("Département cliqué:", department.number, "-", department.name)
                    departmentPopup.show(department)
                } else {
                    console.log("Aucun département trouvé à cette position")
                }
            }

            onPositionChanged: function(mouse) {
                cursorShape = Qt.PointingHandCursor
            }
        }
    }

    // Popup d'information sur le département
    Popup {
        id: departmentPopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 350
        height: 200
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        property string deptName: ""
        property string deptNumber: ""

        function show(department) {
            deptName = department.name
            deptNumber = department.number
            open()
        }

        background: Rectangle {
            color: "#2d2d2d"
            border.color: "#37afe5"
            border.width: 2
            radius: 10
        }

        contentItem: Item {
            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                // Titre
                Text {
                    width: parent.width
                    text: "📍 Département"
                    color: "#37afe5"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                // Séparateur
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#37afe5"
                    opacity: 0.3
                }

                // Informations
                Column {
                    width: parent.width
                    spacing: 10

                    Row {
                        spacing: 10
                        Text {
                            text: "Nom:"
                            color: "#888888"
                            font.pixelSize: 14
                        }
                        Text {
                            text: departmentPopup.deptName
                            color: "#ffffff"
                            font.pixelSize: 14
                            font.bold: true
                        }
                    }

                    Row {
                        spacing: 10
                        Text {
                            text: "Numéro:"
                            color: "#888888"
                            font.pixelSize: 14
                        }
                        Text {
                            text: departmentPopup.deptNumber
                            color: "#ffffff"
                            font.pixelSize: 14
                            font.bold: true
                        }
                    }
                }

                // Spacer
                Item {
                    width: 1
                    height: 10
                }

                // Bouton fermer
                Button {
                    width: parent.width
                    height: 40
                    text: "Fermer"

                    background: Rectangle {
                        color: parent.hovered ? "#37afe5" : "#2a2a2a"
                        border.color: "#37afe5"
                        border.width: 1
                        radius: 6
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }

                    onClicked: departmentPopup.close()
                }
            }
        }
    }
}
