import QtQuick 2.14
import QtWebEngine 1.7
import QtQuick.Window 2.2
import QtGraphicalEffects 1.12
import Cutie 1.0

CutiePage {
    id: w

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

                onAccepted: { 
                    webview.url = fixUrl(urlText.text);
                }

                onActiveFocusChanged: { 
                    if (urlText.activeFocus) {
                        urlText.selectAll();
                        Qt.inputMethod.show();
                    } else {
                        parent.border.color = "#2E3440"; parent.border.width = 0;
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
            color: "#bf616a"
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
        anchors.top: headerBar.bottom
        url: "https://start.duckduckgo.com"
        scale: dpi.value / 8
        width: 8*parent.width / dpi.value
        height: 8*(parent.height - headerBar.height) / dpi.value
        transformOrigin: Item.TopLeft
        
        profile: WebEngineProfile {
            offTheRecord: true
            httpUserAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1"
        }
        onLoadingChanged: {
            if (!urlText.activeFocus) {
                urlText.text = webview.url;
            }
        }
    }

}
