import QtQuick 2.12
import QtQuick.Controls 2.12

Column {
    spacing: 8

    anchors {
        top: parent.top
        right: parent.right
    }
    
    Text {
        id: hostnameLabel

        anchors {
            top: parent.top
            right: parent.right
        }
        opacity: config.DateOpacity

        renderType: Text.NativeRendering
        font.family: config.Font
        font.pointSize: config.GeneralFontSize
        font.bold: true
        color: config.DateColor
        text: sddm.hostName
    }
}
