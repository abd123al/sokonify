Write-Host "Starting..."
Set-Location $PSScriptRoot
cd..

$path = [Environment]::GetFolderPath("Desktop")

go build -o "$path/creator.exe" -ldflags="-s -w" ./programs/db_creator.go

Write-Host "done"