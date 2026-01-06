import QtQuick
import QtQuick.Controls.Basic

Slider {
    id: control
    property color colFilled: root.colYellow
    property var onSlide: () => { console.log("test") }

    value: 0.5

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 25
        width: control.availableWidth
        height: implicitHeight
        radius: 5
        color: "#bdbebf"

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: control.colFilled
            radius: 5
            visible: control.value >= 0.05
        }

        Rectangle {
            width: 0.05 * parent.width
            height: parent.height
            color: control.colFilled
            radius: 5
            visible: control.value < 0.05 && control.value != 0
        }
    }

    handle: nil
    onMoved: onSlide()

}
