/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package main

import (
	"fmt"
	"os"

	"github.com/desertbit/gml/internal/utils"
	"github.com/desertbit/grumble"
	"github.com/fatih/color"
)

var App = grumble.New(&grumble.Config{
	Name:        "gml",
	Description: "go qml tool",
	PromptColor: color.New(color.FgGreen, color.Bold),

	Flags: func(f *grumble.Flags) {
		f.Bool("v", "verbose", false, "verbose mode")
	},
})

func init() {
	App.SetPrintASCIILogo(func(a *grumble.App) {
		fmt.Println(`  ___  __  __  __   `)
		fmt.Println(` / __)(  \/  )(  )  `)
		fmt.Println(`( (_-. )    (  )(__ `)
		fmt.Println(` \___/(_/\/\_)(____)`)
	})

	App.OnInit(func(a *grumble.App, f grumble.FlagMap) error {
		utils.Verbose = f.Bool("verbose")
		return nil
	})
}

func main() {
	err := App.Run()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
