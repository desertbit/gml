/*
 *  GML - Go QML
 *  Copyright (c) 2019 Roland Singer [roland.singer@deserbit.com]
 *  Copyright (c) 2019 Sebastian Borchers [sebastian@deserbit.com]
 */

package main

import (
	"github.com/desertbit/gml/internal/build"
	"github.com/desertbit/grumble"
)

func init() {
	App.AddCommand(&grumble.Command{
		Name:      "build",
		Help:      "build a gml project",
		AllowArgs: false,
		Flags: func(f *grumble.Flags) {
			f.Bool("c", "clean", false, "clean build files first")
			f.BoolL("no-strip", false, "don't strip the final binary")
			f.String("s", "source-dir", "./", "source directorty")
			f.String("b", "build-dir", "./build", "build directorty")
			f.String("d", "dest-dir", "./", "destination directorty")
		},
		Run: runBuild,
	})
}

func runBuild(c *grumble.Context) error {
	return build.Build(
		c.Flags.String("source-dir"),
		c.Flags.String("build-dir"),
		c.Flags.String("dest-dir"),
		c.Flags.Bool("clean"),
		c.Flags.Bool("no-strip"),
	)
}
