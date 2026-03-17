import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "Components"
import "Config"

PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.right: true

    implicitHeight: 30

    color: Config.colors.transparent

    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    property int memUsage: 0

    property string wifiIcon: "󰤮"
    property bool wifiEnabled: false
    property string wifiSSID: "No network connected"

    property string btIcon: "󰂲"
    property bool btEnabled: false
    property string btDevice: "Disabled"

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: !!sink?.audio?.muted
    property string volIcon: muted ? "󰖁" : "󰕾"

    property string batteryIcon: "󰁹"
    property int batteryValue: 100

    property bool systemVisible: false
    property int bottomLeft: 5
    property int bottomRight: 5

    property bool servicesVisible: false

    property bool clockVisible: false

    property ObjectModel notifyModel: notificationServer.trackedNotifications

    property var closeAllPopups: () => {
        root.systemVisible = false;
        root.servicesVisible = false;
        root.clockVisible = false;
        root.bottomLeft = 5;
        root.bottomRight = 5;

        focusGrab.active = false;
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim().split(/\s+/);
                var idle = parseInt(p[4]) + parseInt(p[5]);
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                if (root.lastCpuTotal > 0) {
                    cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)));
                }
                root.lastCpuIdle = idle;
                root.lastCpuTotal = total;
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;

                root.memUsage = Math.round(100 * used / total);
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: wifiProc
        command: ["sh", "-c", "~/.config/quickshell/Scripts/wifi.sh"]
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(/\s+/);
                var state = parseInt(parts[0]);

                if (state == 100) { //Replace with variables
                    root.wifiEnabled = true;
                    var quality = parseInt(parts[2]);
                    root.wifiSSID = parts[1];

                    if (quality > -40)
                        root.wifiIcon = "󰤨";
                    else if (quality > -60)
                        root.wifiIcon = "󰤥";
                    else if (quality > -80)
                        root.wifiIcon = "󰤢";
                    else
                        root.wifiIcon = "󰤟";
                } else if (state == 30) {
                    root.wifiEnabled = true;
                    root.wifiIcon = "󰤯";
                    root.wifiSSID = "No network connected";
                } else {
                    root.wifiEnabled = false;
                    root.wifiIcon = "󰤮";
                    root.wifiSSID = "Disabled";
                }
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: batteryProc
        command: ["sh", "-c", "~/.config/quickshell/Scripts/battery.sh"]
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(/\s+/);

                var value = parseInt(parts[0]);
                var state = parts[1];
                if (state == "charging") {
                    if (value > 80)
                        root.batteryIcon = "󰂅";
                    else if (value > 60)
                        root.batteryIcon = "󰂊";
                    else if (value > 40)
                        root.batteryIcon = "󰂈";
                    else if (value > 5)
                        root.batteryIcon = "󰂆";
                    else
                        root.batteryIcon = "󰢟";
                } else {
                    if (value > 80)
                        root.batteryIcon = "󰁹";
                    else if (value > 60)
                        root.batteryIcon = "󰂁";
                    else if (value > 40)
                        root.batteryIcon = "󰁽";
                    else if (value > 5)
                        root.batteryIcon = "󰁻";
                    else
                        root.batteryIcon = "󰂎";
                }
                root.batteryValue = value;
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: btProc
        command: ["sh", "-c", "~/.config/quickshell/Scripts/bt.sh"]
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(/\s+/);
                if (parts[1] == "yes") {
                    root.btEnabled = true;
                    root.btIcon = "󰂯";
                    if (parts.length > 2) {
                        root.btIcon = "󰂰";

                        var devName = "";
                        for (var i = 4; i < parts.length; i++) {
                            devName += parts[i] + " ";
                        }

                        root.btDevice = devName;
                    } else {
                        root.btDevice = "No device connected";
                    }
                } else {
                    root.btEnabled = false;
                    root.btIcon = "󰂲";
                    root.btDevice = "Disabled";
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            batteryProc.running = true;
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            wifiProc.running = true;
            btProc.running = true;
        }
    }

    Rectangle {
        anchors {
            fill: parent
            topMargin: 5
            leftMargin: 5
            rightMargin: 5
            bottomMargin: 0
        }
        color: Config.colors.background

        topLeftRadius: 5
        topRightRadius: 5
        bottomLeftRadius: root.bottomLeft
        bottomRightRadius: root.bottomRight
    }

    RowLayout {

        anchors {
            fill: parent
            topMargin: 6
            leftMargin: 10
            rightMargin: 15
            bottomMargin: 0
        }

        IconText {
            Layout.leftMargin: -5
            Layout.rightMargin: -5
            Layout.preferredWidth: content.length * 30

            topLeftRadius: 5
            bottomLeftRadius: 5

            content: "⏻"
            onClick: () => {
                root.servicesVisible = false;
                root.clockVisible = false;
                root.bottomRight = 5;

                focusGrab.active = true;
                root.systemVisible = !root.systemVisible;
                root.bottomLeft = root.systemVisible ? 0 : 5;

                system.uptimeProcess.running = true;
            }
        }
        Rectangle {
            width: 1
            height: 14
            color: Config.colors.background_alt
        }

        Repeater {
            model: 9

            Rectangle {
                id: workspaceButton
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                width: 30
                height: parent.height
                visible: ws ? true : false

                color: isActive ? Config.colors.highlight : Config.colors.background

                Text {
                    text: index + 1
                    anchors.centerIn: parent
                    color: Config.colors.secondary
                    font: Config.fonts.main
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    cursorShape: Qt.PointingHandCursor
                }

                Rectangle {
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    height: 2
                    color: Config.colors.primary
                    visible: isActive
                }
            }
        }
        Rectangle {
            width: 1
            height: 14
            color: Config.colors.background_alt
        }

        Text {
            Layout.fillWidth: true

            property var ws: Hyprland.focusedWorkspace
            property var toplevels: ws.toplevels
            text: {
                var win = toplevels.values.find(t => t.activated);
                var name = win ? win.title : "";
                return name;
            }
            elide: Text.ElideRight

            color: Config.colors.secondary
            font: Config.fonts.main
        }

        LabelText {
            label: "RAM "
            content: root.memUsage + "%"
        }
        Rectangle {
            width: 1
            height: 14
            color: Config.colors.background_alt
        }

        LabelText {
            label: "CPU "
            content: root.cpuUsage + "%"
        }
        Rectangle {
            width: 1
            height: 14
            color: Config.colors.background_alt
        }

        IconText {
            id: servicesButton

            Layout.leftMargin: -5
            Layout.rightMargin: -5
            Layout.preferredWidth: content.length * 8

            content: root.btIcon + " " + root.volIcon + " " + root.wifiIcon
            onClick: () => {
                root.systemVisible = false;
                root.clockVisible = false;
                root.bottomLeft = 5;
                root.bottomRight = 5;

                focusGrab.active = true;
                root.servicesVisible = !root.servicesVisible;
            }
        }
        Rectangle {
            width: 1
            height: 14
            color: Config.colors.background_alt
        }

        LabelText {
            label: root.batteryIcon + " "
            content: root.batteryValue + "%"
        }
        Rectangle {
            width: 1
            height: 14
            color: Config.colors.background_alt
        }

        Rectangle {
            id: clockButton
            topRightRadius: 5
            bottomRightRadius: 5
            height: parent.height
            Layout.leftMargin: -5
            Layout.rightMargin: -10
            width: 175

            color: calArea.containsMouse ? Config.colors.highlight : Config.colors.background

            Text {
                id: clockWidget
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 5
                text: Qt.formatDateTime(new Date(), "dd-MM-yyyy hh:mm:ss")

                color: Config.colors.primary
                font: Config.fonts.main

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clockWidget.text = Qt.formatDateTime(new Date(), "dd-MM-yyyy hh:mm:ss")
                }
            }

            MouseArea {
                id: calArea
                anchors.fill: parent

                hoverEnabled: true
                onClicked: () => {
                    root.systemVisible = false;
                    root.servicesVisible = false;
                    root.bottomLeft = 5;

                    focusGrab.active = true;
                    root.clockVisible = !root.clockVisible;
                    root.bottomRight = root.clockVisible ? 0 : 5;
                }
                cursorShape: Qt.PointingHandCursor
            }
        }
    }

    NotificationPopup {
        id: notifyPopup
        appname: "Test"
        title: "Text"
        content: "Text"
    }

    NotificationServer {
        id: notificationServer

        showPopup: notify => {
            notifyPopup.appname = notify.appName;
            notifyPopup.title = notify.summary;
            notifyPopup.content = notify.body;

            notifyPopup.visible = true;
        }
    }

    PopupSystem {
        id: system
        visible: root.systemVisible
    }

    PopupServices {
        id: services
        visible: root.servicesVisible

        x: servicesButton.x + servicesButton.width / 2 - width / 2
    }

    PopupClock {
        id: clock
        visible: root.clockVisible

        x: clockButton.x - width / 2 + 10
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root, system, services, clock]
        active: false

        onCleared: {
            root.closeAllPopups();
        }
    }

    Item {
        id: rootKeys
        anchors.fill: parent
        focus: true

        Keys.onPressed: event => {
            console.log("Key pressed:", event.key, "modifiers:", event.modifiers);

            if (event.key === Qt.Key_Escape) {
                root.closeAllPopups();
                return;
            }

            event.accepted = true;
        }
    }
    Reload {}
}
