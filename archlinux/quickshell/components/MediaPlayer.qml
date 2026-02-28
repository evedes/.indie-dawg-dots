import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import ".."

Text {
    id: mediaText

    Layout.fillHeight: true
    Layout.maximumWidth: 400
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight

    color: Theme.textSecondary
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeSecondary

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
        return artist ? artist + " - " + title : title;
    }

    text: trackInfo
    visible: trackInfo !== ""

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (mediaText.player) {
                mediaText.player.togglePlaying();
            }
        }
    }
}
