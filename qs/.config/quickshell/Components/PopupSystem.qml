import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../Config"

Popup {
    id: sysPopup
    property string uptime: ""
    property int textSize: 28
    property alias uptimeProcess: uptimeProc
    implicitHeight: 100
    implicitWidth: 400


    Process {
        id: uptimeProc
        command: ["sh","-c","uptime -p"]
        stdout: SplitParser{
            onRead: data => {
                var match = data.trim().match(/up\s+(.+)/i)
                sysPopup.uptime = match ? match[1] : data.trim()
                uptimeProc.running = false
            } 
        }
        
        Component.onCompleted: running = true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10 
        
        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            color: Config.colors.highlight
            radius: 5

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    text: "Uptime:"
                    color: Config.colors.secondary
                    font: Config.fonts.thin
                    Layout.alignment: Qt.AlignVCenter 
                }

                Item {
                    id: textContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    Text {
                        id: textItem
                        anchors.verticalCenter: parent.verticalCenter

                        property real startX: textContainer.width - textItem.implicitWidth
                        property real marqueeX: startX
                        property bool needsMarquee: implicitWidth > textContainer.width

                        x: marqueeX

                        text: sysPopup.uptime
                        color: Config.colors.secondary
                        font: Config.fonts.thin

                        Component.onCompleted: {
                            marqueeX = textItem.startX 
                            if (needsMarquee) {
                                marqueeTimer.start()
                            }
                        }

                        onTextChanged: {
                            marqueeTimer.stop()
                            needsMarquee = implicitWidth > textContainer.width

                            marqueeX = textItem.startX
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
                                    textItem.marqueeX = Math.max(0,textItem.startX)
                                    inPause = true 
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            radius: 5
            color: Config.colors.primary

            Row {
                anchors.fill: parent
                IconText {
                    height: parent.height
                    width: parent.width /5

                    baseColor: Config.colors.primary
                    highlightColor: Config.colors.highlight_primary
                    textColor: Config.colors.background

                    topLeftRadius: 5
                    bottomLeftRadius: 5

                    content: "󰐥"
                    contentFont: Config.fonts.medium

                    Process {
                       id: shutdownProc
                       command: ["shutdown", "-h", "now"]
                    }
                    onClick: () => { shutdownProc.running = true }
                }

                IconText {
                    height: parent.height
                    width: parent.width /5

                    baseColor: Config.colors.primary
                    highlightColor: Config.colors.highlight_primary
                    textColor: Config.colors.background

                    content: "󰜉"
                    contentFont: Config.fonts.medium

                    Process {
                       id: rebootProc
                       command: ["reboot"]
                    }
                    onClick: () => { rebootProc.running = true }
                }

                IconText {
                    height: parent.height
                    width: parent.width /5

                    baseColor: Config.colors.primary
                    highlightColor: Config.colors.highlight_primary
                    textColor: Config.colors.background

                    content: ""
                    contentFont: Config.fonts.medium

                    Process {
                       id: lockProc
                       command: ["hyprlock"]
                    }
                    onClick: () => {
                        lockProc.running = true
                        root.systemVisible = false
                    }
                }

                IconText {
                    height: parent.height
                    width: parent.width /5

                    baseColor: Config.colors.primary
                    highlightColor: Config.colors.highlight_primary
                    textColor: Config.colors.background

                    content: "󰒲"
                    contentFont: Config.fonts.medium

                    Process {
                       id: suspendProc
                       command: ["systemctl","suspend"]
                    }
                    onClick: () => {
                        suspendProc.running = true
                        root.systemVisible = false
                    }
                }

                IconText {
                    height: parent.height
                    width: parent.width /5

                    baseColor: Config.colors.primary
                    highlightColor: Config.colors.highlight_primary
                    textColor: Config.colors.background

                    topRightRadius: 5
                    bottomRightRadius: 5

                    content: "󰍃"
                    contentFont: Config.fonts.medium
                    
                    onClick: () => { Hyprland.dispatch("exit") }
                }
            }
        }
    }
}
