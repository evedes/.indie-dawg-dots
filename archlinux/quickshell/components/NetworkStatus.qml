import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: network

    Layout.fillHeight: true
    Layout.leftMargin: 24
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    property string ipAddress: "..."
    property string barDl: ""
    property string barUl: ""
    property bool loading: false

    onBarDlChanged: if (barDl !== "" && barDl !== "0B/s") dlFlash.restart()
    onBarUlChanged: if (barUl !== "" && barUl !== "0B/s") ulFlash.restart()

    ListModel { id: addressModel }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true

        onContainsMouseChanged: {
            if (containsMouse && !detailProcess.running) {
                network.loading = true;
                detailProcess.running = true;
            }
        }
    }

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: 8

        Text {
            id: label
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter

            text: "󰈀 " + network.ipAddress
            color: Theme.accentBright
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizePrimary
            renderType: Text.NativeRendering
        }

        Text {
            id: dlArrow
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            visible: network.barDl !== ""
            text: "↓"
            color: Theme.accentBright
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizePrimary
            renderType: Text.NativeRendering

            ColorAnimation on color {
                id: dlFlash
                from: Theme.neonBlue
                to: Theme.accentBright
                duration: 800
            }
        }

        Text {
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            visible: network.barDl !== ""
            text: network.barDl
            color: Theme.accentBright
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizePrimary
            renderType: Text.NativeRendering
        }

        Text {
            id: ulArrow
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            visible: network.barUl !== ""
            text: "↑"
            color: Theme.accentBright
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizePrimary
            renderType: Text.NativeRendering

            ColorAnimation on color {
                id: ulFlash
                from: Theme.neonBlue
                to: Theme.accentBright
                duration: 800
            }
        }

        Text {
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            visible: network.barUl !== ""
            text: network.barUl
            color: Theme.accentBright
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizePrimary
            renderType: Text.NativeRendering
        }
    }

    PopupWindow {
        id: popup
        visible: hoverArea.containsMouse

        anchor {
            item: network
            edges: Edges.Bottom
            gravity: Edges.Bottom
            margins.bottom: -8
        }

        width: popupContent.width
        height: popupContent.height
        color: "transparent"

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
                spacing: 6

                Text {
                    text: "Network Devices"
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

                Text {
                    visible: network.loading && addressModel.count === 0
                    text: "Loading..."
                    color: Theme.textMuted
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSecondary
                    renderType: Text.NativeRendering
                }

                Repeater {
                    model: addressModel

                    delegate: RowLayout {
                        required property string device
                        required property string addr
                        required property string ping
                        required property string state
                        required property string dl
                        required property string ul
                        spacing: 12

                        Text {
                            text: device
                            color: addr ? Theme.textPrimary : Theme.textMuted
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 140
                        }
                        Text {
                            text: addr || "--"
                            color: addr ? Theme.textPrimary : Theme.textMuted
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 160
                        }
                        Text {
                            text: ping
                            color: {
                                if (ping === "OK") return Theme.neonBlue;
                                if (ping === "--") return Theme.textMuted;
                                return "#e46876";
                            }
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 40
                        }
                        Text {
                            text: "↓" + dl
                            color: ping === "OK" ? Theme.neonBlue : Theme.textMuted
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 90
                        }
                        Text {
                            text: "↑" + ul
                            color: ping === "OK" ? Theme.neonBlue : Theme.textMuted
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                        }
                    }
                }
            }
        }
    }

    Process {
        id: ipProcess
        command: ["sh", "-c", "ip -4 route get 8.8.8.8 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i==\"src\") print $(i+1)}'"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (trimmed) network.ipAddress = trimmed;
            }
        }
    }

    Process {
        id: detailProcess
        command: ["/home/edo/.indie-dawg-dots/archlinux/quickshell/scripts/network-info.sh"]
        running: true

        property var entries: []

        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (!trimmed) return;
                let parts = trimmed.split("|");
                if (parts.length >= 6) {
                    detailProcess.entries.push({
                        device: parts[0],
                        addr: parts[1],
                        ping: parts[2],
                        state: parts[3],
                        dl: parts[4],
                        ul: parts[5]
                    });
                }
            }
        }

        onRunningChanged: {
            if (!running) {
                if (entries.length > 0) {
                    addressModel.clear();
                    let found = false;
                    for (let entry of entries) {
                        addressModel.append(entry);
                        if (!found && entry.ping === "OK") {
                            network.barDl = entry.dl;
                            network.barUl = entry.ul;
                            found = true;
                        }
                    }
                    if (!found) {
                        network.barDl = "";
                        network.barUl = "";
                    }
                    entries = [];
                }
                network.loading = false;
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (!detailProcess.running) {
                detailProcess.running = true;
            }
        }
    }
}
