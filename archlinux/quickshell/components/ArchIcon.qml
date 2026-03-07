import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

RowLayout {
    Layout.leftMargin: 16
    Layout.fillHeight: true
    spacing: 8

    property string hostName: ""

    Text {
        text: "\uf303"
        color: Theme.neonBlue
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeIcon
        renderType: Text.NativeRendering
        verticalAlignment: Text.AlignVCenter
        Layout.fillHeight: true
    }

    Text {
        text: hostName.toUpperCase()
        visible: hostName !== ""
        color: Theme.neonBlue
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizePrimary
        renderType: Text.NativeRendering
        verticalAlignment: Text.AlignVCenter
        Layout.fillHeight: true
    }

    Process {
        command: ["cat", "/etc/hostname"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (trimmed) hostName = trimmed;
            }
        }
    }
}
