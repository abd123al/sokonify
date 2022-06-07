Write-Host "Running..."
Set-Location $PSScriptRoot
cd..
cd apps/online
flutter run --release -d R9ANB0BYKXJ --dart-define PORT=9191
Write-Host "Done gerenerating graph code!"