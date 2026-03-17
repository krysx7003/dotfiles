import Quickshell
import QtQuick

import "../Config"

PopupWindow {
    property int x: 5
    anchor.window: root
    anchor.rect.x: x
    anchor.rect.y: root.height

    implicitWidth: 500
    implicitHeight: 200
    color: Config.colors.transparent

    Rectangle {
        anchors.fill: parent
        color: Config.colors.background
        bottomLeftRadius: 5
        bottomRightRadius: 5
    }
}
