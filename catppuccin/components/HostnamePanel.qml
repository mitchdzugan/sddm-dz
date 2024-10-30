import QtQuick 2.12
import QtQuick.Controls 2.12

Column {
    spacing: 8

    anchors {
        bottom: parent.bottom
        horizontalCenter: parent.horizontalCenter
    }
    
    Text {
        id: hostnameLabel

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        opacity: config.DateOpacity

        renderType: Text.NativeRendering
        font.family: config.Font
        font.pointSize: config.DateSize
        font.bold: config.DateIsBold == "true" ? true : false
        color: config.DateColor
        text: sddm.hostName
    }
}
