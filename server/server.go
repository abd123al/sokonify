package main

import (
	"mahesabu/util"
)

func main() {
	util.StartServer(util.StartServerArgs{
		IsServer:   true,
		NoOfStores: 10000,
		IsRelease:  false, //Todo check if it runs on production
	})
}
