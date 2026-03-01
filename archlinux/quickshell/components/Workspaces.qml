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

        Rectangle {
            id: wsButton

            required property int index
            readonly property int wsId: index + 1
            readonly property var hyprWs: Hyprland.workspaces.values.find(w => w.id === wsId) ?? null
            readonly property bool isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === wsId
            readonly property bool hasWindows: hyprWs !== null && hyprWs.windows > 0

            readonly property int dotSize: isActive ? 10 : hasWindows ? 7 : 5

            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: dotSize
            Layout.preferredHeight: dotSize

            radius: dotSize / 2
            color: isActive ? Theme.accentBright : hasWindows ? "transparent" : Theme.textMuted
            border.width: hasWindows && !isActive ? 1.5 : 0
            border.color: Theme.accentBright

            Behavior on Layout.preferredWidth { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
            Behavior on Layout.preferredHeight { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
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
