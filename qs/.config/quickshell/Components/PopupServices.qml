import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire

Popup {
    id: popup

    implicitWidth: 350
    implicitHeight: 190
    
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

            implicitHeight: 45

            Row {
                anchors.fill: parent
                anchors.margins: 10

                spacing: 10

                ButtonServices {
                    icon: root.wifiIcon
                    labelText: root.wifiSSID
                    implicitWidth: parent.width/2 - 5

                    enabled: root.wifiEnabled
                }

                ButtonServices {
                    icon: root.btIcon
                    labelText: root.btDevice
                    implicitWidth: parent.width/2 - 5

                    enabled: root.btEnabled
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

