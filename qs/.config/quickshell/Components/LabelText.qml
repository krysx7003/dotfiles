import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    property string label: ""
    property string content: ""
    property int padding: 10 
    Layout.preferredWidth: labelText.width + contentText.width + padding
    Layout.preferredHeight: parent.height

    color:  root.colDarkGrey

    Row {
        spacing: 2
        anchors.centerIn: parent
        
        Text {
            id: labelText
            text: label
            color: root.colYellow
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
        }
        
        Text {
            id: contentText
            text: content
            color: root.colWhite
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
        }
    }
}
