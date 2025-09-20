import QtQuick
import QtQuick.Controls

Rectangle {
    id: header
    height: 90

    signal logoutRequested()
    signal homeRequested()
    signal placeholderOneRequested()
    signal placeholderTwoRequested()

    color: "#000102"
    border.width: 1
    border.color: "#0288f5"

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        spacing: 10

        LegiNavButton {
            buttonText: "Se Déconnecter"
            onClicked: header.logoutRequested()
        }

        LegiNavButton {
            buttonText: "Page d'Accueil"
            onClicked: header.homeRequested()
        }

        LegiNavButton {
            buttonText: "Place Holder 1"
            onClicked: header.placeholderOneRequested()
        }

        LegiNavButton {
            buttonText: "Place Holder 2"
            onClicked: header.placeholderTwoRequested()
        }
    }

    Text {
        text: "Legi-Forces"
        color: "#0288f5"
        font.family: "Segoe UI"
        font.pixelSize: 40
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
    }
}
