Write-Host "Starting app bundle..."
Set-Location $PSScriptRoot

.\build_offline_android.ps1

flutter build apk --obfuscate --split-debug-info=./build/app/outputs/symbols --release
