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
            // visible: Hyprland.monitorFor(screen)?.name === "DP-1"
            visible: true

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
                spacing: 16
                Components.ArchIcon {}
                Components.Workspaces {}
                Components.SystemTray {}
                Item { Layout.fillWidth: true }
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
