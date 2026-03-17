import Quickshell
import QtQuick
import QtQuick.Layouts

import "../Config"

Popup {
    id: popup

    implicitWidth: 350
    implicitHeight: 685
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        RowLayout {
            Rectangle {
                Layout.preferredWidth: 60
                Layout.preferredHeight: 55
                color: Config.colors.highlight
                radius: 5

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    anchors.topMargin: 4
                    anchors.rightMargin: 9
                    text: "󰣇"
                    color: Config.colors.primary

                    font: Config.fonts.big
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 55
                color: Config.colors.highlight
                radius: 5

                Text {
                    id: clockWidget
                    anchors.fill: parent
                    anchors.margins: 5
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDateTime(new Date(), "hh:mm:ss" )

                    color: Config.colors.primary
                    font: Config.fonts.big

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clockWidget.text = Qt.formatDateTime(new Date(), "hh:mm:ss" )
                    }
                }
            }
        }
        Calendar{
            id: calendar
            Layout.fillWidth: true
            Layout.preferredHeight: height  
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Config.colors.highlight

            radius: 5

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Notifications"

                        color: Config.colors.primary
                        font: Config.fonts.main
                    }

                    Item { Layout.fillWidth: true } 

                    Button {
                        property string label: "󰎟 Clear"
                        width:  label.length * 10 + 10
                        height: 20
                        
                        backgroundColor: Config.colors.highlight
                        highlightColor: Config.colors.background_alt
                        textColor: Config.colors.primary

                        Text {
                            anchors.fill: parent
                            anchors.topMargin: 2
                            horizontalAlignment: Text.AlignHCenter
                            text: parent.label

                            color: parent.textColor
                            font: Config.fonts.main
                        }

                        onClick: () => {
                            console.log("Dismissing all notifications")
                            while (root.notifyModel.values.length > 0){
                                root.notifyModel.values[0].dismiss()
                            }

                        }
                    }
                }
                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: notificationsColumn.height
                    clip: true
                    
                    Column {
                        id: notificationsColumn
                        width: parent.width
                        spacing: 5
                        
                        Repeater {
                            model: root.notifyModel
                            NotificationBox {
                                appname: modelData.appName
                                title: modelData.summary
                                content: modelData.body
                                onClick: () => {
                                    console.log("Dismissing notification "+ modelData.id)
                                    modelData.dismiss()
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
} 
