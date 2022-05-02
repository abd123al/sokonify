package main

import "mahesabu/util"

// StartServer This is used by desktops apps
func StartServer(Port string) string {
	return util.StartServer(util.StartServerArgs{
		Port:    Port,
		Offline: true,
	})
}

func main() {}
