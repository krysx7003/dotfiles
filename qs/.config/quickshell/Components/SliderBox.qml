import QtQuick

Column {
    property string labelText: ""
    property string iconText: ""

    property alias sliderValue: slider.value
    property alias barVisible: slider.barVisible
    property var onSlider: () => { console.log("test") }
    width: parent.width

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

            onSlide: onSlider
        }
    }
}
