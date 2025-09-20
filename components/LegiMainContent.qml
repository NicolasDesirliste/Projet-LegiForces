import QtQuick
import QtQuick.Controls

Rectangle {
    id: mainContent

    // FOND AVEC GRADIENT ET EFFETS (déplacé depuis Main.qml)
    gradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#0f1f35" }
        GradientStop { position: 0.7; color: "#050f18" }
        GradientStop { position: 1.0; color: "#000102" }
    }

    // GRILLE DE LIGNES (TEXTURE)
    Canvas {
        anchors.fill: parent
        opacity: 0.2
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
        width: 180
        height: 6000
        y: 0
        visible: false
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: "#4d708a" }
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
        interval: 6000  // 12 secondes par passages
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
            to: mainContent.width + glareEffect.width + 200
            duration: 3000
        }
        NumberAnimation {
            target: glareEffect
            property: "y"
            to: mainContent.height + 200
            duration: 7000
        }
        onFinished: {
            glareEffect.visible = false
        }
    }

    border.color: "#0288f5"
    border.width: 1

    // Message volant en haut
    Rectangle {
        id: flyingMessage
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        z: 10

        color: "#0c0226"
        border.width: 1
        border.color: "#0288f5"

        // Bordure du bas
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 2
            color: "#1c4c6e"
        }

        Text {
            id: messageText
            text: "Bienvenue sur LegiForces! Système de gestion judiciaire moderne."
            color: "#0288f5"
            font.family: "Segoe UI"
            font.pixelSize: 20
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Zone de contenu principal avec StackView (SANS scrollbar)
    StackView {
        id: stackView
        anchors.top: flyingMessage.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 0
        clip: true

        // Animation de transition entre pages
        pushEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: stackView.width
                to: 0
                duration: 300
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
            }
        }

        pushExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: -stackView.width
                duration: 300
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
            }
        }

        popEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: -stackView.width
                to: 0
                duration: 300
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
            }
        }

        popExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: stackView.width
                duration: 300
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
            }
        }

        // Page par défaut (Dashboard)
        initialItem: Qt.createComponent("../pages/Dashboard.qml")
    }

    // Fonctions pour naviguer entre les pages
    function loadPage(pageId) {
        console.log("Chargement de la page:", pageId)

        var componentPath = "../pages/"
        var componentName = ""

        switch(pageId) {
            case "dashboard":
                componentName = "Dashboard.qml"
                messageText.text = "Tableau de bord - Vue d'ensemble de votre activité"
                break
            case "courtcases":
                componentName = "CourtCases.qml"
                messageText.text = "Gestion des affaires judiciaires"
                break
            case "users":
                componentName = "Users.qml"
                messageText.text = "Administration des utilisateurs"
                break
            case "documents":
                componentName = "Dashboard.qml" // Fallback pour l'instant
                messageText.text = "Gestion documentaire"
                break
            case "calendar":
                componentName = "Dashboard.qml" // Fallback pour l'instant
                messageText.text = "Planning et rendez-vous"
                break
            case "settings":
                componentName = "Dashboard.qml" // Fallback pour l'instant
                messageText.text = "Configuration système"
                break
            case "login":
                componentName = "Login.qml"
                messageText.text = "Connexion au système"
                break
            default:
                componentName = "Dashboard.qml"
                messageText.text = "Bienvenue sur LegiForces!"
        }

        try {
            var component = Qt.createComponent(componentPath + componentName)
            if (component.status === Component.Ready) {
                stackView.push(component)
            } else {
                console.error("Erreur lors du chargement de la page:", component.errorString())
                messageText.text = "Erreur: Page non trouvée"
            }
        } catch (error) {
            console.error("Erreur:", error)
            messageText.text = "Erreur de navigation"
        }
    }

    // Fonction pour revenir à la page précédente
    function goBack() {
        if (stackView.depth > 1) {
            stackView.pop()
            messageText.text = "Navigation: Retour"
        }
    }

    // Fonction pour aller à l'accueil
    function goHome() {
        stackView.clear()
        stackView.push(Qt.createComponent("../pages/Dashboard.qml"))
        messageText.text = "Tableau de bord - Accueil"
    }

    // Fonction pour mettre à jour le message
    function updateMessage(newMessage) {
        messageText.text = newMessage
    }
}

