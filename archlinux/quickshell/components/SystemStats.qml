import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: stats

    required property var service

    Layout.fillHeight: true
    Layout.leftMargin: 24
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    property string cpuTemp: ""
    property string uptime: ""
    property string loadAvg: ""
    property bool loading: false

    ListModel { id: coreModel }
    ListModel { id: procModel }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true

        onContainsMouseChanged: {
            if (containsMouse && !cpuInfoProcess.running) {
                stats.loading = true;
                cpuInfoProcess.running = true;
            }
        }
    }

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: 16

        Text {
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            visible: stats.service.cpuTemp !== ""

            text: "󰔏 " + stats.service.cpuTemp + "°C"
            color: {
                let t = parseInt(stats.service.cpuTemp);
                if (t >= 80) return "#e46876";
                if (t >= 60) return "#e6c384";
                return Theme.accentBright;
            }
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizePrimary
            renderType: Text.NativeRendering
        }

        Text {
            id: label
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter

            text: "󰍛 " + stats.service.cpuPercent + "%"
            color: Theme.accentBright
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizePrimary
            renderType: Text.NativeRendering
        }

        Text {
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter

            text: "󰘚 " + stats.service.ramPercent + "%"
            color: Theme.accentBright
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizePrimary
            renderType: Text.NativeRendering
        }

        Text {
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter

            text: "󰋊 " + stats.service.diskPercent + "%"
            color: Theme.accentBright
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizePrimary
            renderType: Text.NativeRendering
        }

        Text {
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter

            text: "󰢮 " + stats.service.gpuPercent + "%"
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
            item: stats
            edges: Edges.Bottom
            gravity: Edges.Bottom
            margins.bottom: -8
        }

        implicitWidth: popupContent.width
        implicitHeight: popupContent.height
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

                // Header row: title + temp + uptime
                RowLayout {
                    spacing: 16

                    Text {
                        text: "CPU"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizePrimary
                        font.bold: true
                        renderType: Text.NativeRendering
                    }

                    Text {
                        visible: stats.cpuTemp !== ""
                        text: "󰔏 " + stats.cpuTemp + "°C"
                        color: {
                            let t = parseInt(stats.cpuTemp);
                            if (t >= 80) return "#e46876";
                            if (t >= 60) return "#e6c384";
                            return Theme.textSecondary;
                        }
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        renderType: Text.NativeRendering
                    }

                    Text {
                        visible: stats.uptime !== ""
                        text: "↑ " + stats.uptime
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        renderType: Text.NativeRendering
                    }
                }

                // Load averages
                Text {
                    visible: stats.loadAvg !== ""
                    text: "Load: " + stats.loadAvg
                    color: Theme.textSecondary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSecondary
                    renderType: Text.NativeRendering
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.borderAccent
                }

                Text {
                    visible: stats.loading && coreModel.count === 0
                    text: "Loading..."
                    color: Theme.textMuted
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSecondary
                    renderType: Text.NativeRendering
                }

                // Per-core usage
                Repeater {
                    model: coreModel

                    delegate: RowLayout {
                        required property int core
                        required property int pct
                        spacing: 8

                        Text {
                            text: "Core " + core
                            color: Theme.textSecondary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 60
                        }

                        Rectangle {
                            Layout.preferredWidth: 120
                            Layout.preferredHeight: 10
                            color: Qt.rgba(1, 1, 1, 0.08)
                            radius: 3

                            Rectangle {
                                width: parent.width * (pct / 100)
                                height: parent.height
                                radius: 3
                                color: {
                                    if (pct >= 90) return "#e46876";
                                    if (pct >= 60) return "#e6c384";
                                    return Theme.neonBlue;
                                }
                            }
                        }

                        Text {
                            text: pct + "%"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 35
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }

                // Top processes section
                Rectangle {
                    visible: procModel.count > 0
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.borderAccent
                }

                Text {
                    visible: procModel.count > 0
                    text: "Top Processes"
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSecondary
                    font.bold: true
                    renderType: Text.NativeRendering
                }

                Repeater {
                    model: procModel

                    delegate: RowLayout {
                        required property string name
                        required property int pct
                        spacing: 8

                        Text {
                            text: name
                            color: Theme.textSecondary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 140
                        }

                        Text {
                            text: pct + "%"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 35
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }

                // RAM section
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.borderAccent
                }

                RowLayout {
                    spacing: 8

                    Text {
                        text: "󰘚 RAM"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        font.bold: true
                        renderType: Text.NativeRendering
                        Layout.preferredWidth: 60
                    }

                    Rectangle {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 10
                        color: Qt.rgba(1, 1, 1, 0.08)
                        radius: 3

                        Rectangle {
                            width: parent.width * (stats.service.ramPercent / 100)
                            height: parent.height
                            radius: 3
                            color: {
                                if (stats.service.ramPercent >= 90) return "#e46876";
                                if (stats.service.ramPercent >= 70) return "#e6c384";
                                return Theme.neonBlue;
                            }
                        }
                    }

                    Text {
                        text: stats.service.ramUsed + "/" + stats.service.ramTotal + "MB"
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        renderType: Text.NativeRendering
                    }
                }

                // Disk section
                RowLayout {
                    spacing: 8

                    Text {
                        text: "󰋊 Disk"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        font.bold: true
                        renderType: Text.NativeRendering
                        Layout.preferredWidth: 60
                    }

                    Rectangle {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 10
                        color: Qt.rgba(1, 1, 1, 0.08)
                        radius: 3

                        Rectangle {
                            width: parent.width * (stats.service.diskPercent / 100)
                            height: parent.height
                            radius: 3
                            color: {
                                if (stats.service.diskPercent >= 90) return "#e46876";
                                if (stats.service.diskPercent >= 70) return "#e6c384";
                                return Theme.neonBlue;
                            }
                        }
                    }

                    Text {
                        text: stats.service.diskUsed + "/" + stats.service.diskTotal
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        renderType: Text.NativeRendering
                    }
                }

                // GPU section
                RowLayout {
                    spacing: 8

                    Text {
                        text: "󰢮 GPU"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        font.bold: true
                        renderType: Text.NativeRendering
                        Layout.preferredWidth: 60
                    }

                    Rectangle {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 10
                        color: Qt.rgba(1, 1, 1, 0.08)
                        radius: 3

                        Rectangle {
                            width: parent.width * (stats.service.gpuPercent / 100)
                            height: parent.height
                            radius: 3
                            color: {
                                if (stats.service.gpuPercent >= 90) return "#e46876";
                                if (stats.service.gpuPercent >= 60) return "#e6c384";
                                return Theme.neonBlue;
                            }
                        }
                    }

                    Text {
                        text: stats.service.gpuFreq + "/" + stats.service.gpuMaxFreq + "MHz"
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        renderType: Text.NativeRendering
                    }
                }

                Text {
                    text: stats.service.gpuName
                    color: Theme.textMuted
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSecondary
                    renderType: Text.NativeRendering
                }
            }
        }
    }

    Process {
        id: cpuInfoProcess
        command: ["/home/edo/.indie-dawg-dots/archlinux/quickshell/scripts/cpu-info.sh"]

        property var cores: []
        property var procs: []

        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (!trimmed) return;
                let parts = trimmed.split("|");
                let tag = parts[0];

                if (tag === "CORE") {
                    cpuInfoProcess.cores.push({ core: parseInt(parts[1]), pct: parseInt(parts[2]) });
                } else if (tag === "LOAD") {
                    stats.loadAvg = parts[1] + "  " + parts[2] + "  " + parts[3];
                } else if (tag === "TEMP") {
                    stats.cpuTemp = parts[1];
                } else if (tag === "UPTIME") {
                    stats.uptime = parts[1];
                } else if (tag === "PROC") {
                    cpuInfoProcess.procs.push({ name: parts[1], pct: parseInt(parts[2]) });
                }
            }
        }

        onRunningChanged: {
            if (!running) {
                if (cores.length > 0) {
                    coreModel.clear();
                    for (let c of cores) coreModel.append(c);
                    cores = [];
                }
                if (procs.length > 0) {
                    procModel.clear();
                    for (let p of procs) procModel.append(p);
                    procs = [];
                }
                stats.loading = false;
            }
        }
    }

    Timer {
        interval: 1000
        running: hoverArea.containsMouse
        repeat: true
        onTriggered: {
            if (!cpuInfoProcess.running) {
                cpuInfoProcess.running = true;
            }
        }
    }
}
