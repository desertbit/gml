/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package main

import (
	"log"
	"os"

	"github.com/desertbit/gml"
)

func main() {
	app, err := gml.NewApp()
	if err != nil {
		log.Fatalln(err)
	}

	err = app.LoadData(qmlData)
	if err != nil {
		log.Fatalln(err)
	}

	os.Exit(app.Exec())
}

const qmlData = `
import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

ApplicationWindow {
    id: window
    width: 300
    height: 300
    visible: true

	Text {
		text: "Hello world!"
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		font.pointSize: 24
		font.bold: true
	}
}
`
