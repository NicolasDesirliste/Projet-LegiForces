import QtQuick
import QtQuick.Controls

Rectangle {
    id: newsSidebar
    width: 224 // 14rem

    // Position absolue comme dans le CSS
    anchors.right: parent.right
    anchors.rightMargin: 6 // 0.4rem
    anchors.top: parent.top
    anchors.topMargin: 62 // 3.9rem approximativement
    height: parent.height - 150 // calc(100vh - 150px)

    // Gradient de fond identique au CSS
    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: "#000a10" }
        GradientStop { position: 1.0; color: "#00111a" }
    }

    z: 10

    // ScrollView pour le contenu
    ScrollView {
        anchors.fill: parent
        anchors.margins: 5
        contentWidth: -1
        clip: true

        // Scrollbar personnalisée
        ScrollBar.vertical: ScrollBar {
            width: 6
            background: Rectangle {
                color: "#00000a33"
                radius: 3
            }
            contentItem: Rectangle {
                implicitWidth: 6
                radius: 3
                color: "#21eeee60"

                states: State {
                    name: "active"
                    when: parent.active
                    PropertyChanges { target: parent.contentItem; color: "#36c7ff" }
                }
            }
        }

        Column {
            width: newsSidebar.width - 10
            spacing: 20
            topPadding: 10

            // Dernière Vidéo LVDPA
            LegiNewsBox {
                id: videoBox
                title: "Dernière Vidéo LegiForces"
                width: parent.width

                content: Component {
                    Rectangle {
                        height: 120
                        color: "transparent"

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Rectangle {
                                width: 80
                                height: 60
                                color: "#1a1a2e"
                                border.color: "#37afe54d"
                                border.width: 1
                                radius: 3
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    text: "📺"
                                    font.pixelSize: 24
                                    anchors.centerIn: parent
                                }
                            }

                            Text {
                                text: "Aucune vidéo récente"
                                color: "#8ebacc"
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }

            // Derniers posts membres
            LegiNewsBox {
                id: postsBox
                title: "Derniers posts membres"
                width: parent.width

                content: Component {
                    ScrollView {
                        height: 160
                        contentWidth: -1
                        clip: true

                        // Scrollbar fine pour les posts
                        ScrollBar.vertical: ScrollBar {
                            width: 6
                            background: Rectangle {
                                color: "#00000a33"
                                radius: 3
                            }
                            contentItem: Rectangle {
                                implicitWidth: 6
                                radius: 3
                                color: "#37afe566"
                            }
                        }

                        Column {
                            width: parent.width - 10
                            spacing: 0

                            Repeater {
                                model: ListModel {
                                    ListElement {
                                        author: "Nicolas D."
                                        content: "Nouvelle mise à jour du système disponible"
                                        time: "Il y a 2h"
                                    }
                                    ListElement {
                                        author: "Admin"
                                        content: "Maintenance programmée ce weekend"
                                        time: "Il y a 4h"
                                    }
                                    ListElement {
                                        author: "Marie L."
                                        content: "Documentation mise à jour"
                                        time: "Il y a 1j"
                                    }
                                    ListElement {
                                        author: "Support"
                                        content: "Nouveau guide utilisateur publié"
                                        time: "Il y a 2j"
                                    }
                                }

                                delegate: Rectangle {
                                    width: parent.width
                                    height: postContent.implicitHeight + 16
                                    color: "transparent"
                                    border.width: 0

                                    // Bordure du bas
                                    Rectangle {
                                        anchors.bottom: parent.bottom
                                        width: parent.width
                                        height: 1
                                        color: "#37afe54d"
                                        visible: index < 3 // Pas de bordure pour le dernier
                                    }

                                    Column {
                                        id: postContent
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.margins: 5
                                        spacing: 2

                                        Text {
                                            text: model.content
                                            color: "#c8e6ffcc"
                                            font.family: "Segoe UI"
                                            font.pixelSize: 13
                                            wrapMode: Text.WordWrap
                                            width: parent.width
                                            lineHeight: 1.4
                                        }

                                        Row {
                                            spacing: 8

                                            Text {
                                                text: "- " + model.author
                                                color: "#6ab1d8"
                                                font.family: "Segoe UI"
                                                font.pixelSize: 11
                                                font.weight: Font.Bold
                                            }

                                            Text {
                                                text: model.time
                                                color: "#8ebacc"
                                                font.family: "Segoe UI"
                                                font.pixelSize: 10
                                                font.italic: true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Réseaux Sociaux
            LegiNewsBox {
                id: socialBox
                title: "Réseaux Sociaux"
                width: parent.width

                content: Component {
                    Column {
                        width: parent.width
                        spacing: 5
                        topPadding: 5

                        LegiSocialButton {
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Place Holder 1"
                            socialType: "youtube"
                        }

                        LegiSocialButton {
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Place Holder 2"
                            socialType: "twitter"
                        }

                        LegiSocialButton {
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Place Holder 3"
                            socialType: "discord"
                        }

                        LegiSocialButton {
                            width: parent.width - 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Place Holder 4"
                            socialType: "reddit"
                        }
                    }
                }
            }
        }
    }
}
