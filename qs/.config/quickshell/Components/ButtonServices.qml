import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick

Rectangle {
    id: button

    property string labelText: ""
    property bool enabled: false

    property var toggleClick: () => console.log("toggle" + labelText)
    property var expandClick: () => console.log("expand" + labelText)

    property color backgroundColor: enabled ? root.colYellow : root.colWhite
    property color highlightColor: enabled ? root.colHighlight : root.colGrey
    property color textColor: root.colDarkGrey

    color: button.backgroundColor
    radius: 5

    implicitHeight: 25

    RowLayout {
        anchors.fill: parent

        Rectangle {
            Layout.fillWidth: true
            Layout.rightMargin: -5
            height: 25

            topLeftRadius: 5
            bottomLeftRadius: 5

            color: mArea.containsMouse ? highlightColor : backgroundColor

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10 

                text: labelText 
                color: button.textColor
                font { family: root.fontFamily; pixelSize: root.fontSize }
            }

            MouseArea {
                id: mArea
                anchors.fill: parent

                hoverEnabled: true
                onClicked: () => {
                    toggleClick()
                    button.enabled = !button.enabled
                }
                cursorShape: Qt.PointingHandCursor
            }
        }

        Rectangle {
            width: 2
            height: parent.height
            color: button.textColor
        }

        IconText{
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: -5
            compWidth: 15

            topRightRadius: 5
            bottomRightRadius: 5

            baseColor: button.backgroundColor
            highlightColor: button.highlightColor
            textColor: button.textColor

            content: ">"

            onClick: expandClick
        }
    }
}
