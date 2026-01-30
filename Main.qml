import QtQuick
import QtQuick.Window
import QtQuick.Particles
import QtQuick.Effects // Required for MultiEffect (Blur/Glassmorphism)

Window {
    width: 600; height: 400
    visible: true
    color: "#0a0a0a"

    // --- State Properties ---
    property string digitText: ""
    property int number: 0
    property bool settingsOpen: false
    property bool fächerEnabled: true

    // Predefined array for Fächer
    property var fächerList: ["Mathematik", "Deutsch", "Englisch", "2. Fremdsprache", "WP 2", "Biologie", "Physik", "Geschichte", "Geographie", "WiPo", "Kunst/Musik", "Sport", "Religionslehre", "Chemie"]

    Item {
        id: root
        anchors.fill: parent
        focus: !settingsOpen

        // --- 1. Confetti (Nuclear Reset) ---
        Loader {
            id: particleLoader
            anchors.fill: parent
            active: controller.finished
            sourceComponent: Component {
                ParticleSystem {
                    Emitter {
                        anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width; emitRate: 150; lifeSpan: 2000
                        velocity: AngleDirection { angle: 90; angleVariation: 30; magnitude: 200; magnitudeVariation: 50 }
                        size: 8
                    }
                    ImageParticle { source: "qrc:///particleresources/fuzzydot.png"; colorVariation: 0.8 }
                }
            }
        }

        // --- 2. Fächer Label (Top Center) ---
        Text {
            id: fächerLabel
            anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 40 }
            // Logic: Only show if enabled, use modulo to prevent index out of bounds
            text: (fächerEnabled && !controller.finished) ? fächerList[number % fächerList.length] : ""
            color: "white"
            font.pixelSize: 28
            font.letterSpacing: 2
            font.weight: Font.Light
            opacity: fächerEnabled ? 0.8 : 0.0

            Behavior on opacity { NumberAnimation { duration: 300 } }
        }

        // --- 2. Fächer Label (Top Center) ---
        Text {
            id: fächerLabel_out
            anchors { top: display.bottom; horizontalCenter: parent.horizontalCenter; topMargin: 40 }
            // Logic: Only show if enabled, use modulo to prevent index out of bounds
            text: (fächerEnabled && !controller.finished && (number % fächerList.length) - 1 >= 0) ? fächerList[(number % fächerList.length) - 1] : ""
            color: "white"
            font.pixelSize: 22
            font.letterSpacing: 2
            font.weight: Font.Light
            opacity: fächerEnabled ? 0.8 : 0.0

            Behavior on opacity { NumberAnimation { duration: 300 } }
        }

        // --- 3. Main Display ---
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
            text: controller.finished ? controller.average.toFixed(2) : digitText
            color: "white"
            font.pixelSize: 120; font.bold: true

            function triggerBounce() { bounceAnim.restart() }

            SequentialAnimation {
                id: bounceAnim
                PropertyAction { target: display; properties: "opacity,scale"; value: 0 }
                ParallelAnimation {
                    NumberAnimation { target: display; property: "opacity"; to: 1.0; duration: 150 }
                    NumberAnimation { target: display; property: "scale"; from: 0.7; to: 1.0; duration: 250; easing.type: Easing.OutBack }
                }
            }
        }

        // --- 4. Settings Wheel ---
        Text {
            id: settingsIcon
            text: "⚙"
            font.pixelSize: 18
            color: settingsOpen ? "white" : "#666"
            anchors { top: parent.top; right: parent.right; margins: 20 }
            z: 100
            rotation: settingsOpen ? 90 : 0
            Behavior on rotation { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            MouseArea { anchors.fill: parent; onClicked: settingsOpen = !settingsOpen }
        }

        // --- 5. Glassmorphism Settings Panel ---
        Item {
            id: settingsContainer
            width: 240
            height: parent.height - 40
            anchors.verticalCenter: parent.verticalCenter
            x: settingsOpen ? parent.width - width - 20 : parent.width + 20
            z: 90

            Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutExpo } }

            // Background with Blur
            Rectangle {
                id: glassBg
                anchors.fill: parent
                radius: 20
                color: "#22ffffff" // Semi-transparent white
                border.color: "#44ffffff" // Thin light border
                border.width: 1
                clip: true
            }

            // The Blur Effect
            MultiEffect {
                source: glassBg
                anchors.fill: glassBg
                blurEnabled: true
                blur: 1.0
                blurMax: 32
            }

            Column {
                anchors { fill: parent; margins: 25; topMargin: 40 }
                spacing: 25

                Text { text: "Settings"; color: "white"; font.pixelSize: 22; font.bold: true }

                Row {
                    width: parent.width; spacing: 15
                    Text { text: "Fächer-Modus"; color: "white"; font.pixelSize: 16; anchors.verticalCenter: parent.verticalCenter }

                    Rectangle {
                        width: 44; height: 24; radius: 12
                        color: fächerEnabled ? "#00c853" : "#444"
                        Rectangle {
                            x: fächerEnabled ? 22 : 2; y: 2; width: 20; height: 20; radius: 10; color: "white"
                            Behavior on x { NumberAnimation { duration: 200 } }
                        }
                        MouseArea { anchors.fill: parent; onClicked: fächerEnabled = !fächerEnabled }
                    }
                }
            }
        }

        // --- 6. Controls ---
        Keys.onPressed: (event) => {
            if (settingsOpen && event.key !== Qt.Key_Escape) return;

            if (controller.finished && event.key === Qt.Key_Backspace){
                controller.reset(); digitText = ""; number = 0; event.accepted = true; return;
            }

            if (event.key >= Qt.Key_1 && event.key <= Qt.Key_6 && !controller.finished) {
                digitText = String.fromCharCode(event.key)
                controller.addDigit(event.key - Qt.Key_0)
                number++
                display.triggerBounce()
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (!controller.finished) { controller.finish(); display.triggerBounce(); }
                event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
                settingsOpen = false; event.accepted = true;
            }
        }
    }
}
