import Quickshell
import QtQuick

Popup {
    id: popup

    implicitWidth: 350
    implicitHeight: 500
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        Calendar{
            width: parent.width

        }

    }

}
