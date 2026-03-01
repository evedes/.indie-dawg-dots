import QtQuick
import QtQuick.Layouts
import ".."

Text {
    id: clock

    Layout.leftMargin: 24
    Layout.rightMargin: 24
    Layout.fillHeight: true
    verticalAlignment: Text.AlignVCenter

    color: Theme.accentBright
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizePrimary
    renderType: Text.NativeRendering

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "MMM dd HH:mm")
    }

    Component.onCompleted: text = Qt.formatDateTime(new Date(), "MMM dd HH:mm")
}
