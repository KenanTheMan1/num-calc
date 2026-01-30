import QtQuick
import QtQuick.Window

Window {
    width: 600
    height: 400
    visible: true
    color: "black"

    Item {
        id: root
        anchors.fill: parent
        focus: true

        Text {
            id: numbertext
            anchors.top: parent.TopLeft
            text: number
            color: "white"
            font.pixelSize: 32
            opacity: 1.0
        }

        Text {
            id: display
            anchors.centerIn: parent
            text: controller.finished ? controller.average.toFixed(2) : digitText
            color: "white"
            font.pixelSize: 120
            opacity: 1.0
        }

        Keys.onPressed: event => {
            if (controller.finished && event.key === Qt.Key_Backspace){
                controller.reset()
                digitText = ""
                number = 0
                event.accepted = true
                return
            }
            if (event.key >= Qt.Key_1 && event.key <= Qt.Key_6 && !controller.finished) {
                digitText = String.fromCharCode(event.key)
                controller.addDigit(event.key - Qt.Key_0)
                number += 1
                event.accepted = true
            } else if (event.key === Qt.Key_Return) {
                controller.finish()
                event.accepted = true
            }
        }
    }

    property string digitText: ""
    property int number: 0
}
