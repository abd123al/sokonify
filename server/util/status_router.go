package util

import (
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"mime"
	"net/http"
	"os"
	"path/filepath"
)

func StatusRouter(w http.ResponseWriter, r *http.Request) {
	_, err := w.Write([]byte("Sokonify is running.........."))
	if err != nil {
		return
	}
}

func GetWebAppPath() (*string, error) {
	ex, err := os.Executable()

	if err != nil {
		fmt.Printf("Executable: %s", err.Error())
		return nil, errors.New(fmt.Sprintf("Getwd Error: %s", err.Error()))
	}

	dir := filepath.Dir(ex)
	path := filepath.Join(dir, "web")

	return &path, nil
}

func FixMimeTypes() {
	err1 := mime.AddExtensionType(".js", "text/javascript")
	if err1 != nil {
		log.Printf("Error in mime js %s", err1.Error())
	}

	err2 := mime.AddExtensionType(".css", "text/css")
	if err2 != nil {
		log.Printf("Error in mime js %s", err2.Error())
	}
}

func FilesRouter(w http.ResponseWriter, r *http.Request) {
	var output = "Contents in web folders are: "

	path, er := GetWebAppPath()
	if er != nil {
		output = fmt.Sprintf("ReadDir Error: %s", er.Error())
	} else {
		files, err := ioutil.ReadDir(*path)
		if err != nil {
			output = fmt.Sprintf("ReadDir Error: %s \ndir: %s", err.Error(), *path)
		}

		for _, f := range files {
			output += fmt.Sprintf("\n - %s \n     > %s", f.Name(), f.ModTime().String())
		}
	}

	_, err2 := w.Write([]byte(output))
	if err2 != nil {
		return
	}
}
