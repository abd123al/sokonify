Write-Host "Starting building..."
Set-Location $PSScriptRoot

# Run graph generate
.\generate.ps1

Set-Location $PSScriptRoot

cd..
cd..
.\server\scripts\build_aar.ps1

Set-Location $PSScriptRoot
cd..

cd apps/offline
flutter pub get
