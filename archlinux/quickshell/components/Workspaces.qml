import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."

RowLayout {
    id: workspaces

    Layout.leftMargin: 16
    Layout.fillHeight: true
    spacing: 8

    Repeater {
        model: 10

        Text {
            id: wsButton

            required property int index
            readonly property int wsId: index + 1
            readonly property var hyprWs: Hyprland.workspaces.values.find(w => w.id === wsId) ?? null
            readonly property bool isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === wsId
            readonly property bool hasWindows: hyprWs !== null && hyprWs.windows > 0

            visible: isActive || hasWindows
            Layout.alignment: Qt.AlignVCenter

            text: "[" + (wsId === 10 ? "0" : wsId) + "]"
            color: isActive ? Theme.accentBright : Theme.textSecondary
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSecondary
            font.bold: isActive
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter

            Behavior on color { ColorAnimation { duration: 150 } }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + wsButton.wsId)
            }
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
