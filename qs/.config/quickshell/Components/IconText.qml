import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    property string content: ""
    property var onClick: () => console.log(content)
    property color baseColor: root.colDarkGrey
    property color highlightColor: root.colLightGrey
    property color textColor: root.colYellow
    property int textSize: root.fontSize

    Layout.preferredWidth: 25
    Layout.preferredHeight: parent.height
    
    color: mArea.containsMouse ? highlightColor : baseColor

    Text {
        anchors.centerIn: parent
        text: content
        color: textColor
        font { family: root.fontFamily; pixelSize: textSize; bold: true }
    }

    MouseArea {
        id: mArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: onClick()
        cursorShape: Qt.PointingHandCursor
    }
}
