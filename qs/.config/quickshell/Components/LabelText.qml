import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    property string label: ""
    property string content: ""
    property bool clickable: false
    property var onClick: () => console.log(content)
    property bool scrollable: false
    property var onScroll: (wheel) => console.log(wheel.angleDelta.y)
    property int padding: clickable ? 10 : 0
    Layout.preferredWidth: labelText.width + contentText.width + padding
    Layout.preferredHeight: parent.height

    color: clickable && mouseArea.containsMouse ? root.colLightGrey : root.colDarkGrey

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

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: clickable
        enabled: clickable
        onClicked: if (clickable) onClick()
        onWheel: function(wheel) {
            if (scrollable) onScroll(wheel)
        }
        cursorShape: clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}
