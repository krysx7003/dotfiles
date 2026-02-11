import Quickshell
import QtQuick
import QtQuick.Layouts

Popup {
    id: popup

    implicitWidth: 350
    implicitHeight: 685
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 25

            color: root.colLightGrey

            radius: 5

        }
        Calendar{
            id: calendar
            Layout.fillWidth: true
            Layout.preferredHeight: height  
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: root.colLightGrey

            radius: 5

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                Row {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop

                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 2

                        text: "Notifications"

                        color: root.colYellow
                        font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                    }

                    Button {
                        property string label: "󰎟 Clear"
                        anchors.right: parent.right
                        width:  label.length * 10 + 10
                        height: 20
                        
                        backgroundColor: root.colLightGrey
                        highlightColor: root.colGrey
                        textColor: root.colYellow

                        Text {
                            anchors.fill: parent
                            anchors.topMargin: 2
                            horizontalAlignment: Text.AlignHCenter
                            text: parent.label

                            color: parent.textColor
                            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                        }

                    }
                }
            }

        }
    }
} 
