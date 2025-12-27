import Quickshell
import QtQuick

Popup {
    Row {
        anchors.fill: parent
        Rectangle{
            width: parent.width/2
            height: 30
            color: "#ff0000"
        }

        Rectangle{
            width: parent.width/2
            height: 30
            color: "#0000ff"
        }
    }
}
