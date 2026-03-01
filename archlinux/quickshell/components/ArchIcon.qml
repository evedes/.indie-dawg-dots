import QtQuick
import QtQuick.Layouts
import ".."

Text {
    Layout.leftMargin: 16

    text: "\uf303"
    color: Theme.accentBright
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeIcon
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    Layout.fillHeight: true
}
