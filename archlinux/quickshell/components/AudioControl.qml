import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: audioControl

    required property var service

    Layout.fillHeight: true
    Layout.leftMargin: 24
    spacing: 4

    Text {
        Layout.fillHeight: true
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering

        readonly property string icon: {
            if (audioControl.service.muted) return "󰝟";
            let vol = audioControl.service.volume;
            if (vol > 66) return "󰕾";
            if (vol > 33) return "󰖀";
            return "󰕿";
        }

        text: icon + " " + audioControl.service.volume + "%"
        color: audioControl.service.muted ? Theme.textMuted : Theme.accentBright
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizePrimary

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: audioControl.service.toggleMute()
            onWheel: event => {
                if (event.angleDelta.y > 0) {
                    audioControl.service.adjustVolume(5);
                } else {
                    audioControl.service.adjustVolume(-5);
                }
            }
        }
    }
}
