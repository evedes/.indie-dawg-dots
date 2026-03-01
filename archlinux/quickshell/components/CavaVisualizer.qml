import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

Item {
    id: cava

    readonly property int barCount: 24
    readonly property int barWidth: 3
    readonly property int barSpacing: 2
    readonly property int topPadding: Math.round((Theme.barHeight - Theme.fontSizePrimary) / 2) + 5
    readonly property real maxBarHeight: Theme.barHeight - topPadding - 4

    Layout.fillHeight: true
    Layout.preferredWidth: barCount * (barWidth + barSpacing) - barSpacing
    Layout.rightMargin: 4

    property var barValues: new Array(barCount).fill(0)

    readonly property var barColors: {
        let colors = [];
        let stops = Theme.cavaGradient;
        for (let i = 0; i < barCount; i++) {
            let t = i / (barCount - 1) * (stops.length - 1);
            let lo = Math.floor(t);
            let hi = Math.min(lo + 1, stops.length - 1);
            let frac = t - lo;
            let c1 = Qt.color(stops[lo]);
            let c2 = Qt.color(stops[hi]);
            colors.push(Qt.rgba(
                c1.r + (c2.r - c1.r) * frac,
                c1.g + (c2.g - c1.g) * frac,
                c1.b + (c2.b - c1.b) * frac,
                1.0
            ));
        }
        return colors;
    }

    Process {
        id: cavaProcess
        command: ["cava", "-p", "/home/edo/.config/quickshell/cava-bar.conf"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                let parts = data.split(";").filter(s => s !== "");
                if (parts.length >= cava.barCount) {
                    let vals = [];
                    for (let i = 0; i < cava.barCount; i++) {
                        vals.push(Math.min(parseInt(parts[i]) || 0, 1000) / 1000.0);
                    }
                    cava.barValues = vals;
                }
            }
        }
    }

    Repeater {
        model: cava.barCount

        Rectangle {
            required property int index

            x: index * (cava.barWidth + cava.barSpacing)
            y: cava.topPadding
            width: cava.barWidth
            height: Math.max(2, (cava.barValues[index] ?? 0) * cava.maxBarHeight)
            color: cava.barColors[index] ?? Theme.accentBright
            radius: 1

            Behavior on height {
                NumberAnimation { duration: 50; easing.type: Easing.OutQuad }
            }
        }
    }
}
