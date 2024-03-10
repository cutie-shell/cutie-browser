#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngineQuick/qtwebenginequickglobal.h>
#include <QCommandLineParser>
#include <QQmlProperty>

int main(int argc, char *argv[])
{
	QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts, true);

	QtWebEngineQuick::initialize();
	QGuiApplication app(argc, argv);

	QGuiApplication::setApplicationName("cutie-browser");

	QCommandLineParser parser;
	parser.setApplicationDescription("The Browser for Cutie");
	parser.addHelpOption();

	QCommandLineOption webAppOption(
		QStringList() << "webappurl",
		QCoreApplication::translate(
			"main",
			"The url to load. If not empty, browser starts without address bar and navigation buttons."),
		QCoreApplication::translate("main", "url"));
	parser.addOption(webAppOption);
	parser.process(app);
	QString webAppUrl = parser.value(webAppOption);

	QQmlApplicationEngine engine;

	const QUrl url(QStringLiteral("qrc:/main.qml"));
	QObject::connect(
		&engine, &QQmlApplicationEngine::objectCreated, &app,
		[url](QObject *obj, const QUrl &objUrl) {
			if (!obj && url == objUrl)
				QCoreApplication::exit(-1);
		},
		Qt::QueuedConnection);
	engine.load(url);

	if (webAppUrl != "")
		QQmlProperty(engine.rootObjects()[0], "webAppUrl")
			.write(webAppUrl);

	return app.exec();
}
