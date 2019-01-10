package main

import (
	"os"
	"os/exec"
)

func runCommand(dir, cmdStr string, args ...string) error {
	cmd := exec.Command(cmdStr, args...)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	cmd.Dir = dir
	// TODO:
	//cmd.Env = env
	return cmd.Run()
}
