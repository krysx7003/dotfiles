import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Popup {
    implicitWidth: 300
    
    readonly property PwNode sink: Pipewire.defaultAudioSink

    readonly property bool muted: !!sink?.audio?.muted
    readonly property real volume: sink?.audio?.volume ?? 0

    PwObjectTracker {
        objects: [sink]
    }

    Connections {
        target: sink?.audio
    }

    Column {
        anchors.fill: parent
        anchors.topMargin: 10
        spacing: 10 

        SliderBox {
            labelText: "Volume"
            iconText: muted ?  "󰖁": "󰕾"
            sliderValue: volume
        }

        SliderBox {
            labelText: "Brightness"
            iconText: "󰃠"
            sliderValue: 0.25
        }

    }
}

