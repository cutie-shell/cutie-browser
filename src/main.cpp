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
		QStringList() << "a"
			      << "webapp",
		QCoreApplication::translate(
			"main",
			"Start browser without address bar and navigation buttons."));
	parser.addOption(webAppOption);
	parser.addPositionalArgument(
		"url",
		QCoreApplication::translate("main", "URL to open, optionally."),
		"[url]");
	parser.process(app);

	bool webApp = parser.isSet(webAppOption);
	QString urlToLoad;
	if (!parser.positionalArguments().empty())
		urlToLoad = parser.positionalArguments().first();

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

	QQmlProperty(engine.rootObjects()[0], "webApp").write(webApp);
	if (!urlToLoad.isEmpty())
		QMetaObject::invokeMethod(
			engine.rootObjects()[0], "browse",
			Q_ARG(QVariant,
			      QVariant::fromValue<QString>(urlToLoad)));

	return app.exec();
}
