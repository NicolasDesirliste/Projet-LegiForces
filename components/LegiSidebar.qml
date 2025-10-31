import QtQuick
import QtQuick.Controls

Rectangle {
    id: sidebar
    width: 230
    border.color: "#0288f5"
    border.width: 1 // possible bords de colonne

    signal pageRequested(string pageId)

    color: "#000102"  // Couleur simple au lieu du gradient pour éviter les conflits

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        // Titre de la section
        Text {
            text: "Navigation"
            color: "#0288f5"
            font.family: "Segoe UI"
            font.pixelSize: 18
            font.weight: Font.Bold
            anchors.horizontalCenter: parent.horizontalCenter
            bottomPadding: 10
        }

        Repeater {
            model: [
                { title: "Tableau de Bord", pageId: "dashboard" },
                { title: "Affaires en cours", pageId: "courtcases" },
                { title: "Profil Utilisateur", pageId: "users" },
                { title: "Documents", pageId: "documents" },
                { title: "Calendrier des audiences", pageId: "calendar" },
                { title: "Messagerie Interne", pageId: "documents" },
                { title: "🗺️ Carte de France", pageId: "map" },
                { title: "Place Holder", pageId: "documents" },
                { title: "Place Holder", pageId: "calendar" },
                { title: "Place Holder", pageId: "documents" },
                { title: "Place Holder", pageId: "calendar" },
                { title: "Place Holder", pageId: "documents" },
                { title: "Place Holder", pageId: "calendar" },
                { title: "Place Holder", pageId: "documents" },
                { title: "Place Holder", pageId: "settings" }
            ]

            delegate: Rectangle {
                width: parent.width - 20
                height: 40
                color: mouseArea.containsMouse ? "#004678" : "transparent"  // Une seule définition de couleur
                border.width: 1
                border.color: "#0288f5"
                anchors.horizontalCenter: parent.horizontalCenter

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                Text {
                    text: modelData.title
                    color: mouseArea.containsMouse ? "#0288f5" : "#0288f5"
                    anchors.centerIn: parent
                    font.pixelSize: 16

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        sidebar.pageRequested(modelData.pageId)
                    }
                }
            }
        }
    }
}
/*
import QtQuick
import QtQuick.Controls

Rectangle {
    id: sidebar
    width: 230

    signal pageRequested(string pageId)

    // Gradient de fond identique au CSS
    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: "#000a10" }
        GradientStop { position: 1.0; color: "#00111a" }
    }

    // Ombre à droite
    Rectangle {
        anchors.right: parent.right
        width: 15
        height: parent.height
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#00000000" }
            GradientStop { position: 1.0; color: "#0000004d" }
        }
    }

    // Liste des menus
    ListView {
        id: menuList
        anchors.fill: parent
        anchors.rightMargin: 15
        model: menuModel
        delegate: menuDelegate
        interactive: true
        clip: true

        // Style de scrollbar personnalisé
        ScrollBar.vertical: ScrollBar {
            width: 8
            background: Rectangle {
                color: "#00000000"
                radius: 4
            }
            contentItem: Rectangle {
                implicitWidth: 6
                radius: 3
                color: "#21eeee60"

                states: State {
                    name: "active"
                    when: parent.active
                    PropertyChanges { target: parent.contentItem; color: "#27fdfd" }
                }
            }
        }
    }

    // Modèle de données pour les menus
    ListModel {
        id: menuModel

        ListElement {
            title: "Tableau de Bord"
            pageId: "dashboard"
            tooltipHeader: "Navigation Principale"
            links: [
                { text: "Vue d'ensemble", href: "#dashboard", spa: true },
                { text: "Statistiques", href: "#stats", spa: true },
                { text: "Rapports", href: "#reports", spa: true }
            ]
        }
        ListElement {
            title: "Affaires"
            pageId: "courtcases"
            tooltipHeader: "Gestion des Dossiers"
            links: [
                { text: "Nouvelles affaires", href: "#new-cases", spa: true },
                { text: "Affaires en cours", href: "#active-cases", spa: true },
                { text: "Affaires fermées", href: "#closed-cases", spa: true },
                { text: "Recherche", href: "#search-cases", spa: true }
            ]
        }
        ListElement {
            title: "Utilisateurs"
            pageId: "users"
            tooltipHeader: "Gestion des Utilisateurs"
            links: [
                { text: "Liste des utilisateurs", href: "#users-list", spa: true },
                { text: "Ajouter utilisateur", href: "#add-user", spa: true },
                { text: "Permissions", href: "#permissions", spa: true },
                { text: "Groupes", href: "#groups", spa: true }
            ]
        }
        ListElement {
            title: "Documents"
            pageId: "documents"
            tooltipHeader: "Gestion Documentaire"
            links: [
                { text: "Bibliothèque", href: "#documents", spa: true },
                { text: "Modèles", href: "#templates", spa: true },
                { text: "Archives", href: "#archives", spa: true }
            ]
        }
        ListElement {
            title: "Calendrier"
            pageId: "calendar"
            tooltipHeader: "Planning et Rendez-vous"
            links: [
                { text: "Vue mensuelle", href: "#calendar-month", spa: true },
                { text: "Rendez-vous", href: "#appointments", spa: true },
                { text: "Audiences", href: "#hearings", spa: true }
            ]
        }
        ListElement {
            title: "Paramètres"
            pageId: "settings"
            tooltipHeader: "Configuration"
            links: [
                { text: "Général", href: "#settings-general", spa: true },
                { text: "Sécurité", href: "#settings-security", spa: true },
                { text: "Notifications", href: "#settings-notifications", spa: true }
            ]
        }
    }

    // Template des éléments de menu
    Component {
        id: menuDelegate

        Rectangle {
            id: menuItem
            width: menuList.width
            height: 50
            color: "transparent"
            border.width: 0
            border.color: "#37afe51a"

            property bool isActive: false
            property bool isHovered: mouseArea.containsMouse

            // Bordure du bas
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "#37afe51a"
            }

            // État normal/hover/active
            states: [
                State {
                    name: "hovered"
                    when: menuItem.isHovered && !menuItem.isActive
                    PropertyChanges {
                        target: menuItem
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#004678" + "4d" }
                            GradientStop { position: 1.0; color: "#00648c" + "8a" }
                        }
                    }
                    PropertyChanges {
                        target: menuText
                        color: "#0288f5c9"
                    }
                },
                State {
                    name: "active"
                    when: menuItem.isActive
                    PropertyChanges {
                        target: menuItem
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#004678" + "4d" }
                            GradientStop { position: 1.0; color: "#00648c" + "8a" }
                        }
                    }
                    PropertyChanges {
                        target: menuText
                        color: "#0288f5c9"
                    }
                }
            ]

            // Effet de brillance sur hover
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                opacity: menuItem.isHovered || menuItem.isActive ? 1 : 0

                // Effet glow/box-shadow
                layer.enabled: true
                layer.effect: ShaderEffect {
                    fragmentShader: "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.25, 0.72, 0.93, 0.8) + vec4(1.0, 1.0, 1.0, 0.3);
                        }
                    "
                }

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }

            // Flèche pour l'élément actif
            Text {
                id: activeIndicator
                text: "▶"
                color: "#4aa5ff"
                font.pixelSize: 12
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                visible: menuItem.isActive

                // Effet glow pour la flèche
                layer.enabled: true
                layer.effect: ShaderEffect {
                    fragmentShader: "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.29, 0.65, 1.0, 1.0);
                        }
                    "
                }
            }

            // Texte du menu
            Text {
                id: menuText
                text: model.title
                color: "#8cbceccb"
                font.family: "Segoe UI"
                font.pixelSize: 18
                anchors.left: parent.left
                anchors.leftMargin: menuItem.isActive ? 25 : 20
                anchors.verticalCenter: parent.verticalCenter

                // Effet text-shadow sur hover
                layer.enabled: menuItem.isHovered || menuItem.isActive
                layer.effect: ShaderEffect {
                    fragmentShader: "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.39, 0.79, 1.0, 0.71);
                        }
                    "
                }

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            // Zone de clic
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    // Désactiver tous les autres éléments
                    for (var i = 0; i < menuModel.count; i++) {
                        var item = menuList.itemAtIndex(i)
                        if (item && item !== menuItem) {
                            item.isActive = false
                        }
                    }
                    // Activer cet élément
                    menuItem.isActive = true

                    // Émettre le signal
                    sidebar.pageRequested(model.pageId)
                }
            }

            // Tooltip
            LegiTooltip {
                id: tooltip
                title: model.tooltipHeader
                linksData: model.links
                visible: mouseArea.containsMouse
                anchors.left: parent.right
                anchors.top: parent.top
                z: 99
            }

            // Transitions
            transitions: [
                Transition {
                    ColorAnimation { duration: 200 }
                    NumberAnimation { duration: 200 }
                }
            ]
        }
    }
}
