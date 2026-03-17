import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../Config"

Scope {
	id: reload
	property bool failed;
	property string errorString;

	Connections {
		target: Quickshell

		function onReloadCompleted() {
			Quickshell.inhibitReloadPopup();
			reload.failed = false;
			popupLoader.loading = true;
		}

		function onReloadFailed(error: string) {
			Quickshell.inhibitReloadPopup();
			popupLoader.active = false;

			reload.failed = true;
			reload.errorString = error;
			popupLoader.loading = true;
		}
	}

	LazyLoader {
		id: popupLoader

		PanelWindow {
			id: popup

			anchors {
				top: true
				right: true
			}

			margins {
				top: 5
				right: 5
			}

			implicitWidth: rect.width
			implicitHeight: rect.height

			color: "transparent"

			Rectangle {
				id: rect
				color: Config.colors.background

				implicitHeight: layout.implicitHeight + 30
				implicitWidth: layout.implicitWidth + 30

                radius: 5

				ColumnLayout {
					id: layout
					anchors {
						top: parent.top
						left: parent.left
						topMargin: 10
						leftMargin: 10
					}

					Text {
                        text: reload.failed ? "Config: Reload failed." : "Config: Reloaded completed!"
						color: Config.colors.primary
                        font: Config.fonts.main
					}

					Text {
						text: reload.errorString
						color: Config.colors.secondary
                        font: Config.fonts.thin
						visible: reload.errorString != ""
                    }

                    RowLayout{

                        Text {
                            text: "Run"
                            color: Config.colors.secondary
                            font: Config.fonts.thin
                        }

                        Button {
                            implicitWidth: buttonContent.implicitWidth + 10

                            backgroundColor: Config.colors.background_alt
                            highlightColor: Config.colors.secondary


                            Text {
                                id: buttonContent

                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter

                                text: "qs log"
                                color: Config.colors.background
                                font: Config.fonts.thin
                            }

                            onClick: () => {
                                Quickshell.clipboardText = "qs log"
                            }
                        }

                        Text {
                            text: "to view the log"
                            color: Config.colors.secondary
                            font: Config.fonts.thin
                        }
                    }
				}

				Rectangle {
					id: bar
					color: Config.colors.primary
					anchors.bottom: parent.bottom
					anchors.left: parent.left
                    bottomLeftRadius: 5
					height: 10

					PropertyAnimation {
						id: anim
						target: bar
						property: "width"
						from: rect.width
						to: 0
						duration: 5000
						onFinished: popupLoader.active = false
					}
				}

				Component.onCompleted: anim.start()
			}
		}
	}
}
