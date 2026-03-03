import Quickshell
import QtQuick

Rectangle {
    id: button
    property var onClick: () => console.log("expand" + labelText)

    property color backgroundColor: root.colYellow
    property color highlightColor: root.colHighlight
    property color textColor: root.colDarkGrey

    width: 50
    height: 25

    color: mArea.containsMouse ? highlightColor : backgroundColor
    radius: 5

    MouseArea {
        id: mArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: () => {
            onClick()
        }
        cursorShape: Qt.PointingHandCursor
    }
}
