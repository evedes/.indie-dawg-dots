import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    color: config.background
    property bool loginFailed: false

    Image {
        anchors.fill: parent
        source: config.backgroundImage
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

    Rectangle {
        anchors.fill: parent
        color: config.backgroundOverlay
    }

    function submit() {
        if (!primaryScreen)
            return;
        loginFailed = false;
        sddm.login(userField.text, passwordField.text, sessionBox.currentIndex);
    }

    Component.onCompleted: {
        userField.text = userModel.lastUser;
        sessionBox.currentIndex = sessionModel.lastIndex;
        if (!primaryScreen)
            return;
        if (userField.text === "")
            userField.forceActiveFocus();
        else
            passwordField.forceActiveFocus();
    }

    Connections {
        target: sddm
        enabled: primaryScreen

        function onLoginFailed() {
            root.loginFailed = true;
            passwordField.text = "";
            passwordField.forceActiveFocus();
        }
    }

    Timer {
        interval: 1000
        running: primaryScreen
        repeat: true
        onTriggered: clock.text = Qt.formatTime(new Date(), "HH:mm")
    }

    ColumnLayout {
        // SDDM creates one theme instance per screen.
        visible: primaryScreen
        enabled: primaryScreen
        width: 340
        anchors.centerIn: parent
        spacing: 12

        Text {
            id: clock

            Layout.fillWidth: true
            Layout.bottomMargin: 4
            text: Qt.formatTime(new Date(), "HH:mm")
            color: config.foreground
            font.family: config.font
            font.pixelSize: 72
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            Layout.fillWidth: true
            Layout.bottomMargin: 28
            text: Qt.formatDate(new Date(), "dddd, dd MMMM")
            color: config.secondary
            font.family: config.font
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
        }

        TextField {
            id: userField

            Layout.fillWidth: true
            Layout.preferredHeight: 48
            placeholderText: "Username"
            color: config.foreground
            font.family: config.font
            font.pixelSize: 15
            selectByMouse: true
            leftPadding: 16
            rightPadding: 16
            background: Rectangle {
                color: config.surface
                radius: 12
                border.width: userField.activeFocus ? 1 : 0
                border.color: config.accent
            }
            Keys.onReturnPressed: passwordField.forceActiveFocus()
            Keys.onEnterPressed: passwordField.forceActiveFocus()
        }

        TextField {
            id: passwordField

            Layout.fillWidth: true
            Layout.preferredHeight: 56
            placeholderText: "Password…"
            echoMode: TextInput.Password
            color: config.foreground
            font.family: config.font
            font.pixelSize: 15
            selectByMouse: true
            leftPadding: 16
            rightPadding: 16
            background: Rectangle {
                color: config.surface
                radius: 12
                border.width: 1
                border.color: root.loginFailed ? config.danger : passwordField.activeFocus ? config.accent : "#47ffffff"
            }
            Keys.onReturnPressed: root.submit()
            Keys.onEnterPressed: root.submit()
        }

        Text {
            visible: root.loginFailed
            Layout.fillWidth: true
            text: "Authentication failed"
            color: config.danger
            font.family: config.font
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
        }

        Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            text: "Log in"
            font.family: config.font
            font.pixelSize: 15
            onClicked: root.submit()
            contentItem: Text {
                text: parent.text
                color: config.background
                font: parent.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: config.accent
                radius: 6
            }
        }
    }

    ComboBox {
        id: sessionBox

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 28
        width: 44
        height: 44
        visible: primaryScreen
        enabled: primaryScreen
        model: sessionModel
        textRole: "name"
        font.family: config.font
        font.pixelSize: 13
        hoverEnabled: true
        Accessible.name: "Desktop session: " + currentText
        ToolTip.visible: hovered && !popup.visible
        ToolTip.delay: 500
        ToolTip.text: "Desktop session: " + currentText
        onActivated: passwordField.forceActiveFocus()

        indicator: Item {}
        contentItem: Item {
            // A monitor icon, independent of the installed icon fonts.
            Rectangle {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -2
                width: 20
                height: 14
                radius: 3
                color: "transparent"
                border.width: 1.5
                border.color: sessionBox.hovered || sessionBox.activeFocus ? config.accent : config.secondary

                Rectangle {
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 2
                    height: 4
                    color: parent.border.color
                }

                Rectangle {
                    anchors.top: parent.bottom
                    anchors.topMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 10
                    height: 1.5
                    radius: 0.75
                    color: parent.border.color
                }
            }
        }
        background: Rectangle {
            color: sessionBox.hovered || sessionBox.popup.visible ? config.surface : "transparent"
            radius: 12
            border.width: sessionBox.visualFocus ? 1 : 0
            border.color: config.accent
        }

        delegate: ItemDelegate {
            id: sessionDelegate

            required property int index
            required property string name

            width: sessionBox.popup.width - 12
            height: 44
            highlighted: sessionBox.highlightedIndex === index
            contentItem: Text {
                text: sessionDelegate.name
                color: sessionDelegate.index === sessionBox.currentIndex ? config.accent : config.foreground
                font: sessionBox.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                renderType: Text.NativeRendering
            }
            background: Rectangle {
                color: sessionDelegate.highlighted ? config.background : "transparent"
                radius: 6
            }
        }

        popup: Popup {
            x: sessionBox.width - width
            y: -height - 8
            width: Math.min(300, root.width - 56)
            height: Math.min(sessionList.contentHeight + 12, root.height - sessionBox.height - 72)
            padding: 6
            contentItem: ListView {
                id: sessionList

                clip: true
                implicitHeight: contentHeight
                model: sessionBox.popup.visible ? sessionBox.delegateModel : null
                currentIndex: sessionBox.highlightedIndex
                highlightMoveDuration: 0
                ScrollIndicator.vertical: ScrollIndicator {}
            }
            background: Rectangle {
                color: config.surface
                radius: 12
                border.width: 1
                border.color: config.secondary
            }
        }
    }
}
