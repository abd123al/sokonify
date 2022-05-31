package lib

import (
	"mahesabu/util"
)

// StartServer This way so that it can be invoked via libs
// We receive and return int because they are easy to deal with in native
func StartServer(Dsn string, Port string) string {
	go util.StartServer(util.StartServerArgs{
		Dsn:        Dsn,
		Port:       Port,
		IsServer:   false,
		Multistore: true, //Since phone just belongs to one person
	})

	return Port
}
