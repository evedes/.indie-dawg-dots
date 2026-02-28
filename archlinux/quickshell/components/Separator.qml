import QtQuick
import QtQuick.Layouts
import ".."

Text {
    Layout.leftMargin: Theme.spacingSmall
    Layout.rightMargin: Theme.spacingSmall

    text: "•"
    color: Theme.accentBright
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeSecondary
    verticalAlignment: Text.AlignVCenter
    Layout.fillHeight: true
}
