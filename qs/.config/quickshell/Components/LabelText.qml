import Quickshell
import QtQuick
import QtQuick.Layouts

import "../Config"

Rectangle {
    property string label: ""
    property string content: ""
    property int padding: 10 
    Layout.preferredWidth: labelText.width + contentText.width + padding
    Layout.preferredHeight: parent.height

    color:  Config.colors.background

    Row {
        spacing: 2
        anchors.centerIn: parent
        
        Text {
            id: labelText
            text: label
            color: Config.colors.primary
            font: Config.fonts.main
        }
        
        Text {
            id: contentText
            text: content
            color: Config.colors.secondary
            font: Config.fonts.main
        }
    }
}
