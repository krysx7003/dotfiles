import Quickshell
import QtQuick

PopupWindow {
    property int x: 5
    anchor.window: root
    anchor.rect.x: x
    anchor.rect.y: root.height

    implicitWidth: 500
    implicitHeight: 200
    color: root.colTransparent

    Rectangle {
        anchors.fill: parent
        color: root.colDarkGrey
        bottomLeftRadius: 5
        bottomRightRadius: 5
    }
}
