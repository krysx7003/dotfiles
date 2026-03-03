import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Bluetooth

Popup {
    id: popup

    implicitWidth: 350
    implicitHeight: 220
    
    readonly property PwNode sink: Pipewire.defaultAudioSink

    readonly property bool muted: !!sink?.audio?.muted
    readonly property real volume: sink?.audio?.volume ?? 0

    property real brightness: 1.0
    property string brightStr: ""

    PwObjectTracker {
        objects: [sink]
    }

    Connections {
        target: sink?.audio
    }

    Process {
        id: brightnessProc
        command: ["sh","-c","brightnessctl -m"]
        stdout: SplitParser{
            onRead: data => {
                var parts = data.trim().split(",")
                brightness = parseInt(parts[3]) / 100
            }
        }
        Component.onCompleted: running = true
    }


    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            brightnessProc.running = true
        }
    }

    Column {
        anchors.fill: parent
        anchors.topMargin: 10
        spacing: 10 

        Rectangle {
            color: root.colLightGrey
            radius: 5

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            implicitHeight: 75

            ColumnLayout {
                anchors.fill: parent

                Row {
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10

                    spacing: 5

                    ButtonServices {
                        icon: root.wifiIcon
                        labelText: root.wifiSSID
                        implicitWidth: parent.width/2

                        enabled: root.wifiEnabled

                        Process {
                            property bool isRunning: false

                            id:wifiExpand 
                            command: ["sh", "-c", "nmgui"]
                            
                            onStarted: isRunning = true
                            onExited: isRunning = false
                            
                            function toggle() {
                                console.log(isRunning)
                                if (isRunning) {
                                    isRunning = false
                                    return
                                } else {
                                    running = true
                                }
                            }
                        }

                        onClick: () => {
                            root.closeAllPopups()
                            wifiExpand.toggle()
                        }
                    }

                    ButtonServices {
                        icon: root.btIcon
                        labelText: root.btDevice
                        implicitWidth: parent.width/2

                        enabled: root.btEnabled

                        Process {
                            property bool isRunning: false

                            id:btExpand 
                            command: ["sh", "-c", "blueman-manager"]
                            
                            onStarted: isRunning = true
                            onExited: isRunning = false
                            
                            function toggle() {
                                console.log(isRunning)
                                if (isRunning) {
                                    isRunning = false
                                    return
                                } else {
                                    running = true
                                }
                            }
                        }

                        onClick: () => {
                            root.closeAllPopups()
                            btExpand.toggle()
                        }
                    }
                }

                Row {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    Layout.bottomMargin: 10

                    spacing: 5
                    Button {
                        id: sinkButton
                        property bool enabled: popup.muted

                        backgroundColor: enabled ? root.colYellow : root.colGrey
                        highlightColor: enabled ? root.colHighlight : root.colWhite

                        width: parent.width/2

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            text: sinkButton.enabled ? "󰖁 Muted": "󰕾 Unmuted"
                            color: sinkButton.textColor
                            font { family: root.fontFamily; pixelSize: root.fontSize }
                        }
                    }

                    Button {
                        id: sourceButton
                        property bool enabled: false

                        backgroundColor: enabled ? root.colYellow : root.colGrey
                        highlightColor: enabled ? root.colHighlight : root.colWhite

                        width: parent.width/2

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            text: sinkButton.enabled ? "󰍭 Muted": "󰍬 Unmuted"
                            color: sourceButton.textColor
                            font { family: root.fontFamily; pixelSize: root.fontSize }
                        }

                    }
                }
            }
        }

        Rectangle {
            color: root.colLightGrey
            radius: 5

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            implicitHeight: 115

            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                SliderBox {
                    id: volBox
                    labelText: "Volume"
                    iconText: muted ?  "󰖁": "󰕾"
                    sliderValue: volume
                    barVisible: !muted

                    onSlider: () => {
                        sink.audio.muted = false
                        sink.audio.volume = volBox.sliderValue
                    }

                }

                SliderBox {
                    id: brighBox
                    labelText: "Brightness"
                    iconText: "󰃠"
                    sliderValue: brightness

                    Process {
                        id: updateProc
                        command: ["sh", "-c", `brightnessctl set ${popup.brightStr}`]
                    }

                    onSlider: () => {
                        var val = Math.round(brighBox.sliderValue * 100)
                        brightStr = val + "%"

                        updateProc.running = true
                    }
                }
            }
        }

    }
}

