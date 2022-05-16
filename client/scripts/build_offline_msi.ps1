Write-Host "Starting building msi..."
Set-Location $PSScriptRoot

# Run graph generate
.\generate.ps1

Set-Location $PSScriptRoot

cd..
cd..

.\server\scripts\build_dll.ps1

Set-Location $PSScriptRoot
cd..

cd apps/offline
flutter pub get
flutter pub run msix:create
