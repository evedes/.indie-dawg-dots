pragma Singleton

import QtQuick

QtObject {
    // Background
    readonly property color bgDark: Qt.rgba(0, 0, 0, 0.85)
    readonly property color bgLighter: Qt.rgba(1, 1, 1, 0.1)
    readonly property color bgSelected: Qt.rgba(0.529, 0.808, 0.980, 0.2)

    // Accent
    readonly property color accent: Qt.rgba(0.529, 0.808, 0.980, 0.9)
    readonly property color accentBright: "#B4D4FF"

    // Text
    readonly property color textPrimary: Qt.rgba(0.678, 0.847, 0.902, 0.95)
    readonly property color textSecondary: Qt.rgba(0.529, 0.808, 0.980, 0.7)
    readonly property color textMuted: Qt.rgba(0.529, 0.808, 0.980, 0.35)

    // Border
    readonly property color borderAccent: Qt.rgba(0.529, 0.808, 0.980, 0.15)

    // Cava gradient (Kanagawa palette)
    readonly property var cavaGradient: [
        "#957fb8", "#7e9cd8", "#7fb4ca", "#76946a",
        "#98bb6c", "#e6c384", "#d27e99", "#e46876"
    ]

    // Fonts
    readonly property string fontFamily: "ZedMono Nerd Font"
    readonly property int fontSizePrimary: 19
    readonly property int fontSizeSecondary: 16
    readonly property int fontSizeIcon: 20

    // Layout
    readonly property int barHeight: 40
    readonly property int iconSize: 20
    readonly property int spacing: 12
    readonly property int spacingSmall: 8
}
