Write-Host "Starting build_runner..."
Set-Location $PSScriptRoot
cd..
cd packages/graph
flutter pub run build_runner build --delete-conflicting-outputs
Write-Host "Done gerenerating graph code!"