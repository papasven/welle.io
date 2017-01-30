import QtQuick 2.2
import QtQuick.Layouts 1.1

// Import custom styles
import "style"

Item {
    width: Units.dp(400)
    height: Units.dp(400)
    Layout.fillWidth: true
    Layout.fillHeight: true

    property int ficErrorsPerMinutTenSeconds: 0
    property string ficErrorsPerMinutTenSecondsText: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: Units.dp(5)
        anchors.leftMargin: Units.dp(5)

        TextExpert {
            id: displayCurrentChannel
            name: "Current channel:"
        }

        TextExpert {
            id: displayFreqCorr
            name: "Frequency correction:"
        }

        TextExpert {
            id: displaySNR
            name: "SNR:"
        }

        TextExpert {
            id: displaySuccessRate
            name: "Frame success rate:"
        }

        TextExpert {
            id: displaySync
            name: "Frame synchronization:"
        }

        TextExpert {
            id: displayFIC_CRC
            name: "FIC CRC:"
        }

        SpectrumView {
            Layout.preferredWidth: Units.dp(200)
            Layout.preferredHeight: Units.dp(200)
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Timer {
        interval: 10 * 1000 // 10 s
        running: true
        repeat: true
        onTriggered: {
           ficErrorsPerMinutTenSecondsText = " (" + ficErrorsPerMinutTenSeconds +" Errors / 10 s)"
           ficErrorsPerMinutTenSeconds = 0
        }
    }

    Connections{
        target: cppGUI
        onDisplayCurrentChannel:{
            displayCurrentChannel.text = Channel + " (" + Frequency/1e6 + " MHz)"
        }

        onSignalPower:{
            displaySNR.text = power + " dB"
        }

        onDisplayFreqCorr:{
            displayFreqCorr.text = Freq + " Hz"
        }

        onDisplaySuccessRate:{
            displaySuccessRate.text = Rate + " %"
        }

        onSyncFlag:{
            if(active)
                displaySync.text = "OK"
            else
                displaySync.text = "Not synced"
        }

        onFicFlag:{
            if(active)
                displayFIC_CRC.text = "OK"
            else
            {
                ficErrorsPerMinutTenSeconds++
                displayFIC_CRC.text = "Error"
            }
            displayFIC_CRC.text = displayFIC_CRC.text + ficErrorsPerMinutTenSecondsText
        }
    }
}
