Write-Host "Building DDl started!"
Write-Host $PSScriptRoot

#This is current dirctory
Set-Location $PSScriptRoot

# Switching to server root
cd..

#Installing go and build
go build -o ../client/packages/server/windows/lib.dll -buildmode=c-shared -ldflags="-s -w" ./lib.go

Write-Host "Done!"