import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick

Rectangle {
    id: button

    property string icon: ""
    property string labelText: ""
    property bool enabled: false

    property var toggleClick: () => console.log("toggle" + labelText)
    property var expandClick: () => console.log("expand" + labelText)

    property color backgroundColor: enabled ? root.colYellow : root.colGrey
    property color highlightColor: enabled ? root.colHighlight : root.colWhite
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

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 2
                Text {
                    Layout.preferredWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth

                    text: icon
                    color: button.textColor
                    font { family: root.fontFamily; pixelSize: root.fontSize }
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
                        property int textLen: labelText.length * 10
                        property bool needsMarquee: implicitWidth > textContainer.width

                        x: marqueeX

                        text: labelText
                        color: button.textColor
                        font { family: root.fontFamily; pixelSize: root.fontSize }

                        Component.onCompleted: {
                            marqueeX = 0
                            if (needsMarquee) {
                                marqueeTimer.start()
                            }
                        }

                        onImplicitWidthChanged: {
                            // If label changes later, re-check
                            if (needsMarquee && !marqueeTimer.running)
                                marqueeTimer.start()
                            else if (!needsMarquee && marqueeTimer.running)
                                marqueeTimer.stop()
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
