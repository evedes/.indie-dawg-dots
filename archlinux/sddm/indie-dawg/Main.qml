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
        loginFailed = false;
        sddm.login(userField.text, passwordField.text, sessionBox.currentIndex);
    }

    Component.onCompleted: {
        userField.text = userModel.lastUser;
        sessionBox.currentIndex = sessionModel.lastIndex;
        if (userField.text === "")
            userField.forceActiveFocus();
        else
            passwordField.forceActiveFocus();
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            root.loginFailed = true;
            passwordField.text = "";
            passwordField.forceActiveFocus();
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatTime(new Date(), "HH:mm")
    }

    ColumnLayout {
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

        ComboBox {
            id: sessionBox

            Layout.fillWidth: true
            Layout.preferredHeight: 40
            model: sessionModel
            textRole: "name"
            font.family: config.font
            font.pixelSize: 13
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
}
