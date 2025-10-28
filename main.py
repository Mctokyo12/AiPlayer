# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtCore import (QItemSelection, QLibraryInfo, QLocale, QTranslator,Slot)
from PySide6.QtMultimedia import QMediaPlayer
from PySide6.QtQml import QQmlApplicationEngine,qmlRegisterSingletonInstance,QQmlComponent
import os

def load_config(engine):
    config_path = os.path.join(os.path.dirname(__file__), "Config.qml")
    component = QQmlComponent(engine, config_path)
    config_instance = component.create()

    if config_instance is None:
        print("Erreur lors du chargement de Config.qml:", component.errorString())
        sys.exit(-1)

        # Enregistrer Config.qml comme singleton
        qmlRegisterSingletonInstance("App", 1, 0, "Config", config_instance)  # Correction ici


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Charger Config.qml comme singleton
    load_config(engine)

    translator = QTranslator(app)

    if translator.load(QLocale.system(), 'iaplayer', '_'):
        app.installTranslator(translator)



    # Charger le fichier QML principal
    main_qml_file = os.path.join(os.path.dirname(__file__), "main.qml")
    engine.load(main_qml_file)

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

    
