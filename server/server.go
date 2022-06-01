package main

import (
	"mahesabu/util"
)

func main() {
	util.StartServer(util.StartServerArgs{
		IsServer:   true,
		Multistore: true,
		IsRelease:  false, //Todo check if it runs on production
	})
}
