Write-Host "Starting build_runner..."
Set-Location $PSScriptRoot
cd..
cd packages/graph
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
Write-Host "Done!"