import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Dialogs
import QtMultimedia

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 500
    minimumWidth: 400
    minimumHeight: 400
    flags: Qt.Window | Qt.FramelessWindowHint
    color: Config.background
    palette.windowText:Config.text

    property alias metadataInfo: setting.metadataInfo



    // Propriétés pour la taille cible
    property int normalX: mainWindow.x
    property int normalY: mainWindow.y
    property int normalWidth: mainWindow.width
    property int normalHeight: mainWindow.height

    property bool isFullScreen: false

    // pour le fichier
    property string currentPath:"";
    property alias currentfile: playlist.currentfile

    // les tableaux des extention
    property var  audioExtension : ["MP3" , "WMA" , "M4A" , "AAC" , "WAV"]
    property var  videoExtension : ["MP4" , "AVI" , "MKV" ,"MOV","WMV"]

    // nos differentes fonctions
    function playMedia(){
        mediaplayer.source = playlist.getSource()
        currentPath = playlist.getSource()
        mediaplayer.play()
    }

    function openfile(path){
        ++currentfile
        playlist.addFile(path)
        mediaplayer.source = path
        mediaplayer.play()
    }

    function getFilename(path){
        if(path === ""){
            return ""
        }else{
            let paths =  path.split("/")
            return paths[paths.length-1]
        }
    }

    function getExtension(path){
        if(path===""){
            return " "
        }else{
            let paths  = path.split("/")
            path = paths[paths.length-1]
            let extension = path.split(".")[1]

            return  extension.toUpperCase()
        }
    }



    // fonction pour gerer le mode plien ecran

    function toggleFullscreen(){
        if(isFullScreen){
            mainWindow.showNormal()
        }else{
            mainWindow.showFullScreen()
        }
        isFullScreen = !isFullScreen
    }

   // redimension la fenetre a gauche
    MouseArea {
        id: leftBorder
        width: 5
        height: parent.height
        anchors.left: parent.left
        cursorShape: Qt.SizeHorCursor

        onPressed: mouse.startX = mouse.x
        onMouseXChanged: {
            if (mouse.buttons & Qt.LeftButton) {
                let delta = mouse.x - mouse.startX
                if (mainWindow.width - delta >= mainWindow.minimumWidth) {
                    mainWindow.x += delta
                    mainWindow.width -= delta
                }
            }
        }
    }

    // redisionne la fenetre  a droit
    MouseArea {
        id: rightBorder
        width: 5
        height: parent.height
        anchors.right: parent.right
        cursorShape: Qt.SizeHorCursor
        onPressed: mouse.startX = mouse.x
        onMouseXChanged: {
            if (mouse.buttons & Qt.LeftButton) {
                if (mainWindow.width + (mouse.x - mouse.startX) >= mainWindow.minimumWidth) {
                    mainWindow.width += mouse.x - mouse.startX
                    // mouse.startX = mouse.x
                }
            }
        }
    }


    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: {
            if(!playbackseekcontrole.opacity)
                if(isFullScreen){
                    hideAnimation.start()
                }else{
                    playbackseekcontrole.hiddenAnim.start()
                }
            else{
                shwoTime.restart()
            }
        }
    }


    Timer{
        id:shwoTime
        interval: 3000
        onTriggered: {
            if(!playbackseekcontrole.isPlaySlider){
                if(isFullScreen){
                    showAnimation.start()
                }else{
                    playbackseekcontrole.showAnim.start()
                }
            }else{
                shwoTime.restart()
            }
        }
    }



    WindowBar{
        id:windowbar
        win: mainWindow
        file: getFilename(currentPath)
        extension: getExtension(currentPath)
        z:1
    }

    MyMenu{
        id:mymenu
        // topPadding: 20
        y:33
        x:5

        Action{
            text:qsTr("Ouvrier un fichier")
            onTriggered: filedialog.open()
            shortcut: "Ctrl+O"
        }


        Action{
            text:qsTr("Ouvrier une url")
            onTriggered: urlpopup.open()
            shortcut: "Ctrl+P"
        }

        Action{
            text: qsTr('Quiter')
            onTriggered: Qt.quit()
            shortcut: "Alt+F4"
        }

        Shortcut{
            sequence: "Alt+F4"
            onActivated: Qt.quit()
        }
    }

    // pour choisir le fichier a lire
    FileDialog{
        id:filedialog
        title: qsTr("choisir un fichier")
        nameFilters: [ "Video files (*.mp4 *.mkv)", "All files (*)" ]
        currentFolder: StandardPath.standardLocations(StandardPaths.MoviesLocation)[0]
        onAccepted: {
            currentPath = filedialog.selectedFile
            openfile(currentPath)
        }

        Shortcut{
            sequence: "Ctrl+O"
            onActivated: filedialog.open()
        }

        Shortcut{
            sequence: "Ctrl+U"
            onActivated: urlpopup.open()
        }
    }

    MediaPlayer{
       id:mediaplayer
       // source: Qt.resolvedUrl(currentPath)
       videoOutput: videoOutput
       audioOutput: audioOutput
       source:{
          if( urlpopup.isUrl) {
              urlpopup.path
            }
        }
       function updateMetaDate(){
            mainWindow.metadataInfo.clear()
            mainWindow.metadataInfo.read(mediaplayer.metaData)
       }

       onMetaDataChanged: updateMetaDate()
       onActiveTracksChanged: updateMetaDate()
       onTracksChanged: updateMetaDate()

       onMediaStatusChanged: {
           if((MediaPlayer.EndOfMedia === mediaStatus && mediaplayer.loops !== MediaPlayer.Infinite) &&
                (mainWindow.currentfile < playlist.mediaCount-1  || playlist.isShuffled) ){
               if(!playlist.isShuffled){
                   ++mainWindow.currentfile
               }
               mainWindow.playMedia()
           }else if(MediaPlayer.EndOfMedia === mediaStatus && playbackcontole.isPlayPlayliste && playlist.mediaCount){
               mainWindow.currentfile = 0;
               // currentPath = playlist.files[currentfile]
               mainWindow.playMedia()

           }
       }
    }

    AudioOutput{
        id:audioOutput
        volume: playbackcontole.valueVolume
    }

    VideoOutput{
        id:videoOutput
        anchors.top: isFullScreen ? parent.top :  windowbar.bottom
        anchors.bottom: isFullScreen ? parent.bottom : playbackcontole.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: isFullScreen ? 0 : 20
        anchors.rightMargin: isFullScreen ? 0 : 20
        // visible: videoExtension.includes(getExtension(currentPath))
        visible: mediaplayer.hasVideo

        TapHandler{
          acceptedButtons: Qt.LeftButton
          onDoubleTapped: toggleFullscreen()
        }

    }


    PlaybackSeekControle{
        id:playbackseekcontrole
        anchors.bottom: playbackcontole.top
        anchors.left: videoOutput.left
        anchors.right: videoOutput.right
        fullscreenBtn.onClicked: toggleFullscreen()
        z:1
    }

    Rectangle{
        id:rectangle
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: playbackseekcontrole.opacity ? playbackseekcontrole.top : playbackcontole.top
        opacity: isFullScreen ?  0.75: 0.5
        color: Config.background
    }

    Image {
        id: shadow
        source: "assets/icons/Shadow_Blue.png"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: coverpage
        source: "assets/icons/Default_Cover.svg"
        anchors.centerIn: parent
        height: parent.height === 500 ? 300 : 400
        width:  parent.width === 800 ? 320 : 400
        // visible: audioExtension.includes(getExtension(currentPath))
        visible: !videoOutput.visible && mediaplayer.hasAudio
    }

    Label {
        anchors.centerIn: parent
        font.pixelSize: 24
        visible: !videoOutput.visible  && !coverpage.visible
        text: qsTr("Click <font color=\"#41CD52\">ici</font> pour ouvrier un fichier")
        color: "#fff";
        TapHandler{
            cursorShape: "PointingHandCursor"
            onTapped: {
                filedialog.open()
            }
        }
    }




    PlaybackControle{
      id: playbackcontole
      win: mainWindow
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      mediaPlayer: mediaplayer

      onPlayNextFile:{
        if(playlist.mediaCount){
            if(!playlist.isShuffled){
                ++mainWindow.currentfile
                if(mainWindow.currentfile > playlist.mediaCount-1 && isPlaylistLoop){
                    mainWindow.currentfile = 0
                }else if(mainWindow.currentfile > playlist.mediaCount-1 && !isPlaylistLoop){
                    ++mainWindow.currentfile
                }
            }
        }
        // currentPath = playlist.files[currentfile]
        mainWindow.playMedia()
      }

      onPlayPreviourFile: {
          if(playlist.mediaCount){
                if(!playlist.isShuffled){
                   --mainWindow.currentfile
                  if(mainWindow.currentfile < 0  && isPlayPlayliste){
                     mainWindow.currentfile = playlist.mediaCount-1
                  }else if (mainWindow.currentfile < 0 && !isPlaylistLoop){
                    ++mainWindow.currentfile
                  }
                }
            }
           // currentPath = playlist.files[currentfile]
           mainWindow.playMedia()
        }



    }

    Setting{
        id:setting
        anchors.right: parent.right
        anchors.bottom: playbackseekcontrole.opacity ? playbackseekcontrole.top : playbackcontole.top
        anchors.top: windowbar.bottom
        anchors.topMargin: 10
        anchors.rightMargin: 10
        visible: false
    }

    PlaylistInfo{
        id:playlist
        anchors.right: parent.right
        anchors.bottom: playbackseekcontrole.opacity ? playbackseekcontrole.top : playbackcontole.top
        anchors.top: windowbar.bottom
        anchors.topMargin: 10
        anchors.rightMargin: 10
        visible: playbackcontole.isVisiblePlayList
        isShuffled: playbackcontole.isShuffle
        media: mediaplayer

        onPlaylistUpdated: {
            if (mediaplayer.playbackState == MediaPlayer.StoppedState && mainWindow.currentfile < playlist.mediaCount - 1) {
                ++mainWindow.currentfile
                mainWindow.playMedia()
            }
        }
        onCurrentFileRemoved: {
            mediaplayer.stop()
            if (mainWindow.currentfile < playlist.mediaCount - 1) {
                mainWindow.playMedia()
            } else if (playlist.mediaCount) {
                --mainWindow.currentfile
                mainWindow.playMedia()
            }
        }
    }

    UrlPopup{
      id:urlpopup
      anchors.centerIn: parent
   }



    ParallelAnimation{
        id:showAnimation
        PropertyAnimation{
            targets: [playbackcontole , shadow , rectangle , playbackseekcontrole]
            property: "opacity"
            to:0
            duration: 1000
            easing: Easing.InOutQuad
        }

        PropertyAnimation{
            targets: playbackcontole
            property: "anchors.bottomMargin"
            to:-playbackcontole.height-playbackseekcontrole.height
            duration: 1000
            easing: Easing.InOutQuad
        }
    }

    ParallelAnimation{
        id:hideAnimation
        PropertyAnimation{
            targets: [playbackcontole , shadow ,playbackseekcontrole]
            property: "opacity"
            to:1
            duration: 1000
            easing: Easing.InOutQuad
        }

        PropertyAnimation{
            targets: playbackcontole
            property: "anchors.bottomMargin"
            to:0
            duration: 1000
            easing: Easing.InOutQuad
        }

        PropertyAnimation{
            target: rectangle
            property: "opacity"
            to:0.5
            duration: 1000
            easing: Easing.InOutQuad
        }
    }
}




