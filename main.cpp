#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "controller.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Controller controller;

    engine.rootContext()->setContextProperty("controller", &controller);
    engine.loadFromModule("DigitApp", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
