Write-Host "Starting..."
Set-Location $PSScriptRoot
cd..
go test ./...
