import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick

Rectangle {
    id: button

    property string labelText: ""
    property bool enabled: false

    property color backgroundColor: enabled ? root.colYellow : root.colLightGrey
    property color highlightColor: enabled ? root.colHighlight : root.colGrey
    property color textColor: enabled ? root.colDarkGrey : root.colWhite

    color: button.backgroundColor
    radius: 5

    implicitHeight: 25

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 5

        Text {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            text: labelText 
            color: button.textColor
            font { family: root.fontFamily; pixelSize: root.fontSize }
        }

        Rectangle {
            width: 2
            height: parent.height
            color: button.textColor
        }

        IconText{
            Layout.alignment: Qt.AlignVCenter
            compWidth: 15

            topRightRadius: 5
            bottomRightRadius: 5

            baseColor: button.backgroundColor
            highlightColor: button.highlightColor
            textColor: button.textColor

            content: ">"
        }
    }
}
