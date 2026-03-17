import QtQuick
import QtQuick.Layouts

import "../Config"

Rectangle {
    id: calendarBox
    width: 300
    height: calendarLayout.height + 10

    color: Config.colors.highlight
    
    property int yearOffset: 0

    property int targetYear: new Date().getFullYear() + yearOffset
    property int targetMonth: new Date().getMonth()

    property date currentDate: new Date()
    property date selectedDate: new Date(targetYear, targetMonth, 1)
    property int firstDayOfMonth: selectedDate.getDay()
    property int firstDayOffset: (firstDayOfMonth + 6) % 7

    property int daysInMonth: new Date(targetYear, targetMonth + 1, 0).getDate()
                                        + firstDayOffset

    radius: 5
    
    ColumnLayout {
        id: calendarLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        Item { Layout.fillWidth: true; height: 10 }
        
        RowLayout {
            IconText {
                content: "<"

                radius: 10

                baseColor: Config.colors.highlight
                highlightColor: Config.colors.background_alt

                onClick: () => {
                    if (calendarBox.targetMonth - 1 < 0){
                        calendarBox.targetMonth = 11
                        calendarBox.yearOffset -= 1
                    }else {
                        calendarBox.targetMonth -= 1
                    }
                }
            }
            Text { 
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter

                color: Config.colors.primary
                text: Qt.formatDateTime(calendarBox.selectedDate, "MMMM yyyy")

                font: Config.fonts.main
            }
            IconText {
                content: ">"

                radius: 10

                baseColor: Config.colors.highlight
                highlightColor: Config.colors.background_alt

                onClick: () => {
                    if (calendarBox.targetMonth + 1 > 11){
                        calendarBox.targetMonth = 0
                        calendarBox.yearOffset += 1
                    }else {
                        calendarBox.targetMonth += 1
                    }
                }
            }
        }
        
        GridLayout {
            Layout.fillWidth: true
            columns: 7

            Repeater {
                model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                Text { 
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter

                    color: Config.colors.primary
                    text: modelData

                    font: Config.fonts.main
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        
        GridLayout {
            Layout.fillWidth: true

            columns: 7
            Repeater {
                model: daysInMonth

                Rectangle {
                    property int dayNum: index - firstDayOffset + 1
                    property bool isValidDay: index >= firstDayOffset
                    property bool isCurrentDay: currentDate.getDate() === dayNum &&
                                                currentDate.getMonth() === targetMonth &&
                                                currentDate.getFullYear() === targetYear

                    Layout.preferredHeight: 18
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter

                    color: isCurrentDay ? Config.colors.primary : Config.colors.highlight
                    radius: 10

                    Text {
                        anchors.fill: parent
                        color: parent.isCurrentDay ? Config.colors.background : Config.colors.secondary
                        text: parent.isValidDay ? parent.dayNum : " "
                        
                        font {
                            family: Config.fonts.main.family
                            pixelSize: Config.fonts.main.pixelSize
                            bold: parent.isValidDay && ((firstDayOfMonth + parent.dayNum - 1) % 7 === 0)
                        }
                        horizontalAlignment: Text.AlignHCenter
                        // onClicked: console.log("Selected:", currentDate, "day", index + 1)
                    }
                }

            }
        }
    }
}
