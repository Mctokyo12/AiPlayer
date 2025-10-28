import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Effects

Button {

    id: control
    flat: true
    icon.source: control.icon.source
    icon.color: "#fff"
    icon.height: 28
    icon.width: 28




    background: Rectangle{
        color: hovered ? Config.selecteMenu : "transparent"
        opacity: 0.1
        radius: 5
    }
}

