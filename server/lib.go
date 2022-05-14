package main

import "C"
import (
	"mahesabu/util"
	"strconv"
)

//export StartServer
func StartServer(Port int, isRelease bool) int {
	result := util.StartServer(util.StartServerArgs{
		Port:    strconv.Itoa(Port),
		Offline: true,
	})

	port, err := strconv.Atoi(result)
	if err != nil {
		return 8080
	}

	return port
}

func main() {}
