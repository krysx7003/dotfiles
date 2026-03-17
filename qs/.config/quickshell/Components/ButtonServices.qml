import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick

import "../Config"

Rectangle {
    id: button

    property string icon: ""
    property string labelText: ""
    property bool enabled: false

    property var onClick: () => console.log("expand" + labelText)

    property color backgroundColor: enabled ? Config.colors.primary : Config.colors.background_alt
    property color highlightColor: enabled ? Config.colors.highlight_primary : Config.colors.secondary
    property color textColor: Config.colors.background

    color: button.backgroundColor
    radius: 5

    implicitHeight: 25

    RowLayout {
        anchors.fill: parent

        Rectangle {
            Layout.fillWidth: true
            height: 25

            radius: 5
            color: mArea.containsMouse ? highlightColor : backgroundColor

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 2
                Text {
                    text: icon
                    color: button.textColor
                    font: Config.fonts.thin
                }
            
                Item {
                    id: textContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    Text {
                        id: textItem
                        anchors.verticalCenter: parent.verticalCenter

                        property real marqueeX: 0
                        property bool needsMarquee: implicitWidth > textContainer.width

                        x: marqueeX

                        text: labelText
                        color: button.textColor
                        font: Config.fonts.thin

                        Component.onCompleted: {
                            marqueeX = 0
                            if (needsMarquee) {
                                marqueeTimer.start()
                            }
                        }

                        onTextChanged: {
                            marqueeTimer.stop()
                            needsMarquee = implicitWidth > textContainer.width

                            marqueeX = 0
                            if (needsMarquee) {
                                marqueeTimer.start()
                            }
                        }
                    }

                    Timer {
                        id: marqueeTimer
                        property bool inPause: false
                        interval: inPause ? 5000 : 40
                        repeat: true
                        running: false

                        onTriggered: {
                            if (inPause) {
                                inPause = false
                            } else {
                                textItem.marqueeX -= 0.5
                                const minX = -(textItem.implicitWidth - textContainer.width/2)
                                if (textItem.marqueeX < minX) {
                                    textItem.marqueeX = 0
                                    inPause = true 
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: 2
                    height: parent.height
                    color: button.textColor
                }

                Text{
                    text: ">"
                    color: button.textColor
                    font: Config.fonts.main
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

    }
}
