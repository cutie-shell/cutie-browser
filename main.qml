import QtQuick 2.14
import Cutie 1.0

Item {
    id: mainItem

    function newTab() {
        var component = Qt.createComponent("browser.qml");
        var window = component.createObject(mainItem);
        window.show()
    }

    Component.onCompleted: {
        newTab();
    }
}
