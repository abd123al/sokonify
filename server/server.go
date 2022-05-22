package main

import (
	"mahesabu/util"
)

func main() {
	util.StartServer(util.StartServerArgs{
		Offline:    false,
		Multistore: true,
	})
}
