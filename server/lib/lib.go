package lib

import (
	"mahesabu/util"
	"strconv"
)

// StartServer This way so that it can be invoked via libs
// We receive and return int because they are easy to deal with in native
func StartServer(Port int) int {
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
