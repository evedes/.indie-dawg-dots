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
    Services.NotificationService { id: notificationService }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData
            property var screenObj: modelData

            screen: screenObj
            visible: true

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: Theme.barHeight
            color: Qt.rgba(0, 0, 0, Theme.barOpacity)
            exclusionMode: ExclusionMode.Auto

            RowLayout {
                anchors.fill: parent
                spacing: 16
                Components.ArchIcon {}
                Components.Workspaces {}
                Components.SystemTray {}
                Components.NetworkStatus {}
                Item { Layout.fillWidth: true }
                Components.SystemStats {
                    service: statsService
                }
                Components.PingStatus {}
                Components.AudioControl {
                    service: audioService
                }
                Components.Battery {}
                Components.Weather {}
                Components.DisplaySettings {
                    notificationService: notificationService
                }
            }
        }
    }
}
