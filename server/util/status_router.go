package util

import "net/http"

func StatusRouter(w http.ResponseWriter, r *http.Request) {
	_, err := w.Write([]byte("Sokonify is running"))
	if err != nil {
		return
	}
}
