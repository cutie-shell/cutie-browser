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

    initialPage: CutiePage {
        id: iPage
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
            height: 44
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: "transparent"
            Item {
                id: backButton
                width: 28
                height: width
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: backButtonIcon
                    text: "\uF053"
                    font { 
                        family: icon.name 
                        pixelSize: 28
                    }
                    anchors.fill: parent
                    color: (Atmosphere.variant == "dark") ? "white" : "black"
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    enabled: webview.canGoBack
                    onClicked: { webview.goBack() }
                }
            }

            Item {
                id: forwardButton
                width: 28
                height: width
                anchors.left: backButton.right
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: backButtonIcon1
                    text: "\uf054"
                    font { 
                        family: icon.name 
                        pixelSize: 28
                    }
                    anchors.fill: parent
                    color: (Atmosphere.variant == "dark") ? "white" : "black"
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    enabled: webview.canGoForward
                    onClicked: { webview.goForward() }
                }
            }

            Rectangle {
                id: urlBar
                color: (Atmosphere.variant == "dark") ? "#ffffff" : "#000000"
                radius: 8
                height: 40
                visible: true
                anchors.left: forwardButton.right
                anchors.right: parent.right
                anchors.rightMargin: 8
                clip: true
                anchors.verticalCenter: parent.verticalCenter

                TextField { 
                    id: urlText
                    text: ""
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    clip: true
                    background: Item { }
                    color: (Atmosphere.variant == "dark") ? "#000000" : "#ffffff"

                    Connections {
                        target: window
                        function onBrowserURLChanged () {
                            urlText.text = window.browserURL;
                        }
                    }

                    onAccepted: { 
                        webview.url = iPage.fixUrl(urlText.text);
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
                height: 2
                visible: webview.loadProgress < 100
                width: parent.width * (webview.loadProgress / 100)
                anchors.top: headerBar.bottom
                anchors.left: parent.left
                color: (Atmosphere.variant == "dark") ? "#ffffff" : "#000000"
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
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 23
            width: parent.width
            height: parent.height - 46
            
            profile: WebEngineProfile {
                offTheRecord: true
                httpUserAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1"
            }
            
            onLoadingChanged: {
                window.browserURL = webview.url;
                zoomFactor =  6;
            }
        }
    }
}