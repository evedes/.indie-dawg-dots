import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import ".."

RowLayout {
    Layout.leftMargin: Theme.spacing
    Layout.fillHeight: true
    spacing: 10

    Repeater {
        model: SystemTray.items

        Image {
            id: trayIcon

            required property var modelData

            Layout.fillHeight: true
            Layout.preferredWidth: Theme.iconSize
            Layout.preferredHeight: Theme.iconSize
            Layout.alignment: Qt.AlignVCenter

            source: modelData.icon ?? ""
            sourceSize.width: Theme.iconSize
            sourceSize.height: Theme.iconSize
            smooth: true

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: event => {
                    if (event.button === Qt.LeftButton) {
                        trayIcon.modelData.activate();
                    } else if (event.button === Qt.RightButton) {
                        trayIcon.modelData.display();
                    }
                }
            }
        }
    }
}
