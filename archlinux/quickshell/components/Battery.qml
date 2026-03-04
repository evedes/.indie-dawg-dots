import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

Text {
    id: battery

    Layout.fillHeight: true
    verticalAlignment: Text.AlignVCenter

    property int percent: 0
    property bool charging: false

    readonly property string icon: {
        if (charging) return "󰂄";
        if (percent >= 90) return "󰁹";
        if (percent >= 80) return "󰂂";
        if (percent >= 70) return "󰂁";
        if (percent >= 60) return "󰂀";
        if (percent >= 50) return "󰁿";
        if (percent >= 40) return "󰁾";
        if (percent >= 30) return "󰁽";
        if (percent >= 20) return "󰁼";
        if (percent >= 10) return "󰁻";
        return "󰁺";
    }

    readonly property color displayColor: {
        if (charging) return Theme.accentBright;
        if (percent <= 15) return "#e46876";
        if (percent <= 30) return "#e6c384";
        return Theme.accentBright;
    }

    text: icon + " " + percent + "%"
    color: displayColor
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizePrimary
    renderType: Text.NativeRendering

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: capacityProc.running = true
    }

    Process {
        id: capacityProc
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
        stdout: SplitParser {
            onRead: data => {
                battery.percent = parseInt(data) || 0;
                statusProc.running = true;
            }
        }
    }

    Process {
        id: statusProc
        command: ["cat", "/sys/class/power_supply/BAT0/status"]
        stdout: SplitParser {
            onRead: data => battery.charging = (data.trim() === "Charging")
        }
    }
}
