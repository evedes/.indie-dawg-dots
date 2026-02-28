import QtQuick
import Quickshell.Io

QtObject {
    id: statsService

    property int cpuPercent: 0

    // Previous CPU jiffies for delta calculation
    property real prevIdle: 0
    property real prevTotal: 0

    property Process cpuProcess: Process {
        command: ["sh", "-c", "head -1 /proc/stat"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                // cpu  user nice system idle iowait irq softirq steal
                let parts = data.trim().split(/\s+/);
                if (parts.length < 5 || parts[0] !== "cpu") return;

                let user = parseInt(parts[1]) || 0;
                let nice = parseInt(parts[2]) || 0;
                let system = parseInt(parts[3]) || 0;
                let idle = parseInt(parts[4]) || 0;
                let iowait = parseInt(parts[5]) || 0;
                let irq = parseInt(parts[6]) || 0;
                let softirq = parseInt(parts[7]) || 0;
                let steal = parseInt(parts[8]) || 0;

                let totalIdle = idle + iowait;
                let total = user + nice + system + idle + iowait + irq + softirq + steal;

                if (statsService.prevTotal > 0) {
                    let deltaTotal = total - statsService.prevTotal;
                    let deltaIdle = totalIdle - statsService.prevIdle;
                    if (deltaTotal > 0) {
                        statsService.cpuPercent = Math.round(((deltaTotal - deltaIdle) / deltaTotal) * 100);
                    }
                }

                statsService.prevIdle = totalIdle;
                statsService.prevTotal = total;
            }
        }
    }

    property Timer refreshTimer: Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: cpuProcess.running = true
    }
}
