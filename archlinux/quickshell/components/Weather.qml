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
    ListModel { id: dailyModel }

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

    function pad(val) {
        let s = String(val);
        if (s.length === 1) return "0" + s;
        if (s.length > 1 && s[0] === "-" && s.length === 2) return "-0" + s.substring(1);
        return s;
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
            item: weather
            edges: Edges.Bottom
            gravity: Edges.Bottom
            margins.bottom: -8
        }

        implicitWidth: popupContent.width
        implicitHeight: popupContent.height
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
                    Layout.alignment: Qt.AlignBottom

                    Text {
                        visible: weather.temp !== ""
                        text: weatherIcon(weather.weatherCode) + " " + pad(weather.temp) + "°C"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: 24
                        renderType: Text.NativeRendering
                        Layout.alignment: Qt.AlignBottom
                    }

                    Text {
                        visible: weather.feelsLike !== ""
                        text: "Feels " + pad(weather.feelsLike) + "°C  󰢊 " + pad(weather.humidity) + "%  󰖝 " + pad(weather.wind) + "km/h  󰖖 " + pad(weather.precipitation) + "mm"
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSecondary
                        Layout.alignment: Qt.AlignBottom
                        renderType: Text.NativeRendering
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

                // Forecast panels side by side
                RowLayout {
                    spacing: 24
                    visible: hourlyModel.count > 0 || dailyModel.count > 0

                    // Hourly: two columns of 6
                    ColumnLayout {
                        spacing: 4

                        Text {
                            text: "Next 12 Hours"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            font.bold: true
                            renderType: Text.NativeRendering
                        }

                        RowLayout {
                            spacing: 16

                            // Left column (hours 0-6)
                            ColumnLayout {
                                spacing: 4

                                Repeater {
                                    model: Math.min(7, hourlyModel.count)

                                    delegate: RowLayout {
                                        required property int index
                                        readonly property var entry: hourlyModel.get(index)
                                        spacing: 6

                                        Text {
                                            text: entry ? entry.time : ""
                                            color: Theme.textSecondary
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeSecondary
                                            renderType: Text.NativeRendering
                                            Layout.preferredWidth: 42
                                        }
                                        Text {
                                            text: entry ? weatherIcon(entry.hCode) : ""
                                            color: Theme.textPrimary
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeSecondary
                                            renderType: Text.NativeRendering
                                            Layout.preferredWidth: 20
                                        }
                                        Text {
                                            text: entry ? pad(entry.hTemp) + "°" : ""
                                            color: Theme.textPrimary
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeSecondary
                                            renderType: Text.NativeRendering
                                            Layout.preferredWidth: 40
                                        }
                                        Text {
                                            text: entry ? "󰖖  " + pad(entry.rainProb) + "%" : ""
                                            color: Theme.textPrimary
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeSecondary
                                            renderType: Text.NativeRendering
                                        }
                                    }
                                }
                            }

                            // Right column (hours 7-13)
                            ColumnLayout {
                                spacing: 4

                                Repeater {
                                    model: Math.max(0, Math.min(7, hourlyModel.count - 7))

                                    delegate: RowLayout {
                                        required property int index
                                        readonly property var entry: hourlyModel.get(index + 7)
                                        spacing: 6

                                        Text {
                                            text: entry ? entry.time : ""
                                            color: Theme.textSecondary
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeSecondary
                                            renderType: Text.NativeRendering
                                            Layout.preferredWidth: 42
                                        }
                                        Text {
                                            text: entry ? weatherIcon(entry.hCode) : ""
                                            color: Theme.textPrimary
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeSecondary
                                            renderType: Text.NativeRendering
                                            Layout.preferredWidth: 20
                                        }
                                        Text {
                                            text: entry ? pad(entry.hTemp) + "°" : ""
                                            color: Theme.textPrimary
                                            font.family: Theme.fontFamily
                                            font.pixelSize: Theme.fontSizeSecondary
                                            renderType: Text.NativeRendering
                                            Layout.preferredWidth: 40
                                        }
                                        Text {
                                            text: entry ? "󰖖  " + pad(entry.rainProb) + "%" : ""
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

                    // Vertical separator
                    Rectangle {
                        visible: dailyModel.count > 0
                        Layout.fillHeight: true
                        width: 1
                        color: Theme.borderAccent
                    }

                    // 7-day forecast
                    ColumnLayout {
                        spacing: 4
                        visible: dailyModel.count > 0

                        Text {
                            text: "7-Day Forecast"
                            color: Theme.textPrimary
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSecondary
                            font.bold: true
                            renderType: Text.NativeRendering
                        }

                        Repeater {
                            model: dailyModel

                            delegate: RowLayout {
                                required property string day
                                required property string dMin
                                required property string dMax
                                required property int dRain
                                required property int dCode
                                spacing: 6

                                Text {
                                    text: day
                                    color: Theme.textSecondary
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeSecondary
                                    renderType: Text.NativeRendering
                                    Layout.preferredWidth: 42
                                }
                                Text {
                                    text: weatherIcon(dCode)
                                    color: Theme.textPrimary
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeSecondary
                                    renderType: Text.NativeRendering
                                    Layout.preferredWidth: 20
                                }
                                Text {
                                    text: pad(dMin) + "°"
                                    color: Theme.textMuted
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeSecondary
                                    renderType: Text.NativeRendering
                                    Layout.preferredWidth: 35
                                    horizontalAlignment: Text.AlignRight
                                }
                                Text {
                                    text: pad(dMax) + "°"
                                    color: Theme.textPrimary
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeSecondary
                                    renderType: Text.NativeRendering
                                    Layout.preferredWidth: 35
                                    horizontalAlignment: Text.AlignRight
                                }
                                Text {
                                    text: "󰖖  " + pad(dRain) + "%"
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
        }
    }

    Process {
        id: weatherProcess
        command: ["/home/edo/.indie-dawg-dots/archlinux/quickshell/scripts/weather-info.sh"]
        running: true

        property var hours: []
        property var days: []

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
                } else if (tag === "DAY") {
                    weatherProcess.days.push({
                        day: parts[1],
                        dMin: parts[2],
                        dMax: parts[3],
                        dRain: parseInt(parts[4]),
                        dCode: parseInt(parts[5])
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
                if (days.length > 0) {
                    dailyModel.clear();
                    for (let d of days) dailyModel.append(d);
                    days = [];
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
