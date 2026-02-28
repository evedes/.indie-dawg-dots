import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "components" as Components
import "services" as Services

ShellRoot {
    id: root

    Services.AudioService { id: audioService }
    Services.SystemStatsService { id: statsService }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData
            property var screenObj: modelData

            screen: screenObj
            visible: Hyprland.monitorFor(screen)?.name === "DP-1"

            anchors {
                top: true
                left: true
                right: true
            }

            height: Theme.barHeight
            color: Theme.bgDark
            exclusionMode: ExclusionMode.Auto

            RowLayout {
                anchors.fill: parent
                spacing: 0
                // LEFT
                Components.ArchIcon {}
                Components.Workspaces {}
                Components.SystemTray {}
                // CENTER
                Item { Layout.fillWidth: true }
                // RIGHT
                Components.CavaVisualizer {}
                Components.SystemStats {
                    service: statsService
                }
                Components.NetworkStatus {}
                Components.PingStatus {}
                Components.AudioControl {
                    service: audioService
                }
                Components.Clock {}
            }
        }
    }
}
