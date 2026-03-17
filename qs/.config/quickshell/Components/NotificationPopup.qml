import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../Config"

Scope {
    id: notify

    property string appname
    property string title
    property string content
    property bool visible: false

	LazyLoader {
		id: popupLoader
        active: visible

        PanelWindow {
            id: popup

            anchors {
                top: true
                right: true
            }

            margins {
                top: 100
                right: 5
            }

            implicitWidth: rect.width
            implicitHeight: rect.height

            color: "transparent"

            Rectangle {
                id: rect
                color: Config.colors.background

                implicitHeight: layout.implicitHeight + 30
                implicitWidth: layout.implicitWidth + 30

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
                            text: notify.appname + " • "
                            color: Config.colors.primary
                            font: Config.fonts.main
                        }

                        Text {
                            text: notify.title
                            color: Config.colors.secondary
                            font: Config.fonts.main

                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true 
                        }
                    }

                    Text {
                        text: notify.content
                        color: Config.colors.secondary
                        font: Config.fonts.thin

                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true 
                    }
                }

                Rectangle {
                    id: bar
                    color: Config.colors.primary
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    bottomLeftRadius: 5
                    height: 10

                    PropertyAnimation {
                        id: anim
                        target: bar
                        property: "width"
                        from: rect.width
                        to: 0
                        duration: 2500
                        onFinished: popupLoader.active = false
                    }
                }

                Component.onCompleted: anim.start()
            }
        }

	}
}
