import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Item {
  id:root

  function clear(){
      elements.clear()
   }

   function read(data){
        if(data){
            for(var key of data.key()){
                if(data.stringValue(key)){
                    elements.append({
                        name: metadata.metaDataKeyToString(key),
                        value: metadata.stringValue(key)
                    })
                }
            }
        }
    }


   ListModel{
       id:elements
    }

   Item{
       anchors.margins: 15
        ListView{
            id:metaliste
            model: elements
            anchors.fill: parent
            delegate: RowLayout{
                id:row
                width: metaliste.width
                required property string name
                required property string value
                Label{
                    text: row.name + ": "
                    font.pixelSize: 16
                    color: "#fff"
                    Layout.preferredWidth: row.width/2

                }
                Label{
                    text: row.value
                    font.pixelSize: 16
                    color: "#fff"
                    Layout.fillWidth: true
                }
            }
        }
   }

   Label{
       anchors.centerIn: parent
       visible: !elements.count
       font.pixelSize: 16
       text: "No metadata present"
       color: "#fff"

   }


}
