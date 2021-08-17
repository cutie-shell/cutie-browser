import QtQuick 2.14
import QtWebEngine 1.7
import QtQuick.Window 2.2
import QtGraphicalEffects 1.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Cutie 1.0

Window {
    title: webview.title
    visible: true
    color: "transparent"

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

    Atmosphere {
        id: atmospheresHandler
    }

    FontLoader {
        id: icon
        source: "qrc:/fonts/Font Awesome 5 Free-Solid-900.otf"
    }

    FontLoader {
        id: mainFont
        source: "qrc:/fonts/Raleway-Regular.ttf"
    }

    FontLoader {
        id: lightFont
        source: "qrc:/fonts/Raleway-ExtraLight.ttf"
    }

    FontLoader {
        id: boldFont
        source: "qrc:/fonts/Raleway-Black.ttf"
    }

    Rectangle { 
        id: headerBar  
        width: parent.width
        height: 48
        anchors { top: parent.top; left: parent.left }
        color: "transparent"
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Item {
            id: backButton
            width: 30
            height: 30 
            anchors.left: parent.left
            anchors.leftMargin: 7
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id: backButtonIcon
                color: (atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000"
                text: "\uF053"
                font { family: icon.name; pixelSize: 28 }
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea { 
                anchors.fill: parent; anchors.margins: -1; 
                enabled: webview.canGoBack 
             //   onPressed: backButtonIcon.color = "#bf616a";
                onClicked: { webview.goBack() }
             //   onReleased: backButtonIcon.color = "#434C5E";
            }
        }

        Item {
            id: forwardButton
            width: 30
            height: 30
            anchors.left: backButton.right
            anchors.leftMargin: 7
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id: backButtonIcon1
                color: (atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000"
                text: "\uf054"
                font.pixelSize: 28
                font.family: icon.name
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -1
             //   onPressed: backButtonIcon1.color = "#bf616a"
                enabled: webview.canGoForward
                onClicked: { webview.goForward() }
               // onReleased: backButtonIcon1.color = "#434C5E"
            }
        }

        Rectangle {
            id: urlBar
            height: 36
            color: (atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000"
            border.width: 0; border.color: "#2E3440";
            visible: true
            anchors {
                left: forwardButton.right
                right: hamburger.left
                leftMargin: 7 
                rightMargin: 10
            }
            anchors.verticalCenter: parent.verticalCenter
            radius: 5
            clip: true

            TextField { 
                id: urlText
                text: ""
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                font.pixelSize: 18
                textColor: (atmospheresHandler.variant == "dark") ? "#000000" : "#ffffff"
                inputMethodHints: Qt.ImhNoAutoUppercase // url hint 
                clip: true
                style: TextFieldStyle {
                    background: Rectangle {
                        color: "transparent"
                    }
                }
                
                font.family: mainFont.name

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
                onTextChanged: {
                    //if (urlText.activeFocus && urlText.text !== "") {
                    //    Tab.queryHistory(urlText.text)
                    //} else { historyModel.clear() }
                }
            }
        }
        Rectangle {
            id: urlProgressBar
            height: 1
            visible: webview.loadProgress < 100
            width: parent.width * (webview.loadProgress/100)
            anchors { bottom: headerBar.bottom; left: parent.left }
            color: "#bf616a"
        }

        Item {
            id: hamburger
            width: 30
            height: 30
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id: iconham
                color: (atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000"
                text: "\uf0c9"
                font.pixelSize: 28
                font.family: icon.name
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -1
              //  onPressed: iconham.color = "#bf616a"
             //   enabled: webview.canGoBack
            //    onClicked: { webview.goBack() }
             //   onReleased: iconham.color = "#434C5E"
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
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors { top: headerBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        url: "https://start.duckduckgo.com"
        
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
