import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "Components"

PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.right: true

    implicitHeight: 30
    property color colYellow: "#f0c674"
    property color colHighlight: "#f9e8c7"
    property color colDarkGrey: "#282a2e" 
    property color colGrey: "#707880"
    property color colLightGrey: "#373b41" 
    property color colWhite: "#c5c8c6"
    property color colTransparent: "#000000ff"


    property string fontFamily: "FiraCode Nerd Font"
    property int fontSize: 14

    color: root.colTransparent

    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    property int memUsage: 0

    property string wifiIcon: "󰤮"

    property string btIcon: "󰂲"

    property int volume: 100

    property string batteryIcon: "󰁹"
    property int batteryValue: 100 

    property bool systemVisible: false
    property int bottomLeft: 5

    property bool volumeVisible: false

    property bool wifiVisible: false

    property bool btVisible: false

    Process {
        id: cpuProc
        command: ["sh","-c","head -1 /proc/stat"]
        stdout: SplitParser{
            onRead: data => {
                var p = data.trim().split(/\s+/)
                var idle = parseInt(p[4]) + parseInt(p[5])
                var total = p.slice(1,8).reduce((a,b) => a + parseInt(b),0)
                if (root.lastCpuTotal > 0){
                    cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)))
                }
                root.lastCpuIdle = idle
                root.lastCpuTotal = total
            }
        }
        Component.onCompleted: running = true
    }


    Process {
        id: memProc
        command: ["sh","-c","free | grep Mem"]
        stdout: SplitParser{
            onRead: data => {
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0

                root.memUsage = Math.round(100 * used / total)
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: wifiProc
        command: ["sh","-c","iw dev wlp0s20f3 link | grep signal"]
        stdout: SplitParser{
            onRead: data => {
                var parts = data.trim().split(/\s+/)

                if (parts.length >= 2){
                    var quality = parseInt(parts[1])

                    if (quality > -40 ) root.wifiIcon = "󰤨"
                    else if (quality > -60) root.wifiIcon = "󰤥"
                    else if (quality > -80) root.wifiIcon = "󰤢"
                    else root.wifiIcon = "󰤟"
                } else {
                    root.wifiIcon = "󰤮"
                }

            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: batteryProc
        command: ["sh","-c","
            data=$(upower -i $(upower -e | grep BAT0))
            percentage=$(echo \"$data\" | grep 'percentage' | awk '{print $2}')
            state=$(echo \"$data\" | grep 'state' | awk '{print $2}')
            echo \"$percentage $state\"
        "]
        stdout: SplitParser{
            onRead: data => {
                var parts = data.trim().split(/\s+/)
                
                var value = parseInt(parts[0])
                var state = parts[1]
                if(state == "charging"){
                    if ( value > 80 ) root.batteryIcon = "󰂅"
                    else if ( value > 60 ) root.batteryIcon = "󰂊"
                    else if ( value > 40 ) root.batteryIcon = "󰂈"
                    else if ( value > 5 ) root.batteryIcon = "󰂆"
                    else root.batteryIcon = "󰢟"
                } else {
                    if ( value > 80 ) root.batteryIcon = "󰁹"
                    else if ( value > 60 ) root.batteryIcon = "󰂁"
                    else if ( value > 40 ) root.batteryIcon = "󰁽"
                    else if ( value > 5 ) root.batteryIcon = "󰁻"
                    else root.batteryIcon = "󰂎"
                }
                root.batteryValue = value
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: btProc
        command: ["sh","-c","
            power=$(bluetoothctl show | grep -q \"Powered: yes\")
            connect=$(bluetoothctl devices Connected | grep -q \"Device\")
            echo \"$power $connect\"
        "]
        stdout: SplitParser{
            onRead: data => {
                var parts = data.trim().split(/\s+/)
                if (parts.length == 1){
                    root.btIcon = "󰂯"
                } else if (parts.length == 2){
                    root.btIcon = "󰂰"
                } else {
                    root.btIcon = "󰂲"
                }

            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: volumeProc
        command: ["sh","-c","wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser{
            onRead: data => {
                var parts = data.trim().split(/\s+/)
                root.volume = parseFloat(parts[1]) * 100
            }
        }
        Component.onCompleted: running = true
    }
     

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
            wifiProc.running = true
            batteryProc.running = true 
            btProc.running = true
            volumeProc.running = true
        }
    }
    
    Rectangle {
        anchors{
            fill: parent
            topMargin: 5
            leftMargin: 5
            rightMargin: 5
            bottomMargin: 0
        }
        color: root.colDarkGrey

        topLeftRadius: 5
        topRightRadius: 5
        bottomLeftRadius: root.bottomLeft
        bottomRightRadius: 5
    }


    RowLayout {
        anchors{
            fill: parent
            topMargin: 6
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 0
        }
        
        IconText {
            content: "⏻"
            onClick: () =>{
                focusGrab.active = true
                root.systemVisible = !root.systemVisible

                root.volumeVisible = false
                root.wifiVisible = false
                root.btVisible = false

                system.uptimeProcess.running = true
                root.bottomLeft = root.bottomLeft == 5 ? 0 : 5
            }
        } 
        Rectangle { width: 1; height: 14; color: root.colGrey }

        Repeater {
            model: 9

            Rectangle {
                id: workspaceButton
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                
                width: 30
                height: parent.height
                visible: ws ? true : false
                
                color: isActive ? root.colLightGrey : root.colDarkGrey

                Text {
                    text: index + 1
                    anchors.centerIn: parent
                    color: root.colWhite
                    font { pixelSize: root.fontSize; bold: true }
                }
                
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    cursorShape: Qt.PointingHandCursor
                }

                Rectangle{
                    anchors{
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    height: 2
                    color: root.colYellow
                    visible: isActive
                }

            }
        }
        Rectangle { width: 1; height: 14; color: root.colGrey }

        Text {
            Layout.fillWidth: true

            property var ws: Hyprland.focusedWorkspace
            property var toplevels: ws.toplevels
            text: {
                var win = toplevels.values.find(t => t.activated)
                var name = win ? win.title : ""
                return name
            }
            elide: Text.ElideRight

            color: root.colWhite
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
        }


        LabelText {
            id: volumeButton
            label: "VOL "
            content: root.volume + "%"
            clickable: true
            onClick: () =>{
                focusGrab.active = true
                root.volumeVisible = !root.volumeVisible

                root.systemVisible = false
                root.wifiVisible = false
                root.btVisible = false
            } 
        }
        Rectangle { width: 1; height: 14; color: root.colGrey }


        LabelText {
            label: "RAM "
            content: root.memUsage + "%"
        }
        Rectangle { width: 1; height: 14; color: root.colGrey }


        LabelText {
            label: "CPU "
            content: root.cpuUsage + "%"
        }
        Rectangle { width: 1; height: 14; color: root.colGrey }

        IconText { 
            id: wifiButton
            content: root.wifiIcon
            onClick: () =>{
                focusGrab.active = true
                root.wifiVisible = !root.wifiVisible

                root.systemVisible = false
                root.volumeVisible = false
                root.btVisible = false
            }
        }
        Rectangle { width: 1; height: 14; color: root.colGrey }

        IconText {
            id: btButton
            content: root.btIcon 
            onClick: () =>{
                focusGrab.active = true
                root.btVisible = !root.btVisible

                root.systemVisible = false
                root.volumeVisible = false
                root.wifiVisible = false
            }
        }
        Rectangle { width: 1; height: 14; color: root.colGrey }

        LabelText {
            label: root.batteryIcon + " "
            content: root.batteryValue + "%"
        }
        Rectangle { width: 1; height: 14; color: root.colGrey }

        Text {
            id: clock
            text: Qt.formatDateTime(new Date(), "d-M-yyyy hh:mm:ss" )

            color: root.colYellow
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clock.text = Qt.formatDateTime(new Date(), "d-M-yyyy hh:mm:ss" )
            }
        }
    }

    SystemPopup {
        id: system
        visible: systemVisible
    }

    VolumePopup {
        id: volume
        visible: volumeVisible

        x: volumeButton.x + volumeButton.width/2 - width/2
    }

    WifiPopup {
        id: wifi
        visible: wifiVisible

        x: wifiButton.x + wifiButton.width/2 - width/2
    }

    BtPopup {
        id: bt
        visible: btVisible

        x: btButton.x + btButton.width/2 - width/2
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root,system,volume,wifi,bt]
        active: false

        onCleared: {
            root.systemVisible = false
            root.volumeVisible = false
            root.wifiVisible = false
            root.btVisible = false

            active = false
        }
    }

    Item {
        id: rootKeys
        anchors.fill: parent
        focus: true

        Keys.onPressed: (event) => {
            console.log("Key pressed:", event.key, "modifiers:", event.modifiers)
            
            if (event.key === Qt.Key_Escape) {
                root.systemVisible = false
                root.volumeVisible = false
                root.wifiVisible = false
                root.btVisible = false

                focusGrab.active = false
                return
            }
            
            event.accepted = true
        }
    }
}
