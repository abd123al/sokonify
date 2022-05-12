package lib

import (
	"mahesabu/util"
)

// StartServer This way so that it can be invoked via libs
// We receive and return int because they are easy to deal with in native
func StartServer(Dsn string) string {
	return util.StartServer(util.StartServerArgs{
		Dsn:     Dsn,
		Offline: true,
	})
}
