import QtQuick
import QtQuick.Layouts
import ".."

Text {
    required property var service

    Layout.fillHeight: true
    Layout.leftMargin: 24
    verticalAlignment: Text.AlignVCenter

    text: "󰍛 " + service.cpuPercent + "%"
    color: Theme.accentBright
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizePrimary
    renderType: Text.NativeRendering
}
