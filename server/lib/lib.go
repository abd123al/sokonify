package lib

import "mahesabu/util"

// StartServer This way so that it can be invoked via libs
func StartServer(Port string) string {
	return util.StartServer(util.StartServerArgs{
		Port:    Port,
		Offline: true,
	})
}
