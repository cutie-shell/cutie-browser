import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtWebEngine
import Qt5Compat.GraphicalEffects
import Cutie

CutieWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Browser")

    property string browserURL: ""
    property string webAppUrl: ""

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

        Item { 
            id: headerBar
            height: webAppUrl=="" ? 44 : 0
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            visible: webAppUrl==""
            CutieButton {
                id: backButton
                width: 28
                height: width
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                enabled: webview.canGoBack
                background: null
                icon.name: "go-previous-symbolic"
                icon.color: Atmosphere.textColor

                onClicked: {
                    webview.goBack()
                }
            }

            CutieButton {
                id: forwardButton
                width: 28
                height: width
                anchors.left: backButton.right
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                enabled: webview.canGoForward
                background: null
                icon.name: "go-next-symbolic"
                icon.color: Atmosphere.textColor

                onClicked: {
                    webview.goForward()
                }
            }

            CutieTextField {
                id: urlText
                anchors.left: forwardButton.right
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: ""

                Connections {
                    target: window
                    function onBrowserURLChanged () {
                        urlText.text = window.browserURL;
                    }
                }

                onAccepted: { 
                    webview.url = iPage.fixUrl(urlText.text);
                }

                onFocusChanged: {
                    if (focus) urlFocusTimer.start();
                }

                Timer {
                    id: urlFocusTimer
                    interval: 0
                    running: false
                    repeat: false
                    onTriggered: {
                        urlText.selectAll();
                    }
                }
            }
            Rectangle {
                id: urlProgressBar
                height: 3
                visible: webview.loadProgress < 100
                width: parent.width * (webview.loadProgress / 100)
                anchors.top: headerBar.bottom
                anchors.left: parent.left
                color: Atmosphere.textColor
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
            url: webAppUrl=="" ? "https://start.duckduckgo.com" : iPage.fixUrl(webAppUrl)
            transformOrigin: Item.Center
            anchors.centerIn: parent
            anchors.verticalCenterOffset: webAppUrl=="" ? -23 : 0
            width: parent.width
            height: webAppUrl=="" ? parent.height - 46 : parent.height
            
            profile: WebEngineProfile {
                offTheRecord: false
                persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
                storageName: "CutieBrowser"
                httpUserAgent: "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.5672.76 Mobile Safari/537.36"
            }
            
            onLoadingChanged: {
                window.browserURL = webview.url;
                zoomFactor =  6;
            }
        }
    }
}