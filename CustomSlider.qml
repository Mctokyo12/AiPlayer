import QtQuick
import QtQuick.Controls.Fusion

Slider{
    id:slider
    background: Rectangle{
        x: slider.leftPadding
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitWidth: 120
        implicitHeight: 8
        width: slider.availableWidth
        height: implicitHeight
        opacity: 0.2
        radius: 10
        color: Config.selecteMenu
        border.width: 1
        border.color: Config.selecteMenu
    }

    handle: Rectangle{
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitHeight: 8
        implicitWidth: 8
        color: "transparent"
    }

    Rectangle{
        width: slider.visualPosition * slider.availableWidth
        x: slider.leftPadding
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        height: 8
        color: Config.selecteMenu
        radius: 10
    }
}
