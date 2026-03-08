import QtQuick
import Quickshell.Io

QtObject {
    id: statsService

    property bool fastMode: false
    property int cpuPercent: 0
    property int ramPercent: 0
    property string ramUsed: ""
    property string ramTotal: ""
    property string diskUsed: ""
    property string diskTotal: ""
    property int diskPercent: 0
    property string gpuName: ""
    property int gpuFreq: 0
    property int gpuMaxFreq: 0
    property int gpuPercent: 0

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

    property Process sysInfoProcess: Process {
        command: ["/home/edo/.indie-dawg-dots/archlinux/quickshell/scripts/system-info.sh"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split("|");
                if (parts[0] === "RAM") {
                    statsService.ramUsed = parts[1];
                    statsService.ramTotal = parts[2];
                    statsService.ramPercent = parseInt(parts[3]);
                } else if (parts[0] === "DISK") {
                    statsService.diskUsed = parts[1];
                    statsService.diskTotal = parts[2];
                    statsService.diskPercent = parseInt(parts[3]);
                } else if (parts[0] === "GPU") {
                    statsService.gpuName = parts[1];
                    statsService.gpuFreq = parseInt(parts[2]);
                    statsService.gpuMaxFreq = parseInt(parts[3]);
                    statsService.gpuPercent = parseInt(parts[4]);
                }
            }
        }
    }

    property Timer refreshTimer: Timer {
        interval: 1000
        running: statsService.fastMode
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProcess.running = true;
            sysInfoProcess.running = true;
        }
    }
}
