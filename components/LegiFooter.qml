import QtQuick
import QtQuick.Controls


Rectangle {
    id: footer
    height: 90

    property string userType: "Admin"
    property int sessionProgress: 0

    color: "#000102"
    border.width: 1
    border.color: "#0288f5"

    Row {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Type d'utilisateur (gauche)
        Text {
            text: "Utilisateur: " + footer.userType
            color: "#0288f5"
            font.pixelSize: 18
            anchors.verticalCenter: parent.verticalCenter
        }

        // Date au centre
        Text {
            text: "Date: " + Qt.formatDate(new Date(), "dd/MM/yyyy")
            color: "#d8e8f0"
            font.pixelSize: 18
            anchors.verticalCenter: parent.verticalCenter
        }

        // Dots de progression (droite)
        Row {
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                model: 12
                delegate: Rectangle {
                    width: 20
                    height: 6
                    radius: 5
                    color: index < footer.sessionProgress ? "#297fb8" : "#163846"
                }
            }
        }
    }
}

