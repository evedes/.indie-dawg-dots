import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import ".."

RowLayout {
    Layout.leftMargin: Theme.spacing
    Layout.fillHeight: true
    spacing: 16

    Repeater {
        model: SystemTray.items

        Loader {
            id: trayLoader

            required property var modelData

            readonly property string appId: modelData.id ?? ""
            readonly property bool hasIcon: (modelData.icon ?? "") !== ""

            active: true
            Layout.fillHeight: true
            Layout.preferredWidth: Theme.fontSizePrimary
            Layout.preferredHeight: Theme.fontSizePrimary
            Layout.alignment: Qt.AlignVCenter

            sourceComponent: hasIcon ? imageComponent : null

            Component {
                id: imageComponent

                Image {
                    source: trayLoader.modelData.icon ?? ""
                    sourceSize.width: Theme.fontSizePrimary * 2
                    sourceSize.height: Theme.fontSizePrimary * 2
                    fillMode: Image.PreserveAspectFit
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
