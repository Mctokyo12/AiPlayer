import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtQuick.Dialogs
import QtMultimedia

Rectangle{
    id:root

    implicitWidth: 320
    radius: 5
    border.width: 2
    border.color: "#fff"
    color: Config.background

    property var files :[]
    property int currentfile: -1
    property bool isShuffled: false
    property int mediaCount: files.length
    property var  videoExtension : ["MP4" , "AVI" , "MKV" ,"MOV","WMV"]
    required property MediaPlayer media
    signal playlistUpdated()
    signal currentFileRemoved()

    function getSource(){

        if(isShuffled && files.length > 1){
           let nombre = Math.floor(Math.random() * files.length)
            while (nombre == currentfile){
                nombre = Math.floor(Math.random() * files.length)
            }

            currentfile = nombre

        }

        return files[currentfile].path
    }

    function getExtension(path){
        let paths  = path.split("/")
        path = paths[paths.length-1]
        let extension = path.split(".")[1]

        return  extension.toUpperCase()
    }

    function addFiles(Files){
        Files.forEach((file)=>{
            const url = new URL(file)
            files.push({
              path: url,
              ismovie: videoExtension.includes(getExtension(file.toString()))
            })
        })

        mediaCount = files.length
        listview.model = files

        playlistUpdated();

    }


    function addFile(file){

        files.push({
            path: file,
            ismovie:videoExtension.includes(getExtension(file.toString()))
        })

        listview.model = files
        mediaCount = files.length
    }



    function getFilename(path){
        if(path === ""){
            return ""
        }else{
            let paths =  path.split("/")
            return paths[paths.length-1]
        }
    }

    function removeFile(index){
        let removedIndex = index
        files.splice(index,1)
        listview.model = files
        mediaCount = files.length

        if (root.currentfile == removedIndex) {
            currentFileRemoved()
        } else if (root.currentfile > removedIndex) {
            --root.currentfile
        }
    }




    FileDialog{
        id:filedialog
        title: qsTr("choisisez un fichier a ajoute dans la playlist")
        nameFilters: ["Video files (*.mp4 *.mkv)", "All files (*)" ]
        currentFolder: StandardPath.standardLocations(StandardPaths.MoviesLocation)[0]
        fileMode: FileDialog.OpenFiles
        onAccepted: {
            root.addFiles(filedialog.selectedFiles)
        }
    }

    ListModel{
        id:elements
    }

    Item {
        id: list
        anchors.fill: root
        anchors.margins: 20

        RowLayout{
            id:header
            width: list.width

            Label{
                text: qsTr("PlayList")
                Layout.fillWidth: true
                font.pixelSize: 18
                color: "#fff"
            }
            CustomButton{
                icon.source: "assets/icons/Add_file_Dark.svg"

                TapHandler{
                    onTapped: filedialog.open()
                }
            }
        }


        ListView{
            id:listview
            model: files
            anchors.fill: list
            anchors.topMargin: header.height + 30
            spacing: 20
            delegate: RowLayout{
                id:row
                width: listview.width
                spacing: 15

                required property string path
                required property int index
                required property bool ismovie

                Image {
                    id:imageType
                    source: "assets/icons/Movie_Icon_Dark.svg"
                    // state: row.ismovie ? "imageChangeVideo" : "imageChangeAudio"

                    states: [
                        State {
                            name: "imageChangeVideo"
                            when: row.ismovie && row.index !== root.currentfile
                            PropertyChanges {
                                target: imageType
                                source: "assets/icons/Movie_Icon_Dark.svg"
                            }
                        } ,

                        State {
                            name: "imageChangeAudio"
                            when: !row.ismovie && row.index !== root.currentfile
                            PropertyChanges {
                                target: imageType
                                source:"assets/icons/Music_Icon_Dark.svg"
                            }
                        },

                        State {
                            name: "video_Play"
                            when: row.ismovie && row.index === root.currentfile
                            PropertyChanges {
                                target: imageType
                                source:"assets/icons/Movie_Active.svg"
                            }
                        },

                        State {
                            name: "audio_play"
                            when: !row.ismovie && row.index === root.currentfile
                            PropertyChanges {
                                target: imageType
                                source:"assets/icons/Music_Active.svg"

                            }
                        }
                    ]
                }

                Label {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    font.pixelSize: 18
                    text: getFilename(path)
                    color: row.index === root.currentfile ? Config.selecteMenu : "#fff"
                }

                Image {
                    source: "assets/icons/Trash_Icon_Dark.svg"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: removeFile(row.index)
                    }
                }
            }

            add: Transition {
                NumberAnimation{
                    property: "opacity"
                    from: 0.0
                    to: 1.0
                    duration: 400
                }

               NumberAnimation{
                    property: "scale"
                    from: 0.5
                    to: 1.0
                    duration: 400
                }
            }

            remove: Transition {
                NumberAnimation{
                    property: "opacity"
                    from: 1
                    to: 0.0
                    duration: 400
                }
            }
        }
    }





}
