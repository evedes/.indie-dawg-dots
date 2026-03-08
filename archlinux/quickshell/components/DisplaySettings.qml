import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

RowLayout {
    id: display

    Layout.fillHeight: true
    Layout.leftMargin: 24
    spacing: 4

    property int brightness: 100
    property bool popupOpen: false

    Text {
        id: cogLabel
        Layout.fillHeight: true
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

        width: popupContent.width
        height: popupContent.height
        color: "transparent"

        onVisibleChanged: {
            if (visible) popupCloseTimer.stop();
        }

        MouseArea {
            id: popupHover
            anchors.fill: parent
            hoverEnabled: true

            onContainsMouseChanged: {
                if (!containsMouse && !sliderMouse.pressed) {
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
            }
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
                    display.brightness = parseInt(currentMatch[2]);
                }
            }
        }
    }

    Process {
        id: brightnessSetProcess
        command: ["brightnessctl", "set", "100%"]
    }
}
