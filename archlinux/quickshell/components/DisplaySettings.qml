import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

RowLayout {
    id: display

    property var notificationService: null
    readonly property int notifCount: notificationService ? notificationService.count : 0

    Layout.fillHeight: true
    Layout.leftMargin: 24
    Layout.rightMargin: 24
    spacing: 4
    property bool hasBrightness: false
    property int brightness: 100
    property int barOpacity: Math.round(Theme.barOpacity * 100)
    property int textBrightness: Math.round(Theme.textBrightness * 100)
    property bool popupOpen: false
    property bool notifPanelOpen: false

    Text {
        id: clockLabel
        Layout.fillHeight: true
        verticalAlignment: Text.AlignVCenter

        color: Theme.accentBright
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizePrimary
        renderType: Text.NativeRendering

        function formatClock() {
            var now = new Date();
            var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
            var day = now.getDate();
            var suffix = (day === 1 || day === 21 || day === 31) ? "st"
                       : (day === 2 || day === 22) ? "nd"
                       : (day === 3 || day === 23) ? "rd"
                       : "th";
            return days[now.getDay()] + ", " + Qt.formatDateTime(now, "MMM d") + suffix + ", " + Qt.formatDateTime(now, "HH:mm");
        }

        Timer {
            interval: 60000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: clockLabel.text = clockLabel.formatClock()
        }

        Component.onCompleted: text = formatClock()
    }

    Text {
        id: bellIcon
        Layout.fillHeight: true
        Layout.leftMargin: 12
        verticalAlignment: Text.AlignVCenter

        text: display.notifCount > 0 ? "\uf0f3" : "\uf1f6"
        color: bellMouse.containsMouse || display.notifPanelOpen
            ? Theme.textPrimary
            : display.notifCount > 0 ? Theme.neonBlue : Theme.accentBright
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizePrimary
        renderType: Text.NativeRendering

        MouseArea {
            id: bellMouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: {
                display.notifPanelOpen = !display.notifPanelOpen;
                if (display.notifPanelOpen) display.popupOpen = false;
            }
        }
    }

    Text {
        visible: display.notifCount > 0
        Layout.fillHeight: true
        verticalAlignment: Text.AlignVCenter

        text: display.notifCount
        color: Theme.neonBlue
        font.family: Theme.fontFamily
        font.pixelSize: 13
        font.bold: true
        renderType: Text.NativeRendering
    }

    Text {
        id: cogLabel
        Layout.fillHeight: true
        Layout.leftMargin: 4
        verticalAlignment: Text.AlignVCenter

        text: "\uf013"
        color: cogMouse.containsMouse || display.popupOpen ? Theme.textPrimary : Theme.accentBright
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizePrimary
        renderType: Text.NativeRendering

        MouseArea {
            id: cogMouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton

            onClicked: {
                display.popupOpen = !display.popupOpen;
                if (display.popupOpen) {
                    display.notifPanelOpen = false;
                    brightnessReadProcess.running = true;
                }
            }

            onContainsMouseChanged: {
                if (containsMouse && display.popupOpen) {
                    popupCloseTimer.stop();
                } else if (!containsMouse && display.popupOpen) {
                    popupCloseTimer.restart();
                }
            }
        }
    }

    PopupWindow {
        id: popup
        visible: display.popupOpen

        anchor {
            item: cogLabel
            edges: Edges.Bottom
            gravity: Edges.Bottom
            margins.bottom: -16
        }

        implicitWidth: popupContent.width
        implicitHeight: popupContent.height
        color: "transparent"

        onVisibleChanged: {
            if (visible) popupCloseTimer.stop();
        }

        MouseArea {
            id: popupHover
            anchors.fill: parent
            hoverEnabled: true

            onContainsMouseChanged: {
                if (!containsMouse && !sliderMouse.pressed && !opacitySliderMouse.pressed && !textSliderMouse.pressed && !wallpaperMouse.containsMouse) {
                    popupCloseTimer.restart();
                } else {
                    popupCloseTimer.stop();
                }
            }
        }

        Rectangle {
            id: popupContent
            width: col.width + 32
            height: col.height + 24
            color: Theme.bgDark
            radius: 8
            border.color: Theme.borderAccent
            border.width: 1

            ColumnLayout {
                id: col
                anchors.centerIn: parent
                spacing: 10

                Text {
                    text: "Display"
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizePrimary
                    font.bold: true
                    renderType: Text.NativeRendering
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.borderAccent
                }

                ColumnLayout {
                    visible: display.hasBrightness
                    spacing: 6

                    RowLayout {
                        spacing: 8

                        Text {
                            text: "\uf185"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizePrimary
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Brightness"
                            color: Theme.textSecondary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: display.brightness + "%"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 40
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    Item {
                        Layout.preferredWidth: 220
                        Layout.preferredHeight: 24

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 4
                            radius: 2
                            color: Theme.bgLighter

                            Rectangle {
                                width: parent.width * (display.brightness / 100)
                                height: parent.height
                                radius: 2
                                color: Theme.neonBlue
                            }
                        }

                        Rectangle {
                            x: (parent.width - width) * (display.brightness / 100)
                            anchors.verticalCenter: parent.verticalCenter
                            width: 14
                            height: 14
                            radius: 7
                            color: sliderMouse.pressed ? Theme.neonBlue : Theme.textPrimary
                            border.color: Theme.neonBlue
                            border.width: 1
                        }

                        MouseArea {
                            id: sliderMouse
                            anchors.fill: parent
                            anchors.topMargin: -4
                            anchors.bottomMargin: -4

                            onPressed: (mouse) => {
                                setBrightness(mouse.x);
                            }

                            onPositionChanged: (mouse) => {
                                if (pressed) {
                                    setBrightness(mouse.x);
                                }
                            }

                            function setBrightness(mouseX) {
                                let pct = Math.round(Math.max(1, Math.min(100, (mouseX / width) * 100)));
                                display.brightness = pct;
                                applyThrottle.restart();
                            }
                        }
                    }
                }

                ColumnLayout {
                    spacing: 6

                    RowLayout {
                        spacing: 8

                        Text {
                            text: "\uf79f"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizePrimary
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Bar Opacity"
                            color: Theme.textSecondary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: display.barOpacity + "%"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 40
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    Item {
                        Layout.preferredWidth: 220
                        Layout.preferredHeight: 24

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 4
                            radius: 2
                            color: Theme.bgLighter

                            Rectangle {
                                width: parent.width * (display.barOpacity / 100)
                                height: parent.height
                                radius: 2
                                color: Theme.neonBlue
                            }
                        }

                        Rectangle {
                            x: (parent.width - width) * (display.barOpacity / 100)
                            anchors.verticalCenter: parent.verticalCenter
                            width: 14
                            height: 14
                            radius: 7
                            color: opacitySliderMouse.pressed ? Theme.neonBlue : Theme.textPrimary
                            border.color: Theme.neonBlue
                            border.width: 1
                        }

                        MouseArea {
                            id: opacitySliderMouse
                            anchors.fill: parent
                            anchors.topMargin: -4
                            anchors.bottomMargin: -4

                            onPressed: (mouse) => {
                                setOpacity(mouse.x);
                            }

                            onPositionChanged: (mouse) => {
                                if (pressed) {
                                    setOpacity(mouse.x);
                                }
                            }

                            function setOpacity(mouseX) {
                                let pct = Math.round(Math.max(0, Math.min(100, (mouseX / width) * 100)));
                                display.barOpacity = pct;
                                Theme.barOpacity = pct / 100;
                            }
                        }
                    }
                }

                ColumnLayout {
                    spacing: 6

                    RowLayout {
                        spacing: 8

                        Text {
                            text: "\uf031"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizePrimary
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Text Brightness"
                            color: Theme.textSecondary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: display.textBrightness + "%"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 40
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    Item {
                        Layout.preferredWidth: 220
                        Layout.preferredHeight: 24

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 4
                            radius: 2
                            color: Theme.bgLighter

                            Rectangle {
                                width: parent.width * (display.textBrightness / 100)
                                height: parent.height
                                radius: 2
                                color: Theme.neonBlue
                            }
                        }

                        Rectangle {
                            x: (parent.width - width) * (display.textBrightness / 100)
                            anchors.verticalCenter: parent.verticalCenter
                            width: 14
                            height: 14
                            radius: 7
                            color: textSliderMouse.pressed ? Theme.neonBlue : Theme.textPrimary
                            border.color: Theme.neonBlue
                            border.width: 1
                        }

                        MouseArea {
                            id: textSliderMouse
                            anchors.fill: parent
                            anchors.topMargin: -4
                            anchors.bottomMargin: -4

                            onPressed: (mouse) => {
                                setTextBrightness(mouse.x);
                            }

                            onPositionChanged: (mouse) => {
                                if (pressed) {
                                    setTextBrightness(mouse.x);
                                }
                            }

                            function setTextBrightness(mouseX) {
                                let pct = Math.round(Math.max(10, Math.min(100, (mouseX / width) * 100)));
                                display.textBrightness = pct;
                                Theme.textBrightness = pct / 100;
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.borderAccent
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: wallpaperRow.implicitHeight

                    RowLayout {
                        id: wallpaperRow
                        anchors.fill: parent
                        spacing: 8

                        Text {
                            text: "\uf03e"
                            color: wallpaperMouse.containsMouse ? Theme.neonBlue : Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizePrimary
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Wallpaper"
                            color: wallpaperMouse.containsMouse ? Theme.neonBlue : Theme.textSecondary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                        }

                        Item { Layout.fillWidth: true }
                    }

                    MouseArea {
                        id: wallpaperMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onContainsMouseChanged: {
                            if (containsMouse) {
                                popupCloseTimer.stop();
                            } else if (!popupHover.containsMouse) {
                                popupCloseTimer.restart();
                            }
                        }

                        onClicked: {
                            display.popupOpen = false;
                            waypaperProcess.running = true;
                        }
                    }
                }
            }
        }
    }

    PopupWindow {
        id: notifPanel
        visible: display.notifPanelOpen

        anchor {
            item: bellIcon
            edges: Edges.Bottom
            gravity: Edges.Bottom
            margins.bottom: -16
        }

        implicitWidth: notifRect.width
        implicitHeight: notifRect.height
        color: "transparent"

        MouseArea {
            id: notifPanelHover
            anchors.fill: parent
            hoverEnabled: true

            onContainsMouseChanged: {
                if (!containsMouse) {
                    notifCloseTimer.restart();
                } else {
                    notifCloseTimer.stop();
                }
            }
        }

        Rectangle {
            id: notifRect
            width: 360
            height: Math.min(notifCol.implicitHeight + 24, 500)
            color: Theme.bgDark
            radius: 8
            border.color: Theme.borderAccent
            border.width: 1

            ColumnLayout {
                id: notifCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "Notifications"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizePrimary
                        font.bold: true
                        renderType: Text.NativeRendering
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        visible: display.notifCount > 0
                        text: "Clear all"
                        color: clearAllMouse.containsMouse ? Theme.neonBlue : Theme.textMuted
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                        renderType: Text.NativeRendering

                        MouseArea {
                            id: clearAllMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { if (display.notificationService) display.notificationService.dismissAll(); }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.borderAccent
                }

                Text {
                    visible: display.notifCount === 0
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    Layout.bottomMargin: 20
                    horizontalAlignment: Text.AlignHCenter
                    text: "It's all so quiet... shhh, shhh..."
                    color: Theme.textMuted
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSecondary
                    renderType: Text.NativeRendering
                }

                Flickable {
                    visible: display.notifCount > 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(notifList.implicitHeight, 400)
                    contentHeight: notifList.implicitHeight
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    ColumnLayout {
                        id: notifList
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: display.notificationService ? display.notificationService.notifications : []

                            Rectangle {
                                id: notifItem
                                Layout.fillWidth: true
                                Layout.preferredHeight: notifContent.implicitHeight + 16
                                radius: 6
                                color: notifItemMouse.containsMouse ? Theme.bgLighter : "transparent"

                                required property var modelData
                                required property int index

                                ColumnLayout {
                                    id: notifContent
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 4

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 6

                                        Text {
                                            text: notifItem.modelData.appName
                                            color: Theme.neonBlue
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 12
                                            font.bold: true
                                            renderType: Text.NativeRendering
                                            elide: Text.ElideRight
                                            Layout.maximumWidth: 180
                                        }

                                        Item { Layout.fillWidth: true }

                                        Text {
                                            text: display.notificationService ? display.notificationService.timeAgo(notifItem.modelData.time) : ""
                                            color: Theme.textMuted
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 11
                                            renderType: Text.NativeRendering
                                        }

                                        Text {
                                            text: "\uf00d"
                                            color: dismissMouse.containsMouse ? Theme.neonBlue : Theme.textMuted
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 14
                                            renderType: Text.NativeRendering

                                            MouseArea {
                                                id: dismissMouse
                                                anchors.fill: parent
                                                anchors.margins: -4
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: { if (display.notificationService) display.notificationService.dismiss(notifItem.index); }
                                            }
                                        }
                                    }

                                    Text {
                                        visible: text !== ""
                                        Layout.fillWidth: true
                                        text: notifItem.modelData.summary
                                        color: Theme.textPrimary
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 14
                                        font.bold: true
                                        renderType: Text.NativeRendering
                                        wrapMode: Text.WordWrap
                                        maximumLineCount: 2
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        visible: text !== ""
                                        Layout.fillWidth: true
                                        text: notifItem.modelData.body
                                        color: Theme.textSecondary
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 13
                                        renderType: Text.NativeRendering
                                        wrapMode: Text.WordWrap
                                        maximumLineCount: 3
                                        elide: Text.ElideRight
                                    }
                                }

                                MouseArea {
                                    id: notifItemMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    z: -1
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: notifCloseTimer
        interval: 400
        repeat: false
        onTriggered: display.notifPanelOpen = false
    }

    Timer {
        interval: 60000
        running: display.notifPanelOpen
        repeat: true
        onTriggered: {
            if (display.notificationService) display.notificationService.notifications = display.notificationService.notifications.slice();
        }
    }

    Timer {
        id: popupCloseTimer
        interval: 300
        repeat: false
        onTriggered: display.popupOpen = false
    }

    Timer {
        id: applyThrottle
        interval: 50
        repeat: false
        onTriggered: {
            if (!brightnessSetProcess.running) {
                brightnessSetProcess.command = ["brightnessctl", "set", display.brightness + "%"];
                brightnessSetProcess.running = true;
            }
        }
    }

    Process {
        id: brightnessReadProcess
        command: ["brightnessctl", "info"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let currentMatch = data.match(/Current brightness:\s*(\d+)\s*\((\d+)%\)/);
                if (currentMatch) {
                    display.hasBrightness = true;
                    display.brightness = parseInt(currentMatch[2]);
                }
            }
        }
    }

    Process {
        id: brightnessSetProcess
        command: ["brightnessctl", "set", "100%"]
    }

    Process {
        id: waypaperProcess
        command: ["waypaper"]
    }
}
