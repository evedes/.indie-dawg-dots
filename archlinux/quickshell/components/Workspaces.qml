import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."

RowLayout {
    id: workspaces

    Layout.leftMargin: 16
    Layout.fillHeight: true
    spacing: 2

    readonly property var romanNumerals: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]

    Repeater {
        model: 10

        Rectangle {
            id: wsButton

            required property int index
            readonly property int wsId: index + 1
            readonly property var hyprWs: Hyprland.workspaces.values.find(w => w.id === wsId) ?? null
            readonly property bool isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === wsId
            readonly property bool hasWindows: hyprWs !== null && hyprWs.windows > 0

            Layout.fillHeight: true
            Layout.preferredWidth: label.implicitWidth + 6
            color: isActive ? Theme.bgSelected : "transparent"
            border.color: isActive ? Theme.borderAccent : "transparent"
            border.width: isActive ? 1 : 0
            radius: 3

            Text {
                id: label
                anchors.centerIn: parent
                text: workspaces.romanNumerals[wsButton.index]
                color: wsButton.isActive || wsButton.hasWindows ? Theme.accentBright : Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizePrimary
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + wsButton.wsId)
            }

            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: event => {
            if (event.angleDelta.y > 0) {
                Hyprland.dispatch("workspace e+1");
            } else {
                Hyprland.dispatch("workspace e-1");
            }
        }
    }
}
