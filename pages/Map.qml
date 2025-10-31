import QtQuick
import QtQuick.Controls
import "../js/DepartmentDetector.js" as Detector
import "../js/DepartmentData.js" as DeptData

Item {
    id: mapPage

    // Données des départements (chargées depuis le fichier statique)
    property var departmentData: []
    property var viewBox: {
        "x": 105,
        "y": 18,
        "width": 568,
        "height": 567
    }

    // Département actuellement survolé
    property var hoveredDepartment: null

    // Charger les données au démarrage
    Component.onCompleted: {
        loadDepartmentData()
    }

    // Fonction pour charger les données depuis le fichier statique
    function loadDepartmentData() {
        var departments = DeptData.getDepartments()
        var parsedDepartments = []

        for (var i = 0; i < departments.length; i++) {
            var dept = departments[i]

            // Parser le path pour obtenir les coordonnées du polygone
            var polygon = Detector.parseSvgPath(dept.path)

            if (polygon.length > 0) {
                parsedDepartments.push({
                    name: dept.name,
                    number: dept.number,
                    polygon: polygon
                })
            }
        }

        departmentData = parsedDepartments
        console.log("Départements chargés:", parsedDepartments.length)
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
                if (departmentData.length === 0) {
                    return
                }

                // Calculer les dimensions réelles de l'image affichée
                var imageAspect = mapImage.sourceSize.width / mapImage.sourceSize.height
                var containerAspect = mapImage.width / mapImage.height

                var displayWidth, displayHeight, offsetX, offsetY

                if (containerAspect > imageAspect) {
                    displayHeight = mapImage.height
                    displayWidth = displayHeight * imageAspect
                    offsetX = (mapImage.width - displayWidth) / 2
                    offsetY = 0
                } else {
                    displayWidth = mapImage.width
                    displayHeight = displayWidth / imageAspect
                    offsetX = 0
                    offsetY = (mapImage.height - displayHeight) / 2
                }

                // Coordonnées relatives dans l'image réelle
                var imageX = mouse.x - offsetX
                var imageY = mouse.y - offsetY

                // Vérifier que la souris est bien sur l'image
                if (imageX < 0 || imageX > displayWidth || imageY < 0 || imageY > displayHeight) {
                    hoveredDepartment = null
                    hoverTooltip.visible = false
                    return
                }

                // Convertir en coordonnées SVG viewBox
                var svgCoords = Detector.mouseToSvgCoordinates(
                    imageX, imageY, displayWidth, displayHeight, viewBox
                )

                // Trouver le département sous la souris
                var department = Detector.findDepartmentAtPoint(
                    svgCoords.x, svgCoords.y, departmentData
                )

                if (department) {
                    hoveredDepartment = department
                    hoverTooltip.x = mouse.x + 15
                    hoverTooltip.y = mouse.y + 15
                    hoverTooltip.visible = true
                    cursorShape = Qt.PointingHandCursor
                } else {
                    hoveredDepartment = null
                    hoverTooltip.visible = false
                    cursorShape = Qt.ArrowCursor
                }
            }

            onExited: {
                hoveredDepartment = null
                hoverTooltip.visible = false
            }
        }

        // Tooltip au survol (simulation de l'effet hover du SVG)
        Rectangle {
            id: hoverTooltip
            visible: false
            width: tooltipText.width + 20
            height: tooltipText.height + 12
            color: "#2d2d2d"
            border.color: "#86eee0"
            border.width: 2
            radius: 6
            z: 1000
            opacity: 0.95

            Text {
                id: tooltipText
                anchors.centerIn: parent
                text: hoveredDepartment ? (hoveredDepartment.number + " - " + hoveredDepartment.name) : ""
                color: "#86eee0"
                font.pixelSize: 13
                font.bold: true
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
                Rectangle {
                    width: parent.width
                    height: 40
                    color: mouseArea.containsMouse ? "#37afe5" : "#2a2a2a"
                    border.color: "#37afe5"
                    border.width: 1
                    radius: 6

                    Text {
                        anchors.centerIn: parent
                        text: "Fermer"
                        color: "#ffffff"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: departmentPopup.close()
                    }
                }
            }
        }
    }
}
