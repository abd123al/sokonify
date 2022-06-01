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
flutter build windows --dart-define PORT="9191" --dart-define IS_SERVER="true" --obfuscate --split-debug-info=./build/app/outputs/symbols --release
flutter pub run msix:create --version "1.0.0.4" -n "sokonify_server" -d "Sokonify Server" -i "sokonify.fremium" --build-windows false