import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Popup {
    id: sysPopup
    property string uptime: ""
    property int textSize: 28
    property alias uptimeProcess: uptimeProc
    implicitHeight: 120


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

            color: root.colLightGrey
            radius: 5

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    text: "Uptime:"
                    color: root.colWhite
                    font { family: root.fontFamily; pixelSize: root.fontSize }
                    Layout.alignment: Qt.AlignVCenter 
                }
                
                Item { Layout.fillWidth: true }
                
                Text {
                    text: sysPopup.uptime
                    color: root.colWhite
                    font { family: root.fontFamily; pixelSize: root.fontSize }
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 5
            color: root.colYellow

            Row {
                anchors.fill: parent
                IconText {
                    height: parent.height
                    width: parent.width /5

                    baseColor: root.colYellow
                    highlightColor: root.colHighlight
                    textColor: root.colDarkGrey

                    textSize: sysPopup.textSize

                    topLeftRadius: 5
                    bottomLeftRadius: 5
                    content: "󰐥"
                    Process {
                       id: shutdownProc
                       command: ["shutdown", "-h", "now"]
                    }
                    onClick: () => { shutdownProc.running = true }
                }

                IconText {
                    height: parent.height
                    width: parent.width /5

                    baseColor: root.colYellow
                    highlightColor: root.colHighlight
                    textColor: root.colDarkGrey

                    textSize: sysPopup.textSize

                    content: "󰜉"
                    Process {
                       id: rebootProc
                       command: ["reboot"]
                    }
                    onClick: () => { rebootProc.running = true }
                }

                IconText {
                    height: parent.height
                    width: parent.width /5

                    baseColor: root.colYellow
                    highlightColor: root.colHighlight
                    textColor: root.colDarkGrey

                    textSize: sysPopup.textSize

                    content: ""
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

                    baseColor: root.colYellow
                    highlightColor: root.colHighlight
                    textColor: root.colDarkGrey

                    textSize: sysPopup.textSize

                    content: "󰒲"
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

                    baseColor: root.colYellow
                    highlightColor: root.colHighlight
                    textColor: root.colDarkGrey
                    
                    textSize: sysPopup.textSize

                    topRightRadius: 5
                    bottomRightRadius: 5

                    content: "󰍃"
                    onClick: () => { Hyprland.dispatch("exit") }
                }
            }
        }
    }
}
