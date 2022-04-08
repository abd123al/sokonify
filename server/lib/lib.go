package lib

import "mahesabu/util"

// StartServer This way so that it can be invoked via libs
func StartServer() string {
	return util.StartServer(true)
}
