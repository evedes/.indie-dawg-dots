import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import ".."

RowLayout {
    Layout.leftMargin: Theme.spacing
    Layout.fillHeight: true
    spacing: 16

    readonly property var nerdIcons: ({
        "chrome_status_icon_1": { "icon": "\uf1ff", "color": "#5865F2" },
        "spotify-client": { "icon": "󰓇", "color": "#1DB954" },
        "Nextcloud": { "icon": "󰅟", "color": "#0082C9" },
        "com.github.xeco23.WasIstLos.Tray": { "icon": "\uf232", "color": "#25D366" },
    })

    Repeater {
        model: SystemTray.items

        Loader {
            id: trayLoader

            required property var modelData

            readonly property string appId: modelData.id ?? ""
            readonly property var nerdEntry: nerdIcons[appId] ?? null

            Layout.fillHeight: true
            Layout.preferredWidth: Theme.iconSize
            Layout.preferredHeight: Theme.iconSize
            Layout.alignment: Qt.AlignVCenter

            sourceComponent: nerdEntry ? nerdComponent : imageComponent

            Component {
                id: nerdComponent

                Text {
                    text: trayLoader.nerdEntry.icon
                    color: trayLoader.nerdEntry.color
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeIcon
                    renderType: Text.NativeRendering
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: event => {
                            if (event.button === Qt.LeftButton) {
                                trayLoader.modelData.activate();
                            } else if (event.button === Qt.RightButton) {
                                trayLoader.modelData.display();
                            }
                        }
                    }
                }
            }

            Component {
                id: imageComponent

                Image {
                    source: trayLoader.modelData.icon ?? ""
                    sourceSize.width: Theme.iconSize * 2
                    sourceSize.height: Theme.iconSize * 2
                    smooth: true
                    mipmap: true

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: event => {
                            if (event.button === Qt.LeftButton) {
                                trayLoader.modelData.activate();
                            } else if (event.button === Qt.RightButton) {
                                trayLoader.modelData.display();
                            }
                        }
                    }
                }
            }
        }
    }
}
