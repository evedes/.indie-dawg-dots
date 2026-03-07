import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: weather

    Layout.fillHeight: true
    Layout.leftMargin: 24
    implicitWidth: label.implicitWidth

    property string temp: ""
    property string feelsLike: ""
    property string humidity: ""
    property string wind: ""
    property int weatherCode: -1
    property string precipitation: ""
    property string city: ""
    property bool loading: false

    ListModel { id: hourlyModel }

    function weatherIcon(code) {
        if (code <= 0) return "󰖙";        // clear
        if (code <= 2) return "󰖕";        // partly cloudy
        if (code === 3) return "󰖐";       // overcast
        if (code <= 49) return "󰖑";       // fog
        if (code <= 59) return "󰖗";       // drizzle
        if (code <= 69) return "󰖖";       // rain
        if (code <= 79) return "󰼶";       // snow
        if (code <= 84) return "󰖖";       // rain showers
        if (code <= 89) return "󰼶";       // snow showers
        if (code <= 99) return "󰙾";       // thunderstorm
        return "󰖙";
    }

    function weatherDesc(code) {
        if (code === 0) return "Clear sky";
        if (code === 1) return "Mainly clear";
        if (code === 2) return "Partly cloudy";
        if (code === 3) return "Overcast";
        if (code <= 49) return "Fog";
        if (code <= 55) return "Drizzle";
        if (code <= 59) return "Freezing drizzle";
        if (code <= 65) return "Rain";
        if (code <= 69) return "Freezing rain";
        if (code <= 75) return "Snowfall";
        if (code <= 79) return "Snow grains";
        if (code <= 82) return "Rain showers";
        if (code <= 86) return "Snow showers";
        if (code <= 99) return "Thunderstorm";
        return "Unknown";
    }

    Text {
        id: label
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter

        text: weather.temp !== "" ? weatherIcon(weather.weatherCode) + " " + weather.temp + "°C" : "󰖙 ..."
        color: Theme.accentBright
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizePrimary
        renderType: Text.NativeRendering
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true

        onContainsMouseChanged: {
            if (containsMouse && !weatherProcess.running) {
                weather.loading = true;
                weatherProcess.running = true;
            }
        }
    }

    PopupWindow {
        id: popup
        visible: hoverArea.containsMouse

        anchor {
            window: weather.QsWindow.window
            rect: weather.mapToItem(null, 0, 0, weather.width, weather.height)
            edges: Edges.Bottom
            gravity: Edges.Bottom | Edges.Left | Edges.Right
        }

        width: popupContent.width
        height: popupContent.height
        color: "transparent"

        Rectangle {
            id: popupContent
            width: col.width + 32
            height: col.height + 24
            color: Theme.bgDark
            radius: 8
            border.color: Theme.borderAccent
            border.width: 1

            ColumnLayout {
                id: col
                anchors.centerIn: parent
                spacing: 6

                // Header: city + condition
                RowLayout {
                    spacing: 12

                    Text {
                        text: weather.city || "Weather"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizePrimary
                        font.bold: true
                        renderType: Text.NativeRendering
                    }

                    Text {
                        visible: weather.weatherCode >= 0
                        text: weatherDesc(weather.weatherCode)
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        renderType: Text.NativeRendering
                    }
                }

                // Current conditions
                RowLayout {
                    spacing: 16

                    Text {
                        visible: weather.temp !== ""
                        text: weatherIcon(weather.weatherCode) + " " + weather.temp + "°C"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: 24
                        renderType: Text.NativeRendering
                    }

                    ColumnLayout {
                        spacing: 2

                        Text {
                            visible: weather.feelsLike !== ""
                            text: "Feels " + weather.feelsLike + "°C"
                            color: Theme.textSecondary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                        }

                        Text {
                            visible: weather.humidity !== ""
                            text: "󰢊 " + weather.humidity + "%  󰖝 " + weather.wind + "km/h"
                            color: Theme.textSecondary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                        }

                        Text {
                            visible: weather.precipitation !== ""
                            text: "󰖖 " + weather.precipitation + "mm"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.borderAccent
                }

                Text {
                    visible: weather.loading && hourlyModel.count === 0
                    text: "Loading..."
                    color: Theme.textMuted
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSecondary
                    renderType: Text.NativeRendering
                }

                // Hourly forecast header
                Text {
                    visible: hourlyModel.count > 0
                    text: "Next 12 Hours"
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSecondary
                    font.bold: true
                    renderType: Text.NativeRendering
                }

                Repeater {
                    model: hourlyModel

                    delegate: RowLayout {
                        required property string time
                        required property string hTemp
                        required property int rainProb
                        required property int hCode
                        spacing: 8

                        Text {
                            text: time
                            color: Theme.textSecondary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 50
                        }

                        Text {
                            text: weatherIcon(hCode)
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 25
                        }

                        Text {
                            text: hTemp + "°C"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                            Layout.preferredWidth: 55
                        }

                        Text {
                            text: "󰖖 " + rainProb + "%"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            renderType: Text.NativeRendering
                        }
                    }
                }
            }
        }
    }

    Process {
        id: weatherProcess
        command: ["/home/edo/.indie-dawg-dots/archlinux/quickshell/scripts/weather-info.sh"]
        running: true

        property var hours: []

        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (!trimmed) return;
                let parts = trimmed.split("|");
                let tag = parts[0];

                if (tag === "LOCATION") {
                    weather.city = parts[1];
                } else if (tag === "CURRENT") {
                    weather.temp = parts[1];
                    weather.feelsLike = parts[2];
                    weather.humidity = parts[3];
                    weather.wind = parts[4];
                    weather.weatherCode = parseInt(parts[5]);
                    weather.precipitation = parts[6];
                } else if (tag === "HOUR") {
                    weatherProcess.hours.push({
                        time: parts[1],
                        hTemp: parts[2],
                        rainProb: parseInt(parts[3]),
                        hCode: parseInt(parts[4])
                    });
                }
            }
        }

        onRunningChanged: {
            if (!running) {
                if (hours.length > 0) {
                    hourlyModel.clear();
                    for (let h of hours) hourlyModel.append(h);
                    hours = [];
                }
                weather.loading = false;
            }
        }
    }

    Timer {
        interval: 600000  // 10 minutes
        running: true
        repeat: true
        onTriggered: weatherProcess.running = true
    }
}
