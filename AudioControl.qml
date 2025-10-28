import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1


Item {

    property alias volumeValue: slider.value

    id:root
    Layout.minimumWidth: 50
    Layout.maximumWidth: 150

    RowLayout{
        anchors.fill: root
        spacing: 2
        CustomButton{
          icon.source: "assets/icons/volume_mute.svg"
          icon.color: "#fff"
        }

        CustomSlider{
           id: slider
           Layout.fillWidth: true
           Layout.minimumWidth: 40
           Layout.maximumWidth: 110
           Layout.alignment: Qt.AlignVCenter
           value: 0.5

        }

        CustomButton{
          icon.source: "assets/icons/volume_up.svg"
          icon.color: "#fff"
        }

    }
}
