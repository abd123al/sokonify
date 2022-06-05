Write-Host "Building aar started!"
Write-Host $PSScriptRoot

Set-Location $PSScriptRoot

# Run graph generate
.\generate.ps1

#This is current dirctory
Set-Location $PSScriptRoot

# Switching to server root
cd..

#Installing go and build
go install golang.org/x/mobile/cmd/gomobile@latest
go install golang.org/x/mobile/cmd/gobind@latest
go get golang.org/x/mobile/cmd/gobind
go get golang.org/x/mobile/cmd/gomobile
gomobile init

gomobile bind -v -o ../client/packages/server/android/libs/server.aar -target=android  -ldflags="-s -w" ./lib

Write-Host "Done!"
