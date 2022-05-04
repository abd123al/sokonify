package main

import "C"
import "mahesabu/util"

//export StartServer
func StartServer() int {
	util.StartServer(util.StartServerArgs{
		Port:    "8080",
		Offline: true,
	})

	return 8080
}

func main() {}
