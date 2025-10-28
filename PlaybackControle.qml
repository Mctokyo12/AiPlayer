import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {

    required property ApplicationWindow win
    required property MediaPlayer mediaPlayer
    property alias valueVolume: audio.volumeValue
    property alias next_play: next
    property alias previeur_play: previous
    property bool isPlaylistLoop: false
    property bool isVisiblePlayList: false
    property bool isShuffle: false

    signal playNextFile()
    signal playPreviourFile()



    id:root
    implicitHeight: 100

    // anchors.leftMargin: 20
    // anchors.rightMargin: 20

    function changeModePlay(){
        if(mediaPlayer.loops === 1 && !isPlaylistLoop){
            mediaPlayer.loops = MediaPlayer.Infinite
        }else if(mediaPlayer.loops === MediaPlayer.Infinite){
            mediaPlayer.loops = 1
            isPlaylistLoop = true;
        }else{
           isPlaylistLoop = false;
           mediaPlayer.loops = 1
        }
    }

    RowLayout{
        anchors.fill: root
        spacing: Screen.primaryOrientation === Qt.LandscapeOrientation ? 5 : 1
        anchors.leftMargin: 13
        anchors.rightMargin: 13
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            Layout.fillWidth: true
        }

        // RowLayout{
        //     CustomButton{
        //       icon.source: "assets/icons/skip_previous.svg"
        //        // main:wi
        //     }

        //     CustomButton{
        //       icon.source: "assets/icons/check_box.svg"
        //        onClicked: mediaplayer.playbackState === MediaPlayer.PlayingState ? mediaplayer.stop() : mediaplayer.play()
        //     }

        //     CustomButton{
        //       icon.source: "assets/icons/skip_next.svg"
        //       // main:win
        //     }


        //     CustomButton{
        //       icon.source: "assets/icons/repeat.svg"
        //       icon.color: "#fff"
        //        // main:win
        //     }

        //     CustomButton{
        //         icon.source: "assets/icons/shuffle.svg"
        //         icon.color: "#fff"
        //         // main:win
        //     }
        // }

        Item{
            Layout.fillWidth: true
        }

        RowLayout{
          Layout.alignment: Qt.AlignHCenter
          Layout.fillWidth: true

            CustomButton{
              icon.source: !isShuffle ?  "assets/icons/shuffle.svg" : "assets/icons/Shuffle_Active.svg"
              icon.color: "#fff"
              onClicked: isShuffle = !isShuffle
            }

           CustomButton{
                id: previous
                icon.source: "assets/icons/skip_previous.svg"
                onClicked: playPreviourFile()
            }

            CustomButton{
                icon.source: "assets/icons/backward10.svg"
                onClicked: {
                    mediaplayer.position = mediaplayer.position - 10000
                }
                icon.height: 20
                icon.width: 20

                Shortcut{
                    sequence: 'Left'
                    onActivated: {
                        mediaplayer.position = mediaplayer.position - 10000
                    }
                }

            }



            CustomButton{
                id:playBtn
               icon.source: "assets/icons/play.svg"
               icon.color: "#fff"
               icon.height: 50
               icon.width: 50

                onClicked: {
                   if(mediaplayer.playbackState === MediaPlayer.PlayingState){
                       mediaplayer.pause()
                    }else{
                       mediaplayer.play()
                   }
               }

                Shortcut{
                  sequence: "Space"
                  onActivated: {
                      if(mediaplayer.playbackState === MediaPlayer.PlayingState){
                          mediaplayer.pause()
                       }else{
                          mediaplayer.play()
                      }
                  }
                }



               states: [
                   State {
                       name: "paused"
                       when: mediaplayer.playbackState === MediaPlayer.PlayingState
                        PropertyChanges {
                           target: playBtn
                           icon.source: "assets/icons/pause.svg"
                       }
                   }
               ]

            }

            CustomButton{
                icon.source: "assets/icons/forward10.svg"
                onClicked: {
                    mediaplayer.position = mediaplayer.position + 10000
                }

                Shortcut{
                    sequence: 'Right'
                    onActivated: {
                        mediaplayer.position = mediaplayer.position + 10000
                    }
                }

                icon.height: 20
                icon.width: 20
            }

            CustomButton{
              id: next
              icon.source: "assets/icons/skip_next.svg"
              onClicked: playNextFile()
            }

            CustomButton{
              id:repeat
              onClicked: changeModePlay()
              icon.source: "assets/icons/repeat.svg"
              icon.color: "#fff"
              states: [
                  State {
                      name: "InfinityPlay"
                      when: mediaPlayer.loops === MediaPlayer.Infinite
                      PropertyChanges {
                           repeat.icon.source: "assets/icons/Single_Loop.svg"

                        }
                    } ,

                   State {
                      name: "PlayPlaliste"
                      when: isPlaylistLoop
                      PropertyChanges {
                          repeat.icon.source: "assets/icons/Loop_Playlist.svg"
                       }
                    },
                  State {
                      name: "none"
                      when: mediaPlayer.loops === 1
                      PropertyChanges {
                          repeat.icon.source: "assets/icons/repeat.svg"

                      }
                  }
                ]
            }
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout{
            // spacing: win.width === Screen.desktopAvailableWidth && win.height === Screen.desktopAvailableHeight ? 5 : 1

            AudioControl{
               id: audio
               Layout.fillHeight: true
               Layout.fillWidth: true
            }


            CustomButton{
                icon.source: "assets/icons/list_alt"
                icon.color: "#fff"
                onClicked: isVisiblePlayList = !isVisiblePlayList
            }
        }


    }
}
