package main

import "C"
import (
	"fmt"
	"mahesabu/util"
	"net"
	"strconv"
)

//export StartServer
func StartServer(Port int, IsServer bool, isRelease bool) int {
	go util.StartServer(util.StartServerArgs{
		Port:       strconv.Itoa(Port),
		IsServer:   IsServer,
		IsRelease:  isRelease,
		Multistore: true, //todo use int to show how many stores are possible
	})

	return Port
}

//export FindFreePort
func FindFreePort() int {
	addr, err := net.ResolveTCPAddr("tcp", "localhost:0")
	if err != nil {
		panic(fmt.Sprintf("Failed to get port with error: %s", err))
	}

	l, err := net.ListenTCP("tcp", addr)
	if err != nil {
		panic(fmt.Sprintf("Failed to listen to port with error: %s", err))
	}
	defer func(l *net.TCPListener) {
		err := l.Close()
		if err != nil {
			panic(fmt.Sprintf("Failed to close to port with error: %s", err))
		}
	}(l)
	return l.Addr().(*net.TCPAddr).Port
}

func main() {}
