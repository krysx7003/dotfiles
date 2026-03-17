import QtQuick
import QtQuick.Layouts

import "../Config"

Rectangle {
    id: notifyItem
    color: Config.colors.background

    property var onClick: () => console.log("Dismiss")

    property string appname
    property string title
    property string content

    implicitHeight: layout.implicitHeight + 20
    implicitWidth: parent.width 

    radius: 5

    ColumnLayout {
        id: layout
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: notifyItem.appname + " • "
                color: Config.colors.primary
                font: Config.fonts.main
            }

            Text {
                text: notifyItem.title
                color: Config.colors.secondary
                font: Config.fonts.main

                wrapMode: Text.WordWrap
                Layout.fillWidth: true 
            }
        }

        Text {
            text: notifyItem.content
            color: Config.colors.secondary
            font: Config.fonts.thin

            wrapMode: Text.WordWrap
            Layout.fillWidth: true 
        }
    }

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
