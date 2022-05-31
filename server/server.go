package main

import (
	"mahesabu/util"
)

func main() {
	util.StartServer(util.StartServerArgs{
		IsServer:   false,
		Multistore: true,
	})
}
