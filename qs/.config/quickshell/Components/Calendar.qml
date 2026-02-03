import QtQuick
import QtQuick.Layouts

Rectangle {
    id: calendarBox
    width: 300
    height: calendarLayout.height + 10

    color: root.colLightGrey
    
    property int yearOffset: 0

    property int targetYear: new Date().getFullYear() + yearOffset
    property int targetMonth: 1

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

                baseColor: root.colLightGrey
                highlightColor: root.colGrey

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

                color: root.colYellow
                text: Qt.formatDateTime(calendarBox.selectedDate, "MMMM yyyy")

                font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
            }
            IconText {
                content: ">"

                radius: 10

                baseColor: root.colLightGrey
                highlightColor: root.colGrey

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

                    color: root.colYellow
                    text: modelData

                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
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

                    color: isCurrentDay ? root.colYellow : root.colLightGrey
                    radius: 10

                    Text {
                        anchors.fill: parent
                        color: parent.isCurrentDay ? root.colDarkGrey : root.colWhite
                        text: parent.isValidDay ? parent.dayNum : " "
                        
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
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
