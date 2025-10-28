import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    required property ApplicationWindow win
    property string file
    property string extension
    id:root
    color: Config.barreMenu
    height: 32
    width: mainWindow.width
    property int currentPositionY


    Item {
        anchors.fill: parent
        DragHandler{
            id:resize
            grabPermissions: TapHandler.TakeOverForbidden
            onActiveChanged: {
                if(active){
                    var p = resize.centroid.position
                    let e = 0
                    if(p.y/root.height<0.10){e|=Qt.TopEdge;cursorShape= Qt.SizeVerCursor}

                    if(active){
                        mainWindow.startSystemResize(e)
                        mainWindow.startSystemMove();
                    }
                }
            }
        }
    }


   // redimensionnement du haut
    MouseArea {
        id: topBorder
        width: parent.width
        height: 5
        anchors.top: parent.top
        cursorShape: Qt.SizeVerCursor
        onPressed: mouse.startY = mouse.y
        onMouseYChanged: {
            if (mouse.buttons & Qt.LeftButton) {
                let delta = mouse.y - mouse.startY
                if (win.height - delta >= win.minimumHeight) {
                    win.y += delta
                    win.height -= delta
                }
            }
        }
    }





    RowLayout{
        id: display
        anchors.fill: parent
        // anchors.verticalCenter: windowbar.verticalCenter
        spacing: windowbar.spacing
        RowLayout{
            spacing: 7
            Layout.alignment: Qt.AlignLeft
            ToolButton {
                id:toolbutton
                flat:true
                implicitHeight: 30
                implicitWidth: 80

                contentItem: Row{
                    spacing: 0
                    anchors.centerIn: parent
                    Text {
                        text: qsTr("IAPlayer")
                        font.pixelSize: 14
                        color: toolbutton.hovered ? "#fff" : Config.text
                        clip: true

                    }
                    Image {
                        source: "assets/icons/stat_minus_white.svg"
                        sourceSize.width: 24
                        sourceSize.height: 24
                    }
                }

                Rectangle{
                    height: 30
                    width: 1
                    color: Config.background
                    anchors.right: toolbutton.right

                }


                background: Rectangle {
                    color: toolbutton.hovered ?  "#333333" : "transparent"
                }

                onClicked: mymenu.open()


            }

            Label{
                id:formatTitle
                text: extension
                color: Config.text
            }

            Rectangle{
                height: 18
                width: 1
                color: "#333333"
            }

            Label{
                text: file
                color: "#fff"
            }
        }

        Item {
            Layout.fillWidth: true
        }



        RowLayout{
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter

            spacing: 3
            component ControleButton: ToolButton{
                id: controlebtn
                flat: true
                icon.source: controlebtn.source
                icon.height: 18
                icon.width: 18

                icon.color: controlebtn.hovered ? "#fff" : Config.text

            }

            // Bouton Réduire (Minimiser) avec animation de fondu
            ControleButton {
                id: btnresize
                icon.source: "assets/icons/remove.svg"
                background: Rectangle{
                    color:btnresize.hovered ? Config.active : "transparent"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: minimizedAnimation.start()
                }
            }


            ControleButton{
                id:maximaze
                icon.source: win.width === Screen.desktopAvailableWidth && win.height === Screen.desktopAvailableHeight ? "assets/icons/restore_icon.svg" : "assets/icons/maximize_icon.svg"
                background: Rectangle{
                    color:maximaze.hovered ? Config.active : "transparent"
                }



                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        // Si la fenêtre est maximisée (plein écran), on restaure la géométrie normale
                        if (win.width === Screen.desktopAvailableWidth && win.height === Screen.desktopAvailableHeight) {
                            xAnimation.to = win.normalX
                            yAnimation.to = win.normalY
                            widthAnimation.to = win.normalWidth
                            heightAnimation.to = win.normalHeight

                        } else {
                            // Sinon, on stocke la géométrie actuelle pour pouvoir restaurer plus tard
                            win.normalX = win.x
                            win.normalY = win.y
                            win.normalWidth = win.width
                            win.normalHeight = win.height

                            // Et on maximise la fenêtre en positionnant le coin supérieur gauche à 0,0
                            xAnimation.to = 0
                            yAnimation.to = 0
                            widthAnimation.to = Screen.desktopAvailableWidth
                            heightAnimation.to = Screen.desktopAvailableHeight
                        }
                        // Démarrer toutes les animations simultanément
                        xAnimation.start()
                        yAnimation.start()
                        widthAnimation.start()
                        heightAnimation.start()
                    }
                }
            }

            // Bouton Fermer avec animation de fondu
            ControleButton{
                id:close
                icon.source: "assets/icons/close.svg"
                background: Rectangle{
                    color:close.hovered ? "red" : "transparent"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        closeAnimation.start()
                    }
                }
            }

        }
    }

    // on gerer les lorsque on clique sur les bouttons pour reduit agrandir et restorer
    NumberAnimation {
        id: xAnimation
        target: win
        property: "x"
        duration: 140
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: yAnimation
        target: win
        property: "y"
        duration: 140
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: widthAnimation
        target: win
        property: "width"
        duration: 140
        easing.type: Easing.InOutQuad
    }
    NumberAnimation {
        id: heightAnimation
        target: win
        property: "height"
        duration: 140
        easing.type: Easing.InOutQuad
    }


    // Animation de fondu pour la minimisation
    NumberAnimation {
        id:minimizedAnimation
        target: win
        property: "opacity"
        from: 1.0
        to:0
        duration: 200
        easing.type: Easing.InOutQuad
        onFinished: {
            win.showMinimized()
            win.opacity = 1.0
        }
    }
     // Animation de fondu pour la fermeture
    NumberAnimation {
        id:closeAnimation
        target: win
        property: "opacity"
        from: 1.0
        to:0
        duration: 200
        easing.type: Easing.InOutQuad
        onFinished: {
            Qt.quit()
        }
    }



}
