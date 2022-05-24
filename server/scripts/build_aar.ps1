Write-Host "Building aar started!"
Write-Host $PSScriptRoot

#This is current dirctory
Set-Location $PSScriptRoot

# Switching to server root
cd..

#Installing go and build
go get -d golang.org/x/mobile/cmd/gomobile
gomobile bind -v -o ../client/packages/server/android/libs/server.aar -target=android  -ldflags="-s -w" ./lib

Write-Host "Done!"
