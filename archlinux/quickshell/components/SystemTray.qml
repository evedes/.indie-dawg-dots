import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import ".."

RowLayout {
    Layout.leftMargin: Theme.spacing
    Layout.fillHeight: true
    spacing: 16

    readonly property var nerdIcons: ({
        "chrome_status_icon_1": { "icon": "\uf1ff", "color": "#6A6A6A" },
        "spotify-client": { "icon": "󰓇", "color": "#6A6A6A" },
        "Nextcloud": { "icon": "󰅟", "color": "#6A6A6A" },
        "com.github.xeco23.WasIstLos.Tray": { "icon": "\uf232", "color": "#6A6A6A" },
    })

    Repeater {
        model: SystemTray.items

        Loader {
            id: trayLoader

            required property var modelData

            readonly property string appId: modelData.id ?? ""
            readonly property var nerdEntry: nerdIcons[appId] ?? null

            active: nerdEntry !== null
            Layout.fillHeight: true
            Layout.preferredWidth: Theme.iconSize
            Layout.preferredHeight: Theme.iconSize
            Layout.alignment: Qt.AlignVCenter

            sourceComponent: nerdComponent

            Component {
                id: nerdComponent

                Text {
                    text: trayLoader.nerdEntry.icon
                    color: trayLoader.nerdEntry.color
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizePrimary
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
