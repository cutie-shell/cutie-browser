import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Cutie 1.0

CutieWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Browser")

    initialPage: Component {
        Browser {}
    }
}
