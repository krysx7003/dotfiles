pragma Singleton

import QtQuick

QtObject {

    readonly property QtObject colors: QtObject {
        property color primary: "#f0c674"
        property color secondary: "#c5c8c6"
        property color background: "#282a2e"
        property color background_alt: "#707880"
        property color highlight: "#373b41"
        property color highlight_primary: "#f9e8c7"
        property color transparent: "#000000ff"
    }
    readonly property QtObject fonts: QtObject {
        property font main: Qt.font({
            family: "FiraCode Nerd Font",
            pixelSize: 14,
            weight: Font.Bold
        })

        property font thin: Qt.font({
            family: "FiraCode Nerd Font",
            pixelSize: 14,
            weight: Font.Normal
        })

        property font medium: Qt.font({
            family: "FiraCode Nerd Font",
            pixelSize: 32,
            weight: Font.Bold
        })

        property font big: Qt.font({
            family: "FiraCode Nerd Font",
            pixelSize: 40,
            weight: Font.Bold
        })
    }
}
