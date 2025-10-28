import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts

Rectangle{
    id:root

    implicitWidth: 320
    radius: 5
    border.width: 2
    border.color: "#fff"
    color: Config.background

    property alias metadataInfo: metadatainfo



    TabBar{
        id:tabbar
        width: parent.width
        contentHeight:60

        Repeater{
            model: [qsTr("Metadata"), qsTr("Tracks"), qsTr("Theme")]
            TabButton{
                id:tab

                required property int index
                required property string modelData

                property string shadow: tabbar.currentIndex === index ? Config.selecteMenu : "black"
                property string textColor: tabbar.currentIndex === index ? Config.selecteMenu : "#fff"

                background: Rectangle {
                    opacity : 0.15
                    gradient: Gradient {
                       GradientStop { position: 0.0; color: "transparent"}
                       GradientStop {position: 0.5; color:"transparent"}
                       GradientStop { position: 1.0; color: tab.shadow}
                    }
                }

                contentItem: Label{
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: tab.modelData
                    font.pixelSize: 20
                    color: tab.textColor
                }

            }
        }
    }

    StackLayout{
        width: root.width
        anchors.top: tabbar.bottom
        anchors.bottom: root.bottom
        currentIndex: tabbar.currentIndex

        MetadataInfo{
            id: metadatainfo
        }

    }




}
