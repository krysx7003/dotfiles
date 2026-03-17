import Quickshell
import QtQuick

import "../Config"

Rectangle {
    id: button
    property var onClick: () => console.log("expand" + labelText)

    property color backgroundColor: Config.colors.primary
    property color highlightColor: Config.colors.highlight_primary
    property color textColor: Config.colors.background

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
