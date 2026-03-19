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

    function formatClock() {
        var now = new Date();
        var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        var day = now.getDate();
        var suffix = (day === 1 || day === 21 || day === 31) ? "st"
                   : (day === 2 || day === 22) ? "nd"
                   : (day === 3 || day === 23) ? "rd"
                   : "th";
        return days[now.getDay()] + ", " + Qt.formatDateTime(now, "MMM d") + suffix + ", " + Qt.formatDateTime(now, "HH:mm");
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: clock.text = clock.formatClock()
    }

    Component.onCompleted: text = formatClock()
}
