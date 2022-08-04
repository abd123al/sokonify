Write-Host "Building DDl started!"
Write-Host $PSScriptRoot

Set-Location $PSScriptRoot

# Run graph generate
.\generate.ps1

#This is current dirctory
Set-Location $PSScriptRoot

# Switching to server root
cd..

Write-Host "Start Building DDl...!"

$output = "../client/packages/server/windows/lib.dll"

if (Test-Path $output) {
    Remove-Item -Verbose -Force $output
}

#Installing go and build
go build -o $output -buildmode=c-shared -ldflags="-s -w" ./c/c.go

Write-Host "Done building dll!"