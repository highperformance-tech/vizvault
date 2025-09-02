package main

import (
	"fmt"
	"os"
)

var (
	version = "dev"
	commit  = "unknown"
	date    = "unknown"
)

func main() {
	if len(os.Args) > 1 {
		switch os.Args[1] {
		case "version":
			fmt.Printf("VizVault %s (%s) built at %s\n", version, commit, date)
			os.Exit(0)
		case "health":
			fmt.Println("OK")
			os.Exit(0)
		}
	}

	fmt.Println("VizVault - Backup for your Vizzes")
}
