import Quickshell.Services.Pipewire
import QtQuick

Rectangle {
    readonly property PwNode sink: Pipewire.defaultAudioSink


    property string labelText: ""
    property string iconText: ""
    property var sliderValue: 0.0

    color: root.colLightGrey
    radius: 5

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 10
    anchors.rightMargin: 10

    implicitHeight: 65

    Column {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            text: labelText
            color: root.colYellow
            font { family: root.fontFamily; bold: true }
        }

        Row {
            width: parent.width

            Text {
                id: icon
                text: iconText 
                color: root.colYellow
                font { family: root.fontFamily; pixelSize: 22; bold: true }
            }
            Slider{
                id: slider
                width: parent.width - icon.width
                value: sliderValue

                onSlide: () => {
                    sink.audio.muted = false
                    sink.audio.volume = value
                }
            }
        }
    }
}
