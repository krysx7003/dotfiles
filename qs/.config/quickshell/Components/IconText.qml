import Quickshell
import QtQuick
import QtQuick.Layouts

import "../Config"

Rectangle {
    property string content: ""
    property var onClick: () => console.log(content)
    property color baseColor: Config.colors.background
    property color highlightColor: Config.colors.highlight
    property color textColor: Config.colors.primary
    property font contentFont: Config.fonts.main
    property int compWidth: 25

    Layout.preferredWidth: compWidth
    Layout.preferredHeight: parent.height

    color: mArea.containsMouse ? highlightColor : baseColor

    Text {
        anchors.centerIn: parent
        text: content
        color: textColor
        font: contentFont
    }

    MouseArea {
        id: mArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: onClick()
        cursorShape: Qt.PointingHandCursor
    }
}
