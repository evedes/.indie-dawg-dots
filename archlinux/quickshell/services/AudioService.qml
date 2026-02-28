import QtQuick
import Quickshell.Services.Pipewire

QtObject {
    id: audioService

    readonly property PwNode sink: Pipewire.defaultAudioSink

    property int volume: 0
    property bool muted: false

    readonly property PwObjectTracker tracker: PwObjectTracker {
        objects: sink ? [sink] : []
    }

    function updateState() {
        if (sink && sink.audio) {
            volume = Math.round(sink.audio.volume * 100);
            muted = sink.audio.muted;
        }
    }

    function toggleMute() {
        if (sink && sink.audio) {
            sink.audio.muted = !sink.audio.muted;
            updateState();
        }
    }

    function adjustVolume(delta: int) {
        if (sink && sink.audio) {
            let newVol = Math.max(0, Math.min(1.0, sink.audio.volume + delta / 100.0));
            sink.audio.volume = newVol;
            updateState();
        }
    }

    property Timer pollTimer: Timer {
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: audioService.updateState()
    }
}
