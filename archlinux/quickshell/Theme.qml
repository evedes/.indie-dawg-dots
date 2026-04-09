pragma Singleton

import QtQuick

QtObject {
    // Background
    readonly property color bgDark: Qt.rgba(0, 0, 0, 0.85)
    readonly property color bgLighter: Qt.rgba(1, 1, 1, 0.1)
    property real barOpacity: 0.85
    readonly property color bgSelected: Qt.rgba(0.529, 0.808, 0.980, 0.2)

    // Text brightness (0.0–1.0)
    property real textBrightness: 0.85

    // Accent
    readonly property color accent: Qt.rgba(textBrightness * 0.76, textBrightness * 0.76, textBrightness * 0.76, 0.9)
    readonly property color accentBright: Qt.rgba(textBrightness * 0.49, textBrightness * 0.49, textBrightness * 0.49, 1.0)

    // Text
    readonly property color textPrimary: Qt.rgba(textBrightness, textBrightness, textBrightness, 0.95)
    readonly property color textSecondary: Qt.rgba(textBrightness * 0.88, textBrightness * 0.88, textBrightness * 0.88, 0.7)
    readonly property color textMuted: Qt.rgba(textBrightness * 0.76, textBrightness * 0.76, textBrightness * 0.76, 0.35)

    // Neon
    readonly property color neonBlue: "#3293F4"

    // Border
    readonly property color borderAccent: Qt.rgba(0.529, 0.808, 0.980, 0.15)

    // Cava gradient (Kanagawa palette)
    readonly property var cavaGradient: [
        "#957fb8", "#7e9cd8", "#7fb4ca", "#76946a",
        "#98bb6c", "#e6c384", "#d27e99", "#e46876"
    ]

    // Fonts
    readonly property string fontFamily: "ZedMono Nerd Font"
    readonly property int fontSizePrimary: 14
    readonly property int fontSizeSecondary: 12
    readonly property int fontSizeIcon: 12

    // Layout
    readonly property int barHeight: 32
    readonly property int iconSize: 28
    readonly property int spacing: 16
    readonly property int spacingSmall: 12
}
