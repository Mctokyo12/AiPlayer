import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {

    property alias fullscreenBtn: fullscreenBtn
    property alias showAnim: showseekAnim
    property alias isPlaySlider: playslider.pressed
    property alias hiddenAnim: hiddenseekAnim

    id:root
    implicitHeight: 40

    function getTime(duration){
        let secondDuration =   Math.round(duration/1000)
        let minute =  Math.round(secondDuration/60)
        let houre = Math.round(minute/60)
        let second = secondDuration%60
        return `${houre < 10 ? '0'+houre : houre}:${minute<10 ?'0'+minute : minute}:${second < 10 ? '0'+second : second}`
    }


    RowLayout{
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10


        Label{
            text: getTime(mediaplayer.position)
            color:"#fff"
        }

        CustomSlider{
            id:playslider
            enabled: mediaplayer.seekable
            value: mediaplayer.position > 0 ? mediaplayer.position/mediaplayer.duration : 0
            Layout.fillWidth: true
            onMoved: {
               mediaplayer.position = mediaplayer.duration * playslider.position

            }
        }


        Label{
            text:getTime(mediaplayer.duration)
            color:"#fff"
        }

        CustomButton{
            icon.source: "assets/icons/settings.svg"
            icon.color: "#fff"
        }

        CustomButton{
            id:fullscreenBtn
            icon.source: "assets/icons/ful-screen.svg"
            icon.color: "#fff"
        }
    }


    ParallelAnimation{
        id:showseekAnim

        NumberAnimation {
            target: root
            property: "opacity"
            to:0
            duration: 1000
            easing.type: Easing.InOutQuad
        }


        PropertyAnimation{
            target: root
            property: "anchors.bottomMargin"
            to: -root.height
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }

    ParallelAnimation{
        id:hiddenseekAnim

        NumberAnimation {
            target: root
            property: "opacity"
            to:1
            duration: 1000
            easing.type: Easing.InOutQuad
        }


        PropertyAnimation{
            target: root
            property: "anchors.bottomMargin"
            to: 0
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }







}
