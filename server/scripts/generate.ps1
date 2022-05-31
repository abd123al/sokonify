Write-Host "Generating code..."
Set-Location $PSScriptRoot
cd..
go run -mod=mod github.com/99designs/gqlgen generate
Write-Host "Done generating!"
