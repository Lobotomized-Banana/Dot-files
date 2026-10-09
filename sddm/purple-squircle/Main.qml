/***************************************************************************
* Purple Squircle SDDM theme - main #5b0ca6 / accent #490585
* Structure follows the stock Maldives theme (same SddmComponents usage).
* Managed in dotfiles (sddm/purple-squircle), installed to
* /usr/share/sddm/themes/purple-squircle by install.sh (needs root).
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index
    property string monoFont: "JetBrainsMono Nerd Font"

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "#8b2fe0"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            password.text = ""
            errorMessage.color = "#ff5577"
            errorMessage.text = textConstants.loginFailed
        }
        onInformationMessage: {
            errorMessage.color = "#ff5577"
            errorMessage.text = message
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    /* subtle dim so the card stays readable over the wallpaper */
    Rectangle {
        anchors.fill: parent
        color: "#590e0716"
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Clock {
            id: clock
            anchors.margins: 12
            anchors.top: parent.top; anchors.right: parent.right

            color: "white"
            timeFont.family: container.monoFont
            dateFont.family: container.monoFont
        }

        Rectangle {
            id: card
            anchors.centerIn: parent
            width: 400
            height: mainColumn.implicitHeight + 64

            color: "#e60e0716"
            border.color: "#5b0ca6"
            border.width: 2
            radius: 16

            Column {
                id: mainColumn
                anchors.centerIn: parent
                width: parent.width - 64
                spacing: 12
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#ece5f7"
                    verticalAlignment: Text.AlignVCenter
                    height: text.implicitHeight
                    width: parent.width
                    text: textConstants.welcomeText.arg(sddm.hostName)
                    wrapMode: Text.WordWrap
                    font.family: container.monoFont
                    font.pixelSize: 22
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                Column {
                    width: parent.width
                    spacing: 4
                    Text {
                        width: parent.width
                        text: textConstants.userName
                        color: "#c9a6ff"
                        font.family: container.monoFont
                        font.bold: true
                        font.pixelSize: 12
                    }

                    TextBox {
                        id: name
                        width: parent.width; height: 32
                        text: userModel.lastUser
                        font.family: container.monoFont
                        font.pixelSize: 14

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing : 4
                    Text {
                        width: parent.width
                        text: textConstants.password
                        color: "#c9a6ff"
                        font.family: container.monoFont
                        font.bold: true
                        font.pixelSize: 12
                    }

                    PasswordBox {
                        id: password
                        width: parent.width; height: 32
                        font.family: container.monoFont
                        font.pixelSize: 14

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    spacing: 8
                    width: parent.width
                    z: 100

                    Column {
                        z: 100
                        width: parent.width * 0.6
                        spacing : 4
                        anchors.bottom: parent.bottom

                        Text {
                            width: parent.width
                            text: textConstants.session
                            color: "#c9a6ff"
                            wrapMode: TextEdit.WordWrap
                            font.family: container.monoFont
                            font.bold: true
                            font.pixelSize: 12
                        }

                        ComboBox {
                            id: session
                            width: parent.width; height: 32
                            font.family: container.monoFont
                            font.pixelSize: 14

                            model: sessionModel
                            index: sessionModel.lastIndex

                            KeyNavigation.backtab: password; KeyNavigation.tab: layoutBox
                        }
                    }

                    Column {
                        z: 101
                        width: parent.width * 0.4 - 8
                        spacing : 4
                        anchors.bottom: parent.bottom

                        Text {
                            width: parent.width
                            text: textConstants.layout
                            color: "#c9a6ff"
                            wrapMode: TextEdit.WordWrap
                            font.family: container.monoFont
                            font.bold: true
                            font.pixelSize: 12
                        }

                        LayoutBox {
                            id: layoutBox
                            width: parent.width; height: 32
                            font.family: container.monoFont
                            font.pixelSize: 14

                            KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                        }
                    }
                }

                Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textConstants.prompt
                        color: "#a898c2"
                        font.family: container.monoFont
                        font.pixelSize: 11
                    }
                }

                Row {
                    spacing: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int btnWidth: Math.max(loginButton.implicitWidth,
                                                    shutdownButton.implicitWidth,
                                                    rebootButton.implicitWidth, 80) + 8
                    Button {
                        id: loginButton
                        text: textConstants.login
                        width: parent.btnWidth

                        onClicked: sddm.login(name.text, password.text, sessionIndex)

                        KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                    }

                    Button {
                        id: shutdownButton
                        text: textConstants.shutdown
                        width: parent.btnWidth

                        onClicked: sddm.powerOff()

                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        width: parent.btnWidth

                        onClicked: sddm.reboot()

                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
