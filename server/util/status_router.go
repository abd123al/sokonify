package util

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func StatusRouter(w http.ResponseWriter, r *http.Request) {
	_, err := w.Write([]byte("Sokonify is running.........."))
	if err != nil {
		return
	}
}

func FilesRouter(w http.ResponseWriter, r *http.Request) {
	var output = "Contents in web folders are: "

	files, err := ioutil.ReadDir("./web")
	if err != nil {
		output = fmt.Sprintf("Error: %s", err.Error())
	}

	for _, f := range files {
		output += fmt.Sprintf("\n - %s \n     > %s", f.Name(), f.ModTime().String())
	}

	_, err2 := w.Write([]byte(output))
	if err2 != nil {
		return
	}
}
