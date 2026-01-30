import QtQuick
import QtQuick.Window
import QtQuick.Particles

Window {
    width: 600; height: 400
    visible: true
    color: "#0a0a0a"

    Item {
        id: root
        anchors.fill: parent
        focus: true

        // --- The Particle Loader ---
        // This physically deletes/creates the system to clear particles instantly
        Loader {
            id: particleLoader
            anchors.fill: parent
            active: controller.finished // Only exists when finished is true
            sourceComponent: confettiComponent
        }

        Component {
            id: confettiComponent
            ParticleSystem {
                id: sys
                Emitter {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    emitRate: 150
                    lifeSpan: 2000
                    velocity: AngleDirection { angle: 90; angleVariation: 30; magnitude: 200; magnitudeVariation: 50 }
                    size: 8
                }
                ImageParticle {
                    source: "qrc:///particleresources/fuzzydot.png"
                    colorVariation: 0.8
                }
            }
        }

        // --- UI Elements ---
        Text {
            id: numbertext
            anchors { top: parent.top; left: parent.left; margins: 20 }
            text: "Entry: " + number
            color: "#444"
            font.pixelSize: 18
        }

        Text {
            id: display
            anchors.centerIn: parent
            // We use a simple binding here
            text: controller.finished ? controller.average.toFixed(2) : digitText
            color: "white"
            font.pixelSize: 120
            font.bold: true
            opacity: 1.0
            scale: 1.0

            function triggerBounce() {
                bounceAnim.restart()
            }

            SequentialAnimation {
                id: bounceAnim
                // Instant reset to start state to prevent "double pop"
                PropertyAction { target: display; property: "opacity"; value: 0.0 }
                PropertyAction { target: display; property: "scale"; value: 0.7 }

                ParallelAnimation {
                    NumberAnimation { target: display; property: "opacity"; to: 1.0; duration: 150; easing.type: Easing.OutQuart }
                    NumberAnimation { target: display; property: "scale"; to: 1.0; duration: 250; easing.type: Easing.OutBack }
                }
            }
        }

        Keys.onPressed: (event) => {
            // --- RESET ---
            if (controller.finished && event.key === Qt.Key_Backspace){
                controller.reset()
                // Loader handles the confetti cleanup automatically because
                // controller.finished becomes false.
                digitText = ""
                number = 0
                event.accepted = true
                return
            }

            // --- INPUT ---
            if (event.key >= Qt.Key_1 && event.key <= Qt.Key_6 && !controller.finished) {
                let keyChar = String.fromCharCode(event.key)

                digitText = keyChar
                controller.addDigit(event.key - Qt.Key_0)
                number++

                display.triggerBounce() // Clean, single trigger
                event.accepted = true
            }

            // --- FINISH ---
            else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (!controller.finished) {
                    controller.finish()
                    display.triggerBounce()
                }
                event.accepted = true
            }
        }
    }

    property string digitText: ""
    property int number: 0
}
