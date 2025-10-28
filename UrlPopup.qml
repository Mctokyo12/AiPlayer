import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts

Popup {
   id: root

   implicitHeight: 200
   implicitWidth: 450
   modal: true

   property bool isUrl: false
   property string path: ""

    function valideUrl(url){
       let pattern =/^([a-z]+:){1,2}\/\/.+/
       return pattern.test(url)
    }

    function setUrl(url){
        let path = url
        root.close()
    }


    Overlay.modal: Rectangle {
        color: "#aacfdbe7"
        opacity: 0.5
    }

    background: Rectangle{
       color: Config.background
       radius: 5
       border.color: "#fff"
       border.width: 1
    }


    contentItem: ColumnLayout{
        id: columnItem
        anchors.fill: parent
        spacing: 0
        anchors.margins: 10

        Label{
            id: popupLabel
            text: qsTr("Entre L'Url")
            font.pixelSize: 18
            color: "#fff"
            anchors.horizontalCenter: columnItem.horizontalCenter
        }



        ColumnLayout{
            anchors.horizontalCenter: columnItem.horizontalCenter
            spacing: 5

            TextField{
                id: textField
                implicitWidth: 300
                padding:10
                font.pixelSize: 16
                color: '#fff'
                background: Rectangle{
                    radius:5
                    border.color: textField.text ? (!error.visible ? Config.selecteMenu : 'red'  ) :  Config.white
                    border.width: 1
                    color: 'transparent'
                }

                placeholderText: "URL:"
                placeholderTextColor: '#fff'
            }

            Rectangle{
                id:error
                implicitHeight: 30
                implicitWidth: 60
                color: 'red'
                border.width: 0
                radius: 3

                visible: false

                Label{
                    padding: 5
                    id: text
                    text: qsTr("erreur")
                    color: '#Fff'
                    anchors.centerIn: parent
                    font.pixelSize: 16
                }

                onVisibleChanged: erroAnimation.start()

                NumberAnimation {
                    id:erroAnimation
                    target: error
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }


        RowLayout{
            anchors.horizontalCenter: columnItem.horizontalCenter

            Button{
                id:btn2
                leftPadding:40
                // implicitHeight: 30
                // implicitWidth: 80

                background: Rectangle{
                    color: Config.bordure
                    border.color: Config.selecteMenu
                    border.width: 0
                    radius: 3
                }

                contentItem: Label{
                    text: qsTr("Annuler")
                    font.pixelSize: 20
                    anchors.horizontalCenter: btn2.horizontalCenter
                    anchors.verticalCenter: btn2.verticalCenter
                    color: '#fff'
                }

                onClicked: {
                    root.close()
                }

            }

            Button {
                id: btn1
                leftPadding:40
                enabled: textField.text
                background: Rectangle{
                    color: Config.selecteMenu
                    border.color: Config.selecteMenu
                    border.width: 0
                    radius: 3
                }

                contentItem: Label{
                    text: qsTr("ok")
                    font.pixelSize: 20
                    anchors.centerIn: btn1
                    color: '#fff'
                }

                onClicked: {
                    if(valideUrl(textField.text)){
                        setUrl(textField.text)
                        isUrl = true
                    }else{
                        error.visible = true
                    }
                }
            }
        }
    }

    onClosed: {
        textField.text = ""
        error.visible = false
    }
}
