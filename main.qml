import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.7
import QtGraphicalEffects 1.15
import Cutie 1.0

CutieWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Browser")

    property string browserURL: ""

    initialPage: Component {
       CutiePage {
            function fixUrl(url) {
                url = url.replace( /^\s+/, "").replace( /\s+$/, ""); // remove white space
                url = url.replace( /(<([^>]+)>)/ig, ""); // remove <b> tag 
                if (url == "") return url;
                if (url[0] == "/") { return "file://"+url; }
                if (url[0] == '.') { 
                    var str = itemMap[currentTab].url.toString();
                    var n = str.lastIndexOf('/');
                    return str.substring(0, n)+url.substring(1);
                }
                //FIXME: search engine support here
                if (url.startsWith('chrome://')) { return url; } 
                if (url.indexOf('.') < 0) { return "https://duckduckgo.com/?q="+url; }
                if (url.indexOf(":") < 0) { return "https://"+url; } 
                else { return url;}
            }

            FontLoader {
                id: icon
                source: "qrc:/fonts/Font Awesome 5 Free-Solid-900.otf"
            }

            Rectangle { 
                id: headerBar
                height: 7 * dpi.value
                anchors.topMargin: dpi.value * 2
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                color: "transparent"
                Item {
                    id: backButton
                    width: 4 * dpi.value
                    height: width
                    anchors.left: parent.left
                    anchors.leftMargin: dpi.value
                    anchors.verticalCenter: parent.verticalCenter
                    CutieLabel {
                        id: backButtonIcon
                        text: "\uF053"
                        font { family: icon.name }
                        anchors.fill: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -1
                        enabled: webview.canGoBack
                        onClicked: { webview.goBack() }
                    }
                }

                Item {
                    id: forwardButton
                    width: 4 * dpi.value
                    height: width
                    anchors.left: backButton.right
                    anchors.leftMargin: dpi.value
                    anchors.verticalCenter: parent.verticalCenter
                    CutieLabel {
                        id: backButtonIcon1
                        text: "\uf054"
                        font.family: icon.name
                        anchors.fill: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -1
                        enabled: webview.canGoForward
                        onClicked: { webview.goForward() }
                    }
                }

                Item {
                    id: urlBar
                    height: 5 * dpi.value
                    visible: true
                    anchors.left: forwardButton.right
                    anchors.right: parent.right
                    anchors.leftMargin: dpi.value
                    anchors.rightMargin: dpi.value
                    clip: true
                    anchors.verticalCenter: parent.verticalCenter

                    CutieTextField { 
                        id: urlText
                        text: ""
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        clip: true

                        Connections {
                            target: window
                            function onBrowserURLChanged () {
                                urlText.text = window.browserURL;
                            }
                        }

                        onAccepted: { 
                            webview.url = fixUrl(urlText.text);
                            webview.zoomFactor = dpi.value / 6;
                        }

                        onActiveFocusChanged: { 
                            if (urlText.activeFocus) {
                                urlText.selectAll();
                                Qt.inputMethod.show();
                            }
                        }
                    }
                }
                Rectangle {
                    id: urlProgressBar
                    height: dpi.value / 2
                    visible: webview.loadProgress < 100
                    width: parent.width * (webview.loadProgress / 100)
                    anchors.bottom: headerBar.bottom
                    anchors.left: parent.left
                    color: (themeVariantConfig.value == "dark") ? "#ffffff" : "#000000"
                }

            }

        }
    }

    WebEngineView {
        id: webview
        settings.webRTCPublicInterfacesOnly: true
        settings.touchIconsEnabled: true
        settings.spatialNavigationEnabled: true
        settings.screenCaptureEnabled: true
        settings.printElementBackgrounds: true
        settings.playbackRequiresUserGesture: true
        settings.localContentCanAccessRemoteUrls: true
        settings.linksIncludedInFocusChain: true
        settings.localContentCanAccessFileUrls: true
        settings.allowGeolocationOnInsecureOrigins: true
        settings.allowRunningInsecureContent: true
        settings.allowWindowActivationFromJavaScript: true
        settings.autoLoadIconsForPage: true
        settings.errorPageEnabled: true
        settings.focusOnNavigationEnabled: true
        settings.hyperlinkAuditingEnabled: true
        settings.javascriptCanPaste: true
        settings.javascriptCanOpenWindows: true
        settings.javascriptCanAccessClipboard: true
        settings.localStorageEnabled: true
        settings.pluginsEnabled: true
        settings.showScrollBars: false
        settings.webGLEnabled: true
        settings.fullScreenSupportEnabled: true
        settings.javascriptEnabled: true
        settings.autoLoadImages: true
        settings.accelerated2dCanvasEnabled: true
        url: "https://start.duckduckgo.com"
        transformOrigin: Item.Center
	    zoomFactor: dpi.value / 6
        anchors.centerIn: parent
        anchors.verticalCenterOffset: ((orientationConfig.value == Qt.PortraitOrientation) ? 6*dpi.value-panelSize/2
            : ((orientationConfig.value == Qt.InvertedPortraitOrientation) ? -6*dpi.value+panelSize/2
            : 0))
        anchors.horizontalCenterOffset: ((orientationConfig.value == Qt.LandscapeOrientation) ? -6*dpi.value+panelSize/2
            : ((orientationConfig.value == Qt.InvertedLandscapeOrientation) ? 6*dpi.value-panelSize/2
            : 0))
        rotation: Screen.angleBetween(orientationConfig.value, Screen.primaryOrientation)
        width: ((rotation % 180 == 0) 
            ? parent.width : parent.height)
        height: ((rotation % 180 == 0) 
            ? parent.height - 12*dpi.value : parent.width - 12*dpi.value) - panelSize
        
        profile: WebEngineProfile {
            offTheRecord: true
            httpUserAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1"
        }
        
        onLoadingChanged: {
            window.browserURL = webview.url;
            zoomFactor = dpi.value / 6;
        }

        Behavior on rotation {
            RotationAnimator { 
                duration: 200
                direction: RotationAnimator.Shortest
            }
        }

        Behavior on height {
            NumberAnimation { duration: 200 }
        }

        Behavior on width {
            NumberAnimation { duration: 200 }
        }

        Behavior on anchors.verticalCenterOffset {
            NumberAnimation { duration: 200 }
        }

        Behavior on anchors.horizontalCenterOffset {
            NumberAnimation { duration: 200 }
        }

        property real panelSize: 0
        property real imSize: (((orientationConfig.value == Qt.PortraitOrientation) || (orientationConfig.value == Qt.InvertedPortraitOrientation)) ? Qt.inputMethod.keyboardRectangle.height : Qt.inputMethod.keyboardRectangle.width)

        onImSizeChanged: {
            panelSize = imSize
        }
    }
}
