import QtQuick
import QtQuick.Controls
import "components"

ApplicationWindow {
    id: window
    width: 1400
    height: 900
    visible: true
    title: "Legi Force Interface Principale"

    // Fond simple pour éviter les conflits
    color: "transparent"

    // Composants interface
    Item {
        anchors.fill: parent

        // Header
        LegiHeader {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            z: 30

            onLogoutRequested: mainContent.updateMessage("Déconnexion demandée")
            onHomeRequested: mainContent.goHome()
            onPlaceholderOneRequested: mainContent.updateMessage("Place Holder 1 - Fonction à venir")
            onPlaceholderTwoRequested: mainContent.updateMessage("Place Holder 2 - Fonction à venir")
        }

        // Sidebar gauche
        LegiSidebar {
            id: leftSidebar
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.bottom: footer.top
            z: 50

            onPageRequested: function(pageId) {
                mainContent.loadPage(pageId)
            }
        }

        // Sidebar droite
        LegiRightSidebar {
            id: rightSidebar
            anchors.top: header.bottom
            anchors.right: parent.right
            anchors.bottom: footer.top
            z: 50

            onActionRequested: function(actionId) {
                mainContent.updateMessage("Action: " + actionId)
            }
        }

        // COMPOSANT PRINCIPAL avec fond stylisé intégré
        LegiMainContent {
            id: mainContent
            anchors.top: header.bottom
            anchors.left: leftSidebar.right
            anchors.right: rightSidebar.left
            anchors.bottom: footer.top
        }

        // Footer
        LegiFooter {
            id: footer
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            z: 20

            userType: "Super Admin"
            sessionProgress: 11
        }
    }
}

/*
ApplicationWindow {
    id: window
    width: 1400
    height: 900
    visible: true
    title: "Legi Force Interface Principale"

    // FOND AVEC GRADIENT ET EFFETS
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#0f1f35" }
            GradientStop { position: 0.7; color: "#050f18" }
            GradientStop { position: 1.0; color: "#000102" }
        }

        // GRILLE DE LIGNES (TEXTURE)
        Canvas {
            anchors.fill: parent
            opacity: 0.6
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = "#000000"
                ctx.lineWidth = 1
                // Lignes verticales
                for (var x = 0; x < width; x += 10) {
                    ctx.beginPath()
                    ctx.moveTo(x, 0)
                    ctx.lineTo(x, height)
                    ctx.stroke()
                }
                // Lignes horizontales
                for (var y = 0; y < height; y += 10) {
                    ctx.beginPath()
                    ctx.moveTo(0, y)
                    ctx.lineTo(width, y)
                    ctx.stroke()
                }
            }
        }

        // EFFET DE BRILLANCE
        Rectangle {
            id: glareEffect
            width: 200
            height: 6000
            y: 0
            visible: false
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: "#b2dcf1" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            transform: Rotation {
                angle: 25
                origin.x: 100
                origin.y: height/2
            }
        }

        // TIMER POUR L'EFFET DE BRILLANCE
        Timer {
            id: glareTimer
            interval: 12000  // 12 secondes par passages
            running: true
            repeat: true
            onTriggered: {
                glareEffect.x = -glareEffect.width - 200
                glareEffect.y = -4000
                glareEffect.visible = true
                glareAnimation.start()
            }
        }

        // ANIMATION DE L'EFFET
        ParallelAnimation {
            id: glareAnimation
            NumberAnimation {
                target: glareEffect
                property: "x"
                to: window.width + glareEffect.width + 200
                duration: 3000
            }
            NumberAnimation {
                target: glareEffect
                property: "y"
                to: window.height + 200
                duration: 7000
            }
            onFinished: {
                glareEffect.visible = false
            }
        }
    }

    // Composants interface par-dessus le fond
    Item {
        anchors.fill: parent

        // Header avec transparence
        LegiHeader {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            z: 30

            onLogoutRequested: statusText.text = "Déconnexion demandée"
            onHomeRequested: statusText.text = "Accueil demandé"
            onPlaceholderOneRequested: statusText.text = "Place Holder 1 cliqué"
            onPlaceholderTwoRequested: statusText.text = "Place Holder 2 cliqué"
        }

        // Sidebar gauche transparente
        LegiSidebar {
            id: leftSidebar
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.bottom: footer.top
            z: 50

            onPageRequested: function(pageId) {
                statusText.text = "Navigation: " + pageId
                console.log("Navigation vers:", pageId)
            }
        }

        // Sidebar droite transparente
        LegiRightSidebar {
            id: rightSidebar
            anchors.top: header.bottom
            anchors.right: parent.right
            anchors.bottom: footer.top
            z: 50

            onActionRequested: function(actionId) {
                statusText.text = "Action: " + actionId
                console.log("Action demandée:", actionId)
            }
        }

        // Zone centrale avec effet verre
        Rectangle {
            anchors.top: header.bottom
            anchors.left: leftSidebar.right
            anchors.right: rightSidebar.left
            anchors.bottom: footer.top
            color: "transparent"  // Très transparent
            border.width: 1
            border.color: "#0288f5"  // Bordure blanche semi-transparente

            Rectangle {
                    id: flyingMessage
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 30
                    z: 10

                    color: "#0c0226"
                    border.width: 1
                    border.color: "#0288f5"

                    Text {
                        text: "Bienvenue sur LegiForces - Système de gestion judiciaire"
                        color: "#0288f5"
                        font.pixelSize: 20
                        anchors.centerIn: parent
                    }
                }


             Text {
                id: statusText
                anchors.centerIn: parent
                text: "Interface LegiForces avec fond stylisé\n\nSidebar gauche: Navigation\nSidebar droite: Actions rapides\n\nEffet de brillance toutes les 12 secondes"
                color: "white"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter

                // Effet de texte lumineux
                layer.enabled: true
                layer.effect: ShaderEffect {
                    fragmentShader: "
                        uniform lowp sampler2D source;
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 tex = texture2D(source, qt_TexCoord0);
                            gl_FragColor = tex + vec4(0.3, 0.5, 1.0, 0.3);
                        }
                    "
                }
            }
        }

        // Footer avec transparence
        LegiFooter {
            id: footer
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            z: 20

            userType: "Super Admin"
            sessionProgress: 11
        }
    }
}


