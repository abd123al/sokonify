package main

import "C"
import "mahesabu/util"

//export StartServer
func StartServer(Port string) string {
	return util.StartServer(util.StartServerArgs{
		Port:    Port,
		Offline: true,
	})
}

func main() {}
