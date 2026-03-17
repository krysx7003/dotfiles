import QtQuick

import "../Config"

Column {
    property string labelText: ""
    property string iconText: ""

    property alias sliderValue: slider.value
    property alias barVisible: slider.barVisible
    property var onSlider: () => { console.log("test") }
    width: parent.width

    Text {
        text: labelText
        color: Config.colors.primary
        font: Config.fonts.main
    }

    Row {
        width: parent.width

        Text {
            id: icon
            text: iconText 
            color: Config.colors.primary
            font { family: root.fontFamily; bold: true }
        }
        Slider{
            id: slider
            width: parent.width - icon.width
            value: sliderValue

            onSlide: onSlider
        }
    }
}
