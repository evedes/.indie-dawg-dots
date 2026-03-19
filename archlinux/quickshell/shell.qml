import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
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

            height: Theme.barHeight
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

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bottomBar

            required property var modelData
            property var screenObj: modelData

            screen: screenObj
            visible: true

            anchors {
                bottom: true
                left: true
                right: true
            }

            height: Theme.barHeight
            color: Qt.rgba(0, 0, 0, Theme.barOpacity)
            exclusionMode: ExclusionMode.Auto

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 6

                    readonly property var player: {
                        for (let i = 0; i < Mpris.players.values.length; i++) {
                            let p = Mpris.players.values[i];
                            if (p.playbackState === MprisPlaybackState.Playing) return p;
                        }
                        return Mpris.players.values.length > 0 ? Mpris.players.values[0] : null;
                    }

                    readonly property string trackInfo: {
                        if (!player || !player.trackTitle) return "";
                        let artist = player.trackArtist ?? "";
                        let title = player.trackTitle ?? "";
                        return artist ? artist + " — " + title : title;
                    }

                    text: trackInfo
                    visible: trackInfo !== "" && cavaBottom.hovered
                    color: Theme.neonBlue
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    renderType: Text.NativeRendering
                    elide: Text.ElideRight
                    Layout.maximumWidth: 400

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (parent.player) parent.player.togglePlaying();
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                Components.CavaVisualizer {
                    id: cavaBottom
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
