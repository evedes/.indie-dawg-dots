import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

Text {
    id: ping

    Layout.fillHeight: true
    Layout.leftMargin: 24
    verticalAlignment: Text.AlignVCenter

    property string pingMs: ""

    text: pingMs ? "󰹨 " + pingMs + "ms" : "󰹨 ..."
    color: Theme.accentBright
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizePrimary
    renderType: Text.NativeRendering

    Process {
        id: pingProcess
        command: ["sh", "-c", "ping -c 1 -W 2 8.8.8.8 | grep -oP 'time=\\K[\\d.]+'"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (trimmed) ping.pingMs = Math.round(parseFloat(trimmed)).toString();
            }
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: pingProcess.running = true
    }
}
