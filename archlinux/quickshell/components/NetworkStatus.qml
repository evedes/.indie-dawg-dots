import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

Text {
    id: network

    Layout.fillHeight: true
    Layout.leftMargin: 24
    verticalAlignment: Text.AlignVCenter

    property string ipAddress: "..."

    text: "odin-bridge " + ipAddress
    color: Theme.accentBright
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizePrimary

    Process {
        id: ipProcess
        command: ["sh", "-c", "ip -4 -o addr show dev odin-bridge | awk '{print $4}'"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (trimmed) network.ipAddress = trimmed;
            }
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: ipProcess.running = true
    }
}
