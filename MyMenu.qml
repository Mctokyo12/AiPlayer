// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls.Basic


Menu {
    id: root
    padding: 10
    delegate: MenuItem {
        id: menuItem
        contentItem: Item {
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 5

                text: menuItem.text
                color: "#fff"
            }
        }

        background: Rectangle {
            implicitWidth: 210
            implicitHeight: 35
            color: menuItem.highlighted ? Config.selecteMenu : "transparent"
            radius: 5


        }
    }

    background: Rectangle {
        implicitWidth: 210
        implicitHeight: 35
        color: Config.barreMenu
        border.color: Config.bordure
        radius: 4
    }
}


